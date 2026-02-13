package com.nkming.nc_photos.plugin

import android.app.Activity
import android.content.ContentResolver
import android.content.ContentUris
import android.content.Context
import android.content.Intent
import android.database.ContentObserver
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import androidx.annotation.RequiresApi
import androidx.core.database.getLongOrNull
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.nkming.nc_photos.np_android_core.MediaStoreUtil
import com.nkming.nc_photos.np_android_core.PermissionException
import com.nkming.nc_photos.np_android_core.PermissionUtil
import com.nkming.nc_photos.np_android_core.logE
import com.nkming.nc_photos.np_android_core.logI
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.launch
import java.io.File
import java.time.Instant
import java.time.ZoneId
import java.time.ZonedDateTime
import java.time.temporal.ChronoUnit
import java.util.Date

/*
 * Save downloaded item on device
 *
 * Methods:
 * Write binary content to a file in the Download directory. Return the Uri to
 * the file
 * fun saveFileToDownload(content: ByteArray, filename: String, subDir: String?): String
 *
 * Return files under @c relativePath and its sub dirs
 * fun queryFiles(relativePath: String): List<Map>
 */
internal class MediaStoreChannelHandler(context: Context) :
	MethodChannel.MethodCallHandler, EventChannel.StreamHandler, ActivityAware,
	PluginRegistry.ActivityResultListener {
	companion object {
		const val EVENT_CHANNEL = "${K.LIB_ID}/media_store"
		const val METHOD_CHANNEL = "${K.LIB_ID}/media_store_method"

		private const val TAG = "MediaStoreChannelHandler"
	}

	private inner class MyContentObserver : ContentObserver(handler) {
		override fun onChange(selfChange: Boolean, uri: Uri?, flags: Int) {
			if ((flags and ContentResolver.NOTIFY_INSERT) != 0) {
				eventSink?.success(buildMap {
					put("event", "NotifyInsert")
				})
			} else if ((flags and ContentResolver.NOTIFY_DELETE) != 0) {
				eventSink?.success(buildMap {
					put("event", "NotifyDelete")
				})
			} else if ((flags and ContentResolver.NOTIFY_UPDATE) != 0) {
				eventSink?.success(buildMap {
					put("event", "NotifyUpdate")
				})
			}
		}
	}

	override fun onAttachedToActivity(binding: ActivityPluginBinding) {
		activity = binding.activity

		val cr = binding.activity.applicationContext.contentResolver
		cr.registerContentObserver(
			MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
			true,
			imageObserver
		)
		cr.registerContentObserver(
			MediaStore.Video.Media.EXTERNAL_CONTENT_URI,
			true,
			videoObserver
		)
	}

	override fun onReattachedToActivityForConfigChanges(
		binding: ActivityPluginBinding
	) {
		activity = binding.activity
	}

	override fun onDetachedFromActivity() {
		activity?.applicationContext?.contentResolver?.unregisterContentObserver(
			imageObserver
		)
		activity?.applicationContext?.contentResolver?.unregisterContentObserver(
			videoObserver
		)
		activity = null
	}

	override fun onDetachedFromActivityForConfigChanges() {
		activity = null
	}

	override fun onActivityResult(
		requestCode: Int, resultCode: Int, data: Intent?
	): Boolean {
		if (requestCode == K.MEDIA_STORE_DELETE_REQUEST_CODE) {
			eventSink?.success(buildMap {
				put("event", "DeleteRequestResult")
				put("resultCode", resultCode)
			})
			return true
		} else if (requestCode == K.MEDIA_STORE_TRASH_REQUEST_CODE) {
			eventSink?.success(buildMap {
				put("event", "TrashRequestResult")
				put("resultCode", resultCode)
			})
			return true
		}
		return false
	}

	override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
		eventSink = events
	}

	override fun onCancel(arguments: Any?) {
		eventSink = null
	}

	override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
		when (call.method) {
			"saveFileToDownload" -> {
				try {
					saveFileToDownload(
						call.argument("content")!!, call.argument("filename")!!,
						call.argument("subDir"), result
					)
				} catch (e: Throwable) {
					result.error("systemException", e.message, null)
				}
			}

			"copyFileToDownload" -> {
				try {
					copyFileToDownload(
						call.argument("fromFile")!!, call.argument("filename"),
						call.argument("subDir"), result
					)
				} catch (e: Throwable) {
					result.error("systemException", e.message, null)
				}
			}

			"queryFiles" -> {
				try {
					queryFiles(call.argument("relativePath")!!, result)
				} catch (e: Throwable) {
					result.error("systemException", e.message, null)
				}
			}

			"deleteFiles" -> {
				try {
					deleteFiles(call.argument("uris")!!, result)
				} catch (e: Throwable) {
					result.error("systemException", e.message, null)
				}
			}

			"trashFiles" -> {
				try {
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
						trashFiles(call.argument("uris")!!, result)
					} else {
						result.error(
							"systemException", "Require Android 11+", null
						)
					}
				} catch (e: Throwable) {
					result.error(
						"systemException", e.message, e.stackTraceToString()
					)
				}
			}

			"getFileIdWithTimestamps" -> {
				try {
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
						getFileIdWithTimestamps(
							dirWhitelist = call.argument("dirWhitelist"),
							result = result
						)
					} else {
						result.success(listOf<Map<String, Any>>())
					}
				} catch (e: Throwable) {
					result.error("systemException", e.message, null)
				}
			}

			"getDirList" -> {
				try {
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
						getDirList(result)
					} else {
						result.success(listOf<Map<String, Any>>())
					}
				} catch (e: Throwable) {
					result.error("systemException", e.message, null)
				}
			}

			else -> result.notImplemented()
		}
	}

	private fun saveFileToDownload(
		content: ByteArray,
		filename: String,
		subDir: String?,
		result: MethodChannel.Result
	) {
		try {
			val uri = MediaStoreUtil.saveFileToDownload(
				context, content, filename, subDir
			)
			result.success(uri.toString())
		} catch (e: PermissionException) {
			activity?.let { PermissionUtil.requestWriteExternalStorage(it) }
			result.error("permissionError", "Permission not granted", null)
		}
	}

	private fun copyFileToDownload(
		fromFile: String,
		filename: String?,
		subDir: String?,
		result: MethodChannel.Result
	) {
		try {
			val fromUri = inputToUri(fromFile)
			val uri = MediaStoreUtil.copyFileToDownload(
				context, fromUri, filename, subDir
			)
			result.success(uri.toString())
		} catch (e: PermissionException) {
			activity?.let { PermissionUtil.requestWriteExternalStorage(it) }
			result.error("permissionError", "Permission not granted", null)
		}
	}

	private fun queryFiles(relativePath: String, result: MethodChannel.Result) {
		if (!PermissionUtil.hasReadExternalStorage(context)) {
			activity?.let { PermissionUtil.requestReadExternalStorage(it) }
			result.error("permissionError", "Permission not granted", null)
			return
		}

		val pathColumnName: String
		val pathArg: String
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
			pathColumnName = MediaStore.Images.Media.RELATIVE_PATH
			pathArg = "${relativePath}/%"
		} else {
			pathColumnName = MediaStore.Images.Media.DATA
			pathArg = "%/${relativePath}/%"
		}
		val projection = arrayOf(
			MediaStore.Images.Media._ID, MediaStore.Images.Media.DATE_MODIFIED,
			MediaStore.Images.Media.MIME_TYPE,
			MediaStore.Images.Media.DATE_TAKEN,
			MediaStore.Images.Media.DISPLAY_NAME,
			MediaStore.Images.Media.SIZE,
			pathColumnName
		)
		val selection = StringBuilder().apply {
			append("${MediaStore.Images.Media.MIME_TYPE} LIKE ?")
			append("AND $pathColumnName LIKE ?")
		}.toString()
		val selectionArgs = arrayOf("image/%", pathArg)
		val files = context.contentResolver.query(
			MediaStore.Images.Media.EXTERNAL_CONTENT_URI, projection, selection,
			selectionArgs, null
		)!!.use {
			val idColumn = it.getColumnIndexOrThrow(MediaStore.Images.Media._ID)
			val dateModifiedColumn =
				it.getColumnIndexOrThrow(MediaStore.Images.Media.DATE_MODIFIED)
			val mimeTypeColumn =
				it.getColumnIndexOrThrow(MediaStore.Images.Media.MIME_TYPE)
			val dateTakenColumn =
				it.getColumnIndexOrThrow(MediaStore.Images.Media.DATE_TAKEN)
			val displayNameColumn =
				it.getColumnIndexOrThrow(MediaStore.Images.Media.DISPLAY_NAME)
			val sizeColumn =
				it.getColumnIndexOrThrow(MediaStore.Images.Media.SIZE)
			val pathColumn = it.getColumnIndexOrThrow(pathColumnName)
			val products = mutableListOf<Map<String, Any>>()
			while (it.moveToNext()) {
				val id = it.getLong(idColumn)
				val dateModified = it.getLong(dateModifiedColumn)
				val mimeType = it.getString(mimeTypeColumn)
				val dateTaken = it.getLongOrNull(dateTakenColumn)
				val displayName = it.getString(displayNameColumn)
				val size = it.getLong(sizeColumn)
				val path = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
					// RELATIVE_PATH
					"${it.getString(pathColumn).trimEnd('/')}/$displayName"
				} else {
					// DATA
					it.getString(pathColumn)
				}
				val contentUri = ContentUris.withAppendedId(
					MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id
				)
				products.add(buildMap {
					put("id", id)
					put("uri", contentUri.toString())
					put("displayName", displayName)
					put("path", path)
					put("dateModified", dateModified * 1000)
					put("mimeType", mimeType)
					if (dateTaken != null) put("dateTaken", dateTaken)
					put("size", size)
				})
				// logD(
				// 	TAG,
				// 	"[queryEnhancedPhotos] Found $displayName, path=$path, uri=$contentUri"
				// )
			}
			products
		}
		logI(TAG, "[queryEnhancedPhotos] Found ${files.size} files")
		result.success(files)
	}

	private fun deleteFiles(uris: List<String>, result: MethodChannel.Result) {
		val urisTyped = uris.map(Uri::parse)
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
			val pi = MediaStore.createDeleteRequest(
				context.contentResolver, urisTyped
			)
			activity!!.startIntentSenderForResult(
				pi.intentSender, K.MEDIA_STORE_DELETE_REQUEST_CODE, null, 0, 0,
				0
			)
			result.success(null)
		} else {
			if (!PermissionUtil.hasWriteExternalStorage(context)) {
				activity?.let { PermissionUtil.requestWriteExternalStorage(it) }
				result.error("permissionError", "Permission not granted", null)
				return
			}

			val failed = mutableListOf<String>()
			for (uri in urisTyped) {
				try {
					context.contentResolver.delete(uri, null, null)
				} catch (e: Throwable) {
					logE(TAG, "[deleteFiles] Failed while delete", e)
					failed += uri.toString()
				}
			}
			result.success(failed)
		}
	}

	@RequiresApi(Build.VERSION_CODES.R)
	private fun trashFiles(uris: List<String>, result: MethodChannel.Result) {
		val urisTyped = uris.map(Uri::parse)
		// MediaStore does not support deleting files via their file uris
		// (seriously why?!), we need to first convert them to image/video uris
		val convertedUris =
			MediaStoreUtil.convertFileUrisToConcreteUris(context, urisTyped)
		val pi = MediaStore.createTrashRequest(
			context.contentResolver, convertedUris.values, true
		)
		activity!!.startIntentSenderForResult(
			pi.intentSender, K.MEDIA_STORE_TRASH_REQUEST_CODE, null, 0, 0,
			0
		)
		result.success(convertedUris.keys.map { it.toString() })
	}

	@RequiresApi(Build.VERSION_CODES.R)
	private fun getFileIdWithTimestamps(
		dirWhitelist: List<String>?,
		result: MethodChannel.Result
	) {
		if (!PermissionUtil.hasReadMedia(context)) {
			// activity?.let { PermissionUtil.requestReadMedia(it) }
			result.error("permissionError", "Permission not granted", null)
			return
		}

		val results = mutableListOf<Map<String, Any>>()
		doWork {
			val whereArgs = mutableListOf<String>()
			var where = "(" +
					"${MediaStore.Files.FileColumns.MEDIA_TYPE}=${MediaStore.Files.FileColumns.MEDIA_TYPE_IMAGE}" +
					" OR " +
					"${MediaStore.Files.FileColumns.MEDIA_TYPE}=${MediaStore.Files.FileColumns.MEDIA_TYPE_VIDEO}" +
					")"
			where += " AND ${MediaStore.MediaColumns.DATE_TAKEN} IS NOT NULL"
			if (!dirWhitelist.isNullOrEmpty()) {
				val (w, wa) = dirWhitelistToSql(dirWhitelist)
				where += " AND $w"
				whereArgs.addAll(wa)
			}
			context.contentResolver.query(
				MediaStore.Files.getContentUri("external"),
				arrayOf(
					MediaStore.MediaColumns._ID,
					MediaStore.MediaColumns.DATE_TAKEN,
					MediaStore.MediaColumns.DISPLAY_NAME,
				),
				Bundle().apply {
					putString(ContentResolver.QUERY_ARG_SQL_SELECTION, where)
					if (whereArgs.isNotEmpty()) {
						putStringArray(
							ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS,
							whereArgs.toTypedArray(),
						)
					}
					putString(
						ContentResolver.QUERY_ARG_SQL_SORT_ORDER,
						"${MediaStore.MediaColumns.DATE_TAKEN} DESC, ${MediaStore.MediaColumns._ID} DESC"
					)
				},
				null,
			)?.use {
				if (it.moveToFirst()) {
					val idColumn = it.getColumnIndexOrThrow(
						MediaStore.MediaColumns._ID
					)
					val dateColumn = it.getColumnIndexOrThrow(
						MediaStore.MediaColumns.DATE_TAKEN
					)
					val displayNameColumn = it.getColumnIndexOrThrow(
						MediaStore.MediaColumns.DISPLAY_NAME
					)
					do {
						val id = it.getLong(idColumn)
						val timestamp = it.getLong(dateColumn)
						val displayName = it.getString(displayNameColumn)
						results.add(
							mapOf(
								"fileId" to id,
								"timestamp" to timestamp,
								"displayName" to displayName,
							)
						)
					} while (it.moveToNext())
				}
			}
			result.success(results)
		}
	}

	@RequiresApi(Build.VERSION_CODES.R)
	private fun getDirList(result: MethodChannel.Result) {
		if (!PermissionUtil.hasReadMedia(context)) {
			// activity?.let { PermissionUtil.requestReadMedia(it) }
			result.error("permissionError", "Permission not granted", null)
			return
		}

		val results = mutableListOf<String>()
		doWork {
			context.contentResolver.query(
				MediaStore.Files.getContentUri("external"),
				arrayOf(
					MediaStore.MediaColumns.RELATIVE_PATH,
				),
				Bundle().apply {
					putString(
						ContentResolver.QUERY_ARG_SQL_SELECTION,
						"(" +
								"${MediaStore.Files.FileColumns.MEDIA_TYPE}=${MediaStore.Files.FileColumns.MEDIA_TYPE_IMAGE}" +
								" OR " +
								"${MediaStore.Files.FileColumns.MEDIA_TYPE}=${MediaStore.Files.FileColumns.MEDIA_TYPE_VIDEO}" +
								") AND " +
								"${MediaStore.MediaColumns.DATE_TAKEN} IS NOT NULL",
					)
					putString(
						ContentResolver.QUERY_ARG_SQL_GROUP_BY,
						MediaStore.MediaColumns.RELATIVE_PATH,
					)
				},
				null,
			)?.use {
				if (it.moveToFirst()) {
					val relPathColumn = it.getColumnIndexOrThrow(
						MediaStore.MediaColumns.RELATIVE_PATH
					)
					do {
						val relPath = it.getString(relPathColumn)
						results.add(relPath)
					} while (it.moveToNext())
				}
			}
			result.success(results)
		}
	}

	private fun inputToUri(fromFile: String): Uri {
		val testUri = Uri.parse(fromFile)
		return if (testUri.scheme == null) {
			// is a file path
			Uri.fromFile(File(fromFile))
		} else {
			// is a uri
			Uri.parse(fromFile)
		}
	}

	private fun doWork(block: () -> Unit) {
		if (activity is LifecycleOwner) {
			(activity as LifecycleOwner).lifecycleScope.launch {
				block()
			}
		} else {
			block()
		}
	}

	private fun dirWhitelistToSql(dirWhitelist: List<String>)
			: Pair<String, List<String>> {
		val wheres = mutableListOf<String>()
		val whereArgs = mutableListOf<String>()
		for (w in dirWhitelist) {
			wheres.add("${MediaStore.MediaColumns.RELATIVE_PATH} LIKE ?")
			whereArgs.add("%$w%")
		}
		return Pair("(" + wheres.joinToString(" OR ") + ")", whereArgs)
	}

	private val context = context
	private var activity: Activity? = null
	private var eventSink: EventChannel.EventSink? = null

	private val handler = Handler(Looper.getMainLooper())
	private val imageObserver = MyContentObserver()
	private val videoObserver = MyContentObserver()
}
