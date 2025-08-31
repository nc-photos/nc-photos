package com.nkming.nc_photos.np_platform_uploader

import android.annotation.SuppressLint
import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
import android.net.Uri
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.ServiceCompat
import com.nkming.nc_photos.np_android_core.getPendingIntentFlagImmutable
import com.nkming.nc_photos.np_android_core.logE
import com.nkming.nc_photos.np_android_core.logI
import com.nkming.nc_photos.np_android_core.use
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch
import java.net.HttpURLConnection
import java.net.URL
import java.util.LinkedList
import java.util.Queue

internal class UploadService : Service(), CoroutineScope by MainScope() {
	companion object {
		private const val CHANNEL_ID = "UploadService"
		private const val ACTION_CANCEL = "cancel"
		const val EXTRA_CONTENT_URIS = "contentUris"
		const val EXTRA_END_POINTS = "endPoints"
		const val EXTRA_HEADERS = "headers"

		private const val TAG = "UploadService"

		private val workQueue: Queue<UploadJob> = LinkedList()
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
			synchronized(workQueue) {
				if (workQueue.isEmpty()) {
					stopSelf()
				}
			}
			return START_STICKY
		}
		if (!isForeground) {
			try {
				ServiceCompat.startForeground(
					this, K.FG_SERVICE_NOTIFICATION_ID, buildNotification(),
					FOREGROUND_SERVICE_TYPE_DATA_SYNC
				)
				isForeground = true
			} catch (e: Throwable) {
				// ???
				logE(TAG, "[onStartCommand] Failed while startForeground", e)
			}
		}
		doWork(intent)
		return START_STICKY
	}

	private fun doWork(intent: Intent) {
		if (intent.action == ACTION_CANCEL) {
			if (notificationManager.areNotificationsEnabled()) {
				notificationManager.notify(
					K.FG_SERVICE_NOTIFICATION_ID, buildCanceledNotification()
				)
			}
			shouldCancel = true
		} else {
			val contentUris =
				intent.extras!!.getStringArrayList(EXTRA_CONTENT_URIS)!!
			val endPoints =
				intent.extras!!.getStringArrayList(EXTRA_END_POINTS)!!
			assert(contentUris.size == endPoints.size)
			val headers = intent.extras!!.getSerializable(
				EXTRA_HEADERS
			) as HashMap<String, String>
			synchronized(workQueue) {
				workQueue.add(UploadJob(contentUris, endPoints, headers))
				if (workQueue.size == 1) {
					startJobRunner()
				}
			}
		}
	}

	private fun startJobRunner() {
		logI(TAG, "[startJobRunner] Begin")
		launch(Dispatchers.IO) {
			var okCount = 0
			var failureCount = 0
			while (workQueue.isNotEmpty() && !shouldCancel) {
				val job = workQueue.peek()
				if (job != null) {
					val count = workOnce(job)
					okCount += count
					failureCount += job.contentUris.size - count
				}
				synchronized(workQueue) {
					workQueue.remove()
				}
			}
			if (shouldCancel) {
				if (okCount > 0) {
					if (notificationManager.areNotificationsEnabled()) {
						notificationManager.notify(
							K.RESULT_NOTIFICATION_ID,
							buildResultCanceledNotification(okCount)
						)
					}
				}
			} else {
				logI(
					TAG,
					"[startJobRunner] All job finished, terminating service"
				)
				if (notificationManager.areNotificationsEnabled()) {
					if (failureCount == 0) {
						notificationManager.notify(
							K.RESULT_NOTIFICATION_ID,
							buildResultSuccessfulNotification(okCount)
						)
					} else {
						notificationManager.notify(
							K.RESULT_NOTIFICATION_ID,
							buildResultPartialNotification(
								okCount, failureCount
							)
						)
					}
				}
			}
			notificationManager.cancel(K.FG_SERVICE_NOTIFICATION_ID)
			stopSelf()
		}
	}

	private fun workOnce(job: UploadJob): Int {
		var count = 0
		for ((uri, endPoint) in job.contentUris.zip(job.endPoints)) {
			if (shouldCancel) {
				logI(TAG, "[workOnce] Canceled")
				return count
			}
			val basename = endPoint.substringAfterLast("/")
			logI(TAG, "[workOnce] Uploading $basename")
			if (notificationManager.areNotificationsEnabled()) {
				notificationManager.notify(
					K.FG_SERVICE_NOTIFICATION_ID,
					buildNotification(content = basename)
				)
			}
			try {
				(URL(endPoint).openConnection() as HttpURLConnection).apply {
					requestMethod = "PUT"
					instanceFollowRedirects = true
					connectTimeout = 8000
					for (e in job.headers.entries) {
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
							"[workOnce] Failed uploading file: HTTP$responseCode"
						)
						throw HttpException(
							responseCode,
							"Failed uploading file (HTTP$responseCode)"
						)
					}
					count += 1
				}
			} catch (e: Throwable) {
				logE(TAG, "[workOnce] Exception", e)
			}
		}
		return count
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

	private fun buildCanceledNotification(): Notification {
		return NotificationCompat.Builder(this, CHANNEL_ID).run {
			setSmallIcon(android.R.drawable.stat_sys_upload)
			setContentTitle("Canceling upload")
			build()
		}
	}

	private fun buildResultSuccessfulNotification(count: Int): Notification {
		return NotificationCompat.Builder(this, CHANNEL_ID).run {
			setSmallIcon(android.R.drawable.stat_sys_upload_done)
			if (count == 1) {
				setContentTitle("Uploaded file successfully")
			} else {
				setContentTitle("Uploaded $count files successfully")
			}
			build()
		}
	}

	private fun buildResultPartialNotification(
		okCount: Int, failureCount: Int
	): Notification {
		return NotificationCompat.Builder(this, CHANNEL_ID).run {
			setSmallIcon(android.R.drawable.stat_sys_upload_done)
			if (okCount == 0 && failureCount == 1) {
				setContentTitle("Failed to upload file")
			} else {
				setContentTitle(
					"Uploaded $okCount out of ${okCount + failureCount} files successfully"
				)
			}
			build()
		}
	}

	private fun buildResultCanceledNotification(count: Int): Notification {
		return NotificationCompat.Builder(this, CHANNEL_ID).run {
			setSmallIcon(android.R.drawable.stat_sys_upload_done)
			if (count == 1) {
				setContentTitle(
					"Uploaded 1 file successfully before canceled by user"
				)
			} else {
				setContentTitle(
					"Uploaded $count files successfully before canceled by user"
				)
			}
			build()
		}
	}

	private var isForeground = false
	private var shouldCancel = false

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

private data class UploadJob(
	val contentUris: List<String>,
	val endPoints: List<String>,
	val headers: Map<String, String>,
)
