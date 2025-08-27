package com.nkming.nc_photos.np_platform_uploader

import android.content.ContentResolver
import android.net.Uri
import com.nkming.nc_photos.np_android_core.logE
import java.io.File

class FormatConverter(
	val contentResolver: ContentResolver
) {
	companion object {
		private const val TAG = "FormatConverter"
	}

	enum class Format(val value: Int) {
		JPEG(0),
	}

	/**
	 * @param quality Specify the quality hints when compressing to the desired
	 * format. May not be supported by all formats.
	 * @param downsizeMp Downsize the image to a specific MP size while
	 * retaining the aspect ratio
	 */
	fun convert(
		uri: Uri,
		exportDir: File,
		format: Format,
		quality: Int,
		downsizeMp: Double?
	): File? {
		val outFile = File.createTempFile("out", null, exportDir)
		try {
			contentResolver.openFileDescriptor(uri, "r").use {
				if (it == null) {
					logE(TAG, "Failed to open file uri: $uri")
					outFile.delete()
					return null
				}
				val result = convertNative(
					it.fd, outFile.absolutePath, format.value, quality,
					downsizeMp ?: -1.0
				)
				if (result != 0) {
					logE(
						TAG,
						"Failed to convert file uri, result: $result, uri: $uri"
					)
					outFile.delete()
					return null
				}
			}
			return outFile
		} catch (e: Throwable) {
			outFile.delete()
			throw e
		}
	}

	private external fun convertNative(
		srcFd: Int,
		dstPath: String,
		format: Int,
		quality: Int,
		downsizeMp: Double
	): Int
}
