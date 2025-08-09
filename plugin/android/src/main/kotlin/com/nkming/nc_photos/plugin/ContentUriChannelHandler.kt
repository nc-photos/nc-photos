package com.nkming.nc_photos.plugin

import android.content.Context
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.util.Size
import androidx.annotation.RequiresApi
import androidx.core.content.FileProvider
import com.nkming.nc_photos.np_android_core.UriUtil
import com.nkming.nc_photos.np_android_core.logE
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileNotFoundException

internal class ContentUriChannelHandler(context: Context) :
	MethodChannel.MethodCallHandler {
	companion object {
		const val METHOD_CHANNEL = "${K.LIB_ID}/content_uri_method"

		private const val TAG = "ContentUriChannelHandler"
	}

	override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
		when (call.method) {
			"readUri" -> {
				try {
					readUri(call.argument("uri")!!, result)
				} catch (e: Throwable) {
					result.error("systemException", e.toString(), null)
				}
			}

			"readThumbnail" -> {
				try {
					if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
						readThumbnail(
							call.argument("uri")!!,
							call.argument("width")!!,
							call.argument("height")!!,
							result
						)
					} else {
						result.error(
							"systemException", "Require Android 11+", null
						)
					}
				} catch (e: Throwable) {
					result.error("systemException", e.toString(), null)
				}
			}

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

	private fun readUri(uri: String, result: MethodChannel.Result) {
		val uriTyped = Uri.parse(uri)
		try {
			val bytes = if (UriUtil.isAssetUri(uriTyped)) {
				context.assets.open(UriUtil.getAssetUriPath(uriTyped)).use {
					it.readBytes()
				}
			} else {
				context.contentResolver.openInputStream(uriTyped)!!.use {
					it.readBytes()
				}
			}
			result.success(bytes)
		} catch (e: FileNotFoundException) {
			result.error("fileNotFoundException", e.toString(), null)
		}
	}

	@RequiresApi(Build.VERSION_CODES.R)
	private fun readThumbnail(
		uri: String, width: Int, height: Int, result: MethodChannel.Result
	) {
		val uriTyped = Uri.parse(uri)
		try {
			val bitmap = context.contentResolver.loadThumbnail(
				uriTyped, Size(width, height), null
			)
			val bytes = ByteArrayOutputStream().use {
				bitmap.compress(Bitmap.CompressFormat.JPEG, 82, it)
				it.toByteArray()
			}
			result.success(bytes)
		} catch (e: FileNotFoundException) {
			result.error("fileNotFoundException", e.toString(), null)
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
