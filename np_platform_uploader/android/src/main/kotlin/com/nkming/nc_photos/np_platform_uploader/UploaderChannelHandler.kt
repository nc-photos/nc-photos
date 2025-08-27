package com.nkming.nc_photos.np_platform_uploader

import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class UploaderChannelHandler(private val context: Context) :
	MethodChannel.MethodCallHandler {
	companion object {
		const val METHOD_CHANNEL = "${K.LIB_ID}/uploader_method"

		private const val TAG = "UploaderChannelHandler"
	}

	override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
		when (call.method) {
			"asyncUpload" -> {
				try {
					asyncUpload(
						call.argument("contentUris")!!,
						call.argument("endPoints")!!,
						call.argument("headers")!!,
						call.argument("convertFormat"),
						call.argument("convertQuality"),
						call.argument("convertDownsizeMp"),
						result
					)
				} catch (e: Throwable) {
					result.error("systemException", e.toString(), null)
				}
			}

			else -> result.notImplemented()
		}
	}

	private fun asyncUpload(
		contentUris: List<String>, endPoints: List<String>,
		headers: Map<String, String>, convertFormat: Int?, convertQuality: Int?,
		convertDownsizeMp: Double?, result: MethodChannel.Result
	) {
		assert(contentUris.size == endPoints.size)
		val intent = Intent(context, UploadService::class.java).apply {
			putExtra(UploadService.EXTRA_CONTENT_URIS, ArrayList(contentUris))
			putExtra(UploadService.EXTRA_END_POINTS, ArrayList(endPoints))
			putExtra(UploadService.EXTRA_HEADERS, HashMap(headers))
			putExtra(UploadService.EXTRA_CONVERT_FORMAT, convertFormat)
			putExtra(UploadService.EXTRA_CONVERT_QUALITY, convertQuality)
			putExtra(UploadService.EXTRA_CONVERT_DOWNSIZE_MP, convertDownsizeMp)
		}
		ContextCompat.startForegroundService(context, intent)
		result.success(null)
	}
}
