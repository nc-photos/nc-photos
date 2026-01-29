package com.nkming.nc_photos.np_platform_image_format_jxl

import android.graphics.Bitmap
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
		private const val TAG = "NpPlatformImageFormatJxlPlugin"

		// Limit number of jobs to avoid overloading the phone
		private val lock = Semaphore(3)
	}

	override fun load(
		filepath: String, w: Long?, h: Long?, callback: (Result<Image>) -> Unit
	) {
		launch(Dispatchers.IO) {
			try {
				val result =
					decodeBytesToImage(File(filepath).readBytes(), w, h)
				callback(Result.success(result))
			} catch (e: Throwable) {
				callback(Result.failure(e))
			}
		}
	}

	override fun loadBytes(
		bytes: ByteArray, w: Long?, h: Long?, callback: (Result<Image>) -> Unit
	) {
		launch(Dispatchers.IO) {
			try {
				val result = decodeBytesToImage(bytes, w, h)
				callback(Result.success(result))
			} catch (e: Throwable) {
				callback(Result.failure(e))
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

	override fun convertJpeg(
		filepath: String, w: Long?, h: Long?,
		callback: (Result<Unit>) -> Unit
	) {
		launch(Dispatchers.IO) {
			try {
				val bitmap = decodeBytes(File(filepath).readBytes(), w, h)
				bitmap.use {
					File(filepath).outputStream().use { oStream ->
						bitmap.compress(
							Bitmap.CompressFormat.JPEG, 85, oStream
						)
					}
				}
				callback(Result.success(Unit))
			} catch (e: Throwable) {
				callback(Result.failure(e))
			}
		}
	}

	private suspend fun decodeBytesToImage(
		bytes: ByteArray, w: Long?, h: Long?
	): Image {
		try {
			val bitmap = decodeBytes(bytes, w, h)
			val rgba8 = bitmap.use { Rgba8Image.fromBitmap(it) }
			return Image(
				pixel = rgba8.pixel,
				width = rgba8.width.toLong(),
				height = rgba8.height.toLong()
			)
		} catch (e: Throwable) {
			logE(TAG, "Failed to convert decoded data", e)
			throw FlutterError(
				"convert-error", "Failed to convert decoded data",
				e.message
			)
		}
	}

	private suspend fun decodeBytes(
		bytes: ByteArray, w: Long?, h: Long?
	): Bitmap {
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
				throw FlutterError(
					"decode-error", "Failed to decode bytes", e.message
				)
			}
			return bitmap
		}
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
