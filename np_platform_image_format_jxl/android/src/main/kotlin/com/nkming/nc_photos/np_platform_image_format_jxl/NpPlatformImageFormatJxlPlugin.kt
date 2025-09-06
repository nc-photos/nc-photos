package com.nkming.nc_photos.np_platform_image_format_jxl

import com.awxkee.jxlcoder.JxlCoder
import com.awxkee.jxlcoder.ScaleMode
import com.nkming.nc_photos.np_android_core.Rgba8Image
import com.nkming.nc_photos.np_android_core.logE
import com.nkming.nc_photos.np_android_core.use
import io.flutter.embedding.engine.plugins.FlutterPlugin
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Semaphore
import kotlinx.coroutines.sync.withPermit
import java.io.File

private class PigeonApiImpl : MyHostApi, CoroutineScope by MainScope() {
	companion object {
		private const val TAG = "PigeonApiImpl"

		// Limit number of jobs to avoid overloading the phone
		private val lock = Semaphore(3)
	}

	override fun load(
		filepath: String, w: Long?, h: Long?, callback: (Result<Image>) -> Unit
	) {
		launch(Dispatchers.IO) {
			doLoadBytes(File(filepath).readBytes(), w, h, callback)
		}
	}

	override fun loadBytes(
		bytes: ByteArray, w: Long?, h: Long?, callback: (Result<Image>) -> Unit
	) {
		launch(Dispatchers.IO) {
			doLoadBytes(bytes, w, h, callback)
		}
	}

	private suspend fun doLoadBytes(
		bytes: ByteArray, w: Long?, h: Long?, callback: (Result<Image>) -> Unit
	) {
		lock.withPermit {
			val bitmap = try {
				if (w != null && h != null) {
					JxlCoder.decodeSampled(
						bytes,
						w.toInt(),
						h.toInt(),
						scaleMode = ScaleMode.FIT
					)
				} else {
					JxlCoder.decode(bytes)
				}
			} catch (e: Throwable) {
				logE(TAG, "Failed to decode bytes", e)
				callback(
					Result.failure(
						FlutterError(
							"decode-error", "Failed to decode bytes", e.message
						)
					)
				)
				return
			}
			try {
				val rgba8 = bitmap.use { Rgba8Image.fromBitmap(bitmap) }
				val result = Image(
					pixel = rgba8.pixel,
					width = rgba8.width.toLong(),
					height = rgba8.height.toLong()
				)
				callback(Result.success(result))
			} catch (e: Throwable) {
				logE(TAG, "Failed to convert decoded data", e)
				callback(
					Result.failure(
						FlutterError(
							"convert-error", "Failed to convert decoded data",
							e.message
						)
					)
				)
				return
			}
		}
	}

	override fun loadMetadata(
		filepath: String, callback: (Result<Metadata?>) -> Unit
	) {
		launch(Dispatchers.IO) {
			val size = try {
				JxlCoder.getSize(File(filepath).readBytes())
			} catch (e: Throwable) {
				logE(TAG, "Failed to decode file: $filepath", e)
				callback(
					Result.failure(
						FlutterError(
							"decode-error", "Failed to decode file", e.message
						)
					)
				)
				return@launch
			}
			if (size == null) {
				callback(Result.success(null))
			} else {
				callback(
					Result.success(
						Metadata(size.width.toLong(), size.height.toLong())
					)
				)
			}
		}
	}

	override fun save(
		img: Image, filepath: String, callback: (Result<Boolean>) -> Unit
	) {
		// TODO
		callback(Result.success(false))
	}
}

class NpPlatformImageFormatJxlPlugin : FlutterPlugin {
	override fun onAttachedToEngine(
		flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
	) {
		val api = PigeonApiImpl()
		MyHostApi.setUp(flutterPluginBinding.binaryMessenger, api)
	}

	override fun onDetachedFromEngine(
		binding: FlutterPlugin.FlutterPluginBinding
	) {
	}
}
