package com.nkming.nc_photos.plugin

import android.content.Context
import androidx.core.content.FileProvider
import com.nkming.nc_photos.np_android_core.logE
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

internal class ContentUriChannelHandler(context: Context) :
	MethodChannel.MethodCallHandler {
	companion object {
		const val METHOD_CHANNEL = "${K.LIB_ID}/content_uri_method"

		private const val TAG = "ContentUriChannelHandler"
	}

	override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
		when (call.method) {
			"getUriForFile" -> {
				try {
					getUriForFile(call.argument("filePath")!!, result)
				} catch (e: Throwable) {
					result.error("systemException", e.toString(), null)
				}
			}

			else -> result.notImplemented()
		}
	}

	private fun getUriForFile(filePath: String, result: MethodChannel.Result) {
		try {
			val file = File(filePath)
			val contentUri = FileProvider.getUriForFile(
				context, "${context.packageName}.fileprovider", file
			)
			result.success(contentUri.toString())
		} catch (e: IllegalArgumentException) {
			logE(TAG, "[getUriForFile] Unsupported file path: $filePath")
			throw e
		}
	}

	private val context = context
}
