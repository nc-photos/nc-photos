package com.nkming.nc_photos.plugin

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.nkming.nc_photos.np_android_core.getPendingIntentFlagImmutable
import com.nkming.nc_photos.np_android_core.logE
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.math.max

/*
 * Show notification on device
 *
 * Methods:
 * fun notifyItemsDownloadSuccessful(fileUris: List<String>,
 * 		mimeTypes: List<String>): Unit
 */
internal class NotificationChannelHandler(context: Context) :
	MethodChannel.MethodCallHandler {
	companion object {
		const val CHANNEL = "${K.LIB_ID}/notification"

		fun getNextNotificationId(): Int {
			if (++notificationId >= K.DOWNLOAD_NOTIFICATION_ID_MAX) {
				notificationId = K.DOWNLOAD_NOTIFICATION_ID_MIN
			}
			return notificationId
		}

		const val DOWNLOAD_CHANNEL_ID = "download"
		private var notificationId = K.DOWNLOAD_NOTIFICATION_ID_MIN
	}

	init {
		createDownloadChannel(context)
	}

	override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
		when (call.method) {
			"notifyDownloadSuccessful" -> {
				try {
					notifyDownloadSuccessful(
						call.argument("fileUris")!!,
						call.argument("mimeTypes")!!,
						call.argument("notificationId"), result
					)
				} catch (e: Throwable) {
					result.error("systemException", e.toString(), null)
				}
			}

			"notifyDownloadProgress" -> {
				try {
					notifyDownloadProgress(
						call.argument("progress")!!, call.argument("max")!!,
						call.argument("currentItemTitle"),
						call.argument("notificationId"), result
					)
				} catch (e: Throwable) {
					result.error("systemException", e.toString(), null)
				}
			}

			"notifyLogSaveSuccessful" -> {
				try {
					notifyLogSaveSuccessful(
						call.argument("fileUri")!!, result
					)
				} catch (e: Throwable) {
					result.error("systemException", e.toString(), null)
				}
			}

			"dismiss" -> {
				try {
					dismiss(call.argument("notificationId")!!, result)
				} catch (e: Throwable) {
					result.error("systemException", e.toString(), null)
				}
			}

			else -> {
				result.notImplemented()
			}
		}
	}

	private fun notifyDownloadSuccessful(
		fileUris: List<String>, mimeTypes: List<String?>, notificationId: Int?,
		result: MethodChannel.Result
	) {
		assert(fileUris.isNotEmpty())
		assert(fileUris.size == mimeTypes.size)
		val uris = fileUris.map { Uri.parse(it) }
		val builder = NotificationCompat.Builder(_context, DOWNLOAD_CHANNEL_ID)
			.setSmallIcon(R.drawable.baseline_download_white_18)
			.setWhen(System.currentTimeMillis())
			.setPriority(NotificationCompat.PRIORITY_HIGH).setSound(
				RingtoneManager.getDefaultUri(
					RingtoneManager.TYPE_NOTIFICATION
				)
			).setOnlyAlertOnce(false).setAutoCancel(true).setLocalOnly(true)

		if (uris.size == 1) {
			builder.setContentTitle(
				_context.getString(
					R.string.download_successful_notification_title
				)
			).setContentText(
				_context.getString(
					R.string.download_successful_notification_text
				)
			)

			val openIntent = Intent().apply {
				action = Intent.ACTION_VIEW
				setDataAndType(uris[0], mimeTypes[0])
				addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
				addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
			}
			val openPendingIntent = PendingIntent.getActivity(
				_context, 0, openIntent,
				PendingIntent.FLAG_UPDATE_CURRENT or getPendingIntentFlagImmutable()
			)
			builder.setContentIntent(openPendingIntent)

			// show preview if available
			if (mimeTypes[0]?.startsWith("image/") == true) {
				val preview = loadNotificationImage(uris[0])
				if (preview != null) {
					builder.setStyle(
						NotificationCompat.BigPictureStyle()
							.bigPicture(loadNotificationImage(uris[0]))
					)
				}
			}
		} else {
			builder.setContentTitle(
				_context.getString(
					R.string.download_multiple_successful_notification_title,
					fileUris.size
				)
			)
		}

		val shareIntent = if (uris.size == 1) Intent().apply {
			action = Intent.ACTION_SEND
			putExtra(Intent.EXTRA_STREAM, uris[0])
			type = mimeTypes[0] ?: "*/*"
			addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
			addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
		} else Intent().apply {
			action = Intent.ACTION_SEND_MULTIPLE
			putParcelableArrayListExtra(Intent.EXTRA_STREAM, ArrayList(uris))
			type = if (mimeTypes.all {
					it?.startsWith(
						"image/"
					) == true
				}) "image/*" else "*/*"
			addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
			addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
		}
		val shareChooser = Intent.createChooser(
			shareIntent, _context.getString(
				R.string.download_successful_notification_action_share_chooser
			)
		)
		val sharePendingIntent = PendingIntent.getActivity(
			_context, 1, shareChooser,
			PendingIntent.FLAG_UPDATE_CURRENT or getPendingIntentFlagImmutable()
		)
		builder.addAction(
			0, _context.getString(
				R.string.download_successful_notification_action_share
			), sharePendingIntent
		)

		val id = notificationId ?: getNextNotificationId()
		with(NotificationManagerCompat.from(_context)) {
			if (areNotificationsEnabled()) {
				notify(id, builder.build())
			}
		}
		result.success(id)
	}

	private fun notifyDownloadProgress(
		progress: Int, max: Int, currentItemTitle: String?,
		notificationId: Int?, result: MethodChannel.Result
	) {
		val id = notificationId ?: getNextNotificationId()
		val builder = NotificationCompat.Builder(_context, DOWNLOAD_CHANNEL_ID)
			.setSmallIcon(android.R.drawable.stat_sys_download)
			.setWhen(System.currentTimeMillis())
			.setPriority(NotificationCompat.PRIORITY_HIGH).setSound(
				RingtoneManager.getDefaultUri(
					RingtoneManager.TYPE_NOTIFICATION
				)
			).setOnlyAlertOnce(true).setAutoCancel(false).setLocalOnly(true)
			.setProgress(max, progress, false).setContentText("$progress/$max")
		if (currentItemTitle == null) {
			builder.setContentTitle(
				_context.getString(
					R.string.download_progress_notification_untitled_text
				)
			)
		} else {
			builder.setContentTitle(
				_context.getString(
					R.string.download_progress_notification_text,
					currentItemTitle
				)
			)
		}

		val cancelIntent = Intent().apply {
			`package` = _context.packageName
			action = K.ACTION_DOWNLOAD_CANCEL
			putExtra(K.EXTRA_NOTIFICATION_ID, id)
		}
		val cancelPendingIntent = PendingIntent.getBroadcast(
			_context, 0, cancelIntent,
			PendingIntent.FLAG_UPDATE_CURRENT or getPendingIntentFlagImmutable()
		)
		builder.addAction(
			0, _context.getString(android.R.string.cancel), cancelPendingIntent
		)

		with(NotificationManagerCompat.from(_context)) {
			if (areNotificationsEnabled()) {
				notify(id, builder.build())
			}
		}
		result.success(id)
	}

	private fun notifyLogSaveSuccessful(
		fileUri: String, result: MethodChannel.Result
	) {
		val uri = Uri.parse(fileUri)
		val mimeType = "text/plain"
		val builder = NotificationCompat.Builder(_context, DOWNLOAD_CHANNEL_ID)
			.setSmallIcon(R.drawable.baseline_download_white_18)
			.setWhen(System.currentTimeMillis())
			.setPriority(NotificationCompat.PRIORITY_HIGH).setSound(
				RingtoneManager.getDefaultUri(
					RingtoneManager.TYPE_NOTIFICATION
				)
			).setAutoCancel(true).setLocalOnly(true).setTicker(
				_context.getString(
					R.string.log_save_successful_notification_title
				)
			).setContentTitle(
				_context.getString(
					R.string.log_save_successful_notification_title
				)
			).setContentText(
				_context.getString(
					R.string.log_save_successful_notification_text
				)
			)

		val openIntent = Intent().apply {
			action = Intent.ACTION_VIEW
			setDataAndType(uri, mimeType)
			addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
			addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
		}
		val openPendingIntent = PendingIntent.getActivity(
			_context, 0, openIntent,
			PendingIntent.FLAG_UPDATE_CURRENT or getPendingIntentFlagImmutable()
		)
		builder.setContentIntent(openPendingIntent)

		// can't add the share action here because android will share the URI as
		// plain text instead of treating it as a text file...

		val id = getNextNotificationId()
		with(NotificationManagerCompat.from(_context)) {
			if (areNotificationsEnabled()) {
				notify(id, builder.build())
			}
		}
		result.success(id)
	}

	private fun dismiss(notificationId: Int, result: MethodChannel.Result) {
		with(NotificationManagerCompat.from(_context)) {
			cancel(notificationId)
		}
		result.success(null)
	}

	private fun loadNotificationImage(fileUri: Uri): Bitmap? {
		try {
			val resolver = _context.applicationContext.contentResolver
			resolver.openFileDescriptor(fileUri, "r").use { pfd ->
				val metaOpts = BitmapFactory.Options().apply {
					inJustDecodeBounds = true
				}
				BitmapFactory.decodeFileDescriptor(
					pfd!!.fileDescriptor, null, metaOpts
				)
				val longSide = max(metaOpts.outWidth, metaOpts.outHeight)
				val opts = BitmapFactory.Options().apply {
					// just a preview in the panel, useless to be in high res
					inSampleSize = longSide / 720
				}
				return BitmapFactory.decodeFileDescriptor(
					pfd.fileDescriptor, null, opts
				)
			}
		} catch (e: Throwable) {
			logE(
				"NotificationChannelHandler::loadNotificationImage",
				"Failed generating preview image", e
			)
			return null
		}
	}

	private fun createDownloadChannel(context: Context) {
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			val name = context.getString(
				R.string.download_notification_channel_name
			)
			val descriptionStr = context.getString(
				R.string.download_notification_channel_description
			)
			val channel = NotificationChannel(
				DOWNLOAD_CHANNEL_ID, name, NotificationManager.IMPORTANCE_HIGH
			).apply {
				description = descriptionStr
			}

			val manager = context.getSystemService(
				Context.NOTIFICATION_SERVICE
			) as NotificationManager
			manager.createNotificationChannel(channel)
		}
	}

	private val _context = context
}
