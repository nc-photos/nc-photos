package com.nkming.nc_photos.np_platform_uploader

import android.annotation.SuppressLint
import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.nkming.nc_photos.np_android_core.getPendingIntentFlagImmutable
import com.nkming.nc_photos.np_android_core.logD
import com.nkming.nc_photos.np_android_core.logE
import com.nkming.nc_photos.np_android_core.logI
import com.nkming.nc_photos.np_android_core.use
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch
import java.net.HttpURLConnection
import java.net.URL

internal class UploadService : Service(), CoroutineScope by MainScope() {
	companion object {
		private const val CHANNEL_ID = "UploadService"
		private const val ACTION_CANCEL = "cancel"
		const val EXTRA_CONTENT_URIS = "contentUris"
		const val EXTRA_END_POINTS = "endPoints"
		const val EXTRA_HEADERS = "headers"

		private const val TAG = "UploadService"
	}

	override fun onBind(intent: Intent?): IBinder? = null

	@SuppressLint("WakelockTimeout")
	override fun onCreate() {
		logI(TAG, "[onCreate] Service created")
		super.onCreate()
		wakeLock.acquire()
		createNotificationChannel()
	}

	override fun onDestroy() {
		logI(TAG, "[onDestroy] Service destroyed")
		wakeLock.release()
		super.onDestroy()
	}

	override fun onStartCommand(
		intent: Intent?,
		flags: Int,
		startId: Int
	): Int {
		if (intent == null) {
			// service previously killed by system
			if (notificationManager.areNotificationsEnabled()) {
				notificationManager.notify(
					K.KILLED_NOTIFICATION_ID, buildKilledNotification()
				)
			}
			stopSelf()
			return START_STICKY
		}
		if (!isForeground) {
			try {
				startForeground(
					K.FG_SERVICE_NOTIFICATION_ID, buildNotification()
				)
				isForeground = true
			} catch (e: Throwable) {
				// ???
				logE(TAG, "[onStartCommand] Failed while startForeground", e)
			}
		}
		doWork(intent, startId)
		return START_STICKY
	}

	private fun doWork(intent: Intent, startId: Int) {
		val contentUris =
			intent.extras!!.getStringArrayList(EXTRA_CONTENT_URIS)!!
		val endPoints = intent.extras!!.getStringArrayList(EXTRA_END_POINTS)!!
		assert(contentUris.size == endPoints.size)
		val headers = intent.extras!!.getSerializable(
			EXTRA_HEADERS
		) as HashMap<String, String>

		launch(Dispatchers.IO) {
			val products = hashMapOf<String, Boolean>()
			for ((uri, endPoint) in contentUris.zip(endPoints)) {
				val basename = endPoint.substringAfterLast("/")
				logI(TAG, "[doWork] Uploading $basename")
				if (notificationManager.areNotificationsEnabled()) {
					notificationManager.notify(
						K.FG_SERVICE_NOTIFICATION_ID,
						buildNotification(content = basename)
					)
				}
				try {
					(URL(
						endPoint
					).openConnection() as HttpURLConnection).apply {
						requestMethod = "PUT"
						instanceFollowRedirects = true
						connectTimeout = 8000
						for (e in headers.entries) {
							setRequestProperty(e.key, e.value)
						}
						doOutput = true
					}.use { conn ->
						val cr = contentResolver
						cr.openInputStream(Uri.parse(uri))!!.use { iStream ->
							conn.outputStream.use { oStream ->
								iStream.copyTo(oStream)
							}
						}
						val responseCode = conn.responseCode
						if (responseCode / 100 != 2) {
							logE(
								TAG,
								"[doWork] Failed uploading file: HTTP$responseCode"
							)
							throw HttpException(
								responseCode,
								"Failed uploading file (HTTP$responseCode)"
							)
						}
						products[uri] = true
					}
				} catch (e: Throwable) {
					logE(TAG, "[doWork] Exception", e)
					products[uri] = false
				}
			}
			notificationManager.cancel(K.FG_SERVICE_NOTIFICATION_ID)
			stopSelf(startId)
		}
	}

	private fun createNotificationChannel() {
		val channel = NotificationChannelCompat.Builder(
			CHANNEL_ID, NotificationManagerCompat.IMPORTANCE_LOW
		).run {
			setName("Upload")
			setDescription("Upload files to your server in the background")
			build()
		}
		notificationManager.createNotificationChannel(channel)
	}

	private fun buildNotification(content: String? = null): Notification {
		val cancelIntent = Intent(this, UploadService::class.java).apply {
			action = ACTION_CANCEL
		}
		val cancelPendingIntent = PendingIntent.getService(
			this, 0, cancelIntent, getPendingIntentFlagImmutable()
		)
		return NotificationCompat.Builder(this, CHANNEL_ID).run {
			setSmallIcon(android.R.drawable.stat_sys_upload)
			setContentTitle("Uploading file")
			if (content != null) setContentText(content)
			addAction(
				0, getString(android.R.string.cancel), cancelPendingIntent
			)
			build()
		}
	}

	private fun buildKilledNotification(): Notification {
		return NotificationCompat.Builder(this, CHANNEL_ID).run {
			setSmallIcon(android.R.drawable.stat_notify_error)
			setContentTitle("File upload interrupted")
			setContentText("The service was terminated by the system")
			build()
		}
	}

	private var isForeground = false

	private val notificationManager by lazy {
		NotificationManagerCompat.from(this)
	}
	private val wakeLock: PowerManager.WakeLock by lazy {
		(getSystemService(Context.POWER_SERVICE) as PowerManager).newWakeLock(
			PowerManager.PARTIAL_WAKE_LOCK, "nc-photos:UploadService"
		).apply {
			setReferenceCounted(false)
		}
	}
}
