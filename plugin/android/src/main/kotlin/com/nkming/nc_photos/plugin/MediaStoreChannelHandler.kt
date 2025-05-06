package com.nkming.nc_photos.plugin

import android.app.Activity
import android.content.ContentResolver
import android.content.ContentUris
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
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
import com.nkming.nc_photos.np_android_core.measureTime
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.launch
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

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

	override fun onAttachedToActivity(binding: ActivityPluginBinding) {
		activity = binding.activity
	}

	override fun onReattachedToActivityForConfigChanges(
		binding: ActivityPluginBinding
	) {
		activity = binding.activity
	}

	override fun onDetachedFromActivity() {
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

			"queryFiles2" -> {
				try {
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
						val timeRangeBeg = call.argument<Long>("timeRangeBeg")
							?.let { Date(it) }
						val isTimeRangeBegInclusive = call.argument<Boolean>("isTimeRangeBegInclusive")
						val timeRangeEnd = call.argument<Long>("timeRangeEnd")
							?.let { Date(it) }
						val isTimeRangeEndInclusive = call.argument<Boolean>("isTimeRangeEndInclusive")
						queryFiles2(
							timeRangeBeg = timeRangeBeg,
							isTimeRangeBegInclusive = isTimeRangeBegInclusive,
							timeRangeEnd = timeRangeEnd,
							isTimeRangeEndInclusive = isTimeRangeEndInclusive,
							result = result
						)
					} else {
						result.success(listOf<Map<String, Any>>())
					}
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

			"getFilesSummary" -> {
				try {
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
						getFilesSummary(result)
					} else {
						result.success(listOf<Map<Long, Int>>())
					}
				} catch (e: Throwable) {
					result.error("systemException", e.message, null)
				}
			}

			else -> result.notImplemented()
		}
	}

	private fun saveFileToDownload(
		content: ByteArray, filename: String, subDir: String?,
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
		fromFile: String, filename: String?, subDir: String?,
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
			@Suppress("Deprecation") pathColumnName =
				MediaStore.Images.Media.DATA
			pathArg = "%/${relativePath}/%"
		}
		val projection = arrayOf(
			MediaStore.Images.Media._ID, MediaStore.Images.Media.DATE_MODIFIED,
			MediaStore.Images.Media.MIME_TYPE,
			MediaStore.Images.Media.DATE_TAKEN,
			MediaStore.Images.Media.DISPLAY_NAME, pathColumnName
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
			val pathColumn = it.getColumnIndexOrThrow(pathColumnName)
			val products = mutableListOf<Map<String, Any>>()
			while (it.moveToNext()) {
				val id = it.getLong(idColumn)
				val dateModified = it.getLong(dateModifiedColumn)
				val mimeType = it.getString(mimeTypeColumn)
				val dateTaken = it.getLongOrNull(dateTakenColumn)
				val displayName = it.getString(displayNameColumn)
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

	@RequiresApi(Build.VERSION_CODES.R)
	private fun queryFiles2(
		timeRangeBeg: Date? = null,
		isTimeRangeBegInclusive: Boolean? = null,
		timeRangeEnd: Date? = null,
		isTimeRangeEndInclusive: Boolean? = null,
		result: MethodChannel.Result
	) {
		if (!PermissionUtil.hasReadMedia(context)) {
			// activity?.let { PermissionUtil.requestReadMedia(it) }
			result.error("permissionError", "Permission not granted", null)
			return
		}

		val whereArgs = mutableListOf<String>()
		if (timeRangeBeg != null) {
			if (isTimeRangeBegInclusive == false) {
				whereArgs.add(
					"${MediaStore.Images.ImageColumns.DATE_TAKEN} > ${timeRangeBeg.time}"
				)
			} else {
				whereArgs.add(
					"${MediaStore.Images.ImageColumns.DATE_TAKEN} >= ${timeRangeBeg.time}"
				)
			}
		}
		if (timeRangeEnd != null) {
			if (isTimeRangeEndInclusive == true) {
				whereArgs.add(
					"${MediaStore.Images.ImageColumns.DATE_TAKEN} <= ${timeRangeEnd.time}"
				)
			} else {
				whereArgs.add(
					"${MediaStore.Images.ImageColumns.DATE_TAKEN} < ${timeRangeEnd.time}"
				)
			}
		}

		doWork {
			context.contentResolver.query(
				MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
				arrayOf(
					MediaStore.Images.ImageColumns._ID,
					MediaStore.Images.ImageColumns.DATE_MODIFIED,
					MediaStore.Images.ImageColumns.MIME_TYPE,
					MediaStore.Images.ImageColumns.DATE_TAKEN,
					MediaStore.Images.ImageColumns.DISPLAY_NAME,
					MediaStore.Images.ImageColumns.RELATIVE_PATH,
				),
				Bundle().apply {
					if (whereArgs.isNotEmpty()) {
						putString(
							ContentResolver.QUERY_ARG_SQL_SELECTION,
							whereArgs.joinToString(" AND "),
						)
					}
					putStringArray(
						ContentResolver.QUERY_ARG_SORT_COLUMNS,
						arrayOf(
							MediaStore.Images.ImageColumns.DATE_TAKEN
						),
					)
					putInt(
						ContentResolver.QUERY_ARG_SORT_DIRECTION,
						ContentResolver.QUERY_SORT_DIRECTION_DESCENDING,
					)
				},
				null,
			)?.use {
				val products = mutableListOf<Map<String, Any>>()
				if (it.moveToFirst()) {
					val idColumn = it.getColumnIndexOrThrow(
						MediaStore.Images.ImageColumns._ID
					)
					val dateModifiedColumn = it.getColumnIndexOrThrow(
						MediaStore.Images.ImageColumns.DATE_MODIFIED
					)
					val mimeTypeColumn = it.getColumnIndexOrThrow(
						MediaStore.Images.ImageColumns.MIME_TYPE
					)
					val dateTakenColumn = it.getColumnIndexOrThrow(
						MediaStore.Images.ImageColumns.DATE_TAKEN
					)
					val displayNameColumn = it.getColumnIndexOrThrow(
						MediaStore.Images.ImageColumns.DISPLAY_NAME
					)
					val relativePathColumn = it.getColumnIndexOrThrow(
						MediaStore.Images.ImageColumns.RELATIVE_PATH
					)
					do {
						val id = it.getLong(idColumn)
						val contentUri = ContentUris.withAppendedId(
							MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id
						)
						val displayName = it.getString(displayNameColumn)
						val relativePath = "${
							it.getString(relativePathColumn).trimEnd('/')
						}/$displayName"
						products.add(buildMap {
							put("id", id)
							put("uri", contentUri.toString())
							put("displayName", it.getString(displayNameColumn))
							put("path", relativePath)
							put(
								"dateModified",
								it.getLong(dateModifiedColumn) * 1000
							)
							put("mimeType", it.getString(mimeTypeColumn))
							it.getLongOrNull(dateTakenColumn)?.let { v ->
								put("dateTaken", v)
							}
						})
					} while (it.moveToNext())
				}
				result.success(products)
			}
		}
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
	private fun getFilesSummary(result: MethodChannel.Result) {
		if (!PermissionUtil.hasReadMedia(context)) {
			// activity?.let { PermissionUtil.requestReadMedia(it) }
			result.error("permissionError", "Permission not granted", null)
			return
		}

		doWork {
			val dateCount = mutableMapOf<Long, Int>()
			var thisDateBeg = 0L
			var thisDateEnd = 0L
			var thisDateCount = 0
			context.contentResolver.query(
				MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
				arrayOf(
					MediaStore.Images.ImageColumns.DATE_TAKEN,
				),
				Bundle().apply {
					putString(
						ContentResolver.QUERY_ARG_SQL_SELECTION,
						"${MediaStore.Images.ImageColumns.DATE_TAKEN} IS NOT NULL",
					)
					putStringArray(
						ContentResolver.QUERY_ARG_SORT_COLUMNS,
						arrayOf(
							MediaStore.Images.ImageColumns.DATE_TAKEN
						),
					)
					putInt(
						ContentResolver.QUERY_ARG_SORT_DIRECTION,
						ContentResolver.QUERY_SORT_DIRECTION_DESCENDING,
					)
				},
				null,
			)?.use {
				if (it.moveToFirst()) {
					val dateColumn = it.getColumnIndexOrThrow(
						MediaStore.Images.ImageColumns.DATE_TAKEN
					)
					do {
						val time = it.getLong(dateColumn)
						if (time in thisDateBeg until thisDateEnd) {
							// same date
							++thisDateCount
						} else {
							// new date
							if (thisDateCount > 0) {
								dateCount[thisDateBeg] = thisDateCount
							}
							thisDateBeg = time / 86400000 * 86400000
							thisDateEnd = thisDateBeg + 86400000
							thisDateCount = 1
						}
					} while (it.moveToNext())
					if (thisDateCount > 0) {
						dateCount[thisDateBeg] = thisDateCount
					}
				}
			}
			result.success(dateCount)
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

	private val context = context
	private var activity: Activity? = null
	private var eventSink: EventChannel.EventSink? = null
}
