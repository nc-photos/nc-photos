package com.nkming.nc_photos.np_platform_image_processor

import android.content.Context
import android.net.Uri
import com.nkming.nc_photos.np_android_core.MediaStoreUtil
import com.nkming.nc_photos.np_android_core.logE
import com.nkming.nc_photos.np_android_core.logI
import com.nkming.nc_photos.np_android_core.logW
import com.nkming.nc_photos.np_android_core.use
import java.io.File
import java.net.HttpURLConnection
import java.net.URL

interface EnhancedFilePersister {
	fun persist(cmd: ImageProcessorImageCommand, file: File): Uri
}

class EnhancedFileDevicePersister(context: Context) :
	EnhancedFilePersister {
	override fun persist(cmd: ImageProcessorImageCommand, file: File): Uri {
		val basename = cmd.filename.substringBeforeLast('.')
		val uri = MediaStoreUtil.copyFileToDownload(
			context, Uri.fromFile(file), "${basename}.jpg",
			"Photos (for Nextcloud)/${getSubDir(cmd)}"
		)
		return uri
	}

	private fun getSubDir(cmd: ImageProcessorImageCommand): String {
		return if (!cmd.isEnhanceCommand()) {
			"Edited Photos"
		} else {
			"Enhanced Photos"
		}
	}

	val context = context
}

class EnhancedFileServerPersister : EnhancedFilePersister {
	companion object {
		const val TAG = "EnhancedFileServerPersister"
	}

	override fun persist(cmd: ImageProcessorImageCommand, file: File): Uri {
		val ext = cmd.fileUrl.substringAfterLast('.', "")
		val url = if (ext.contains('/')) {
			// no ext
			"${cmd.fileUrl}_${getSuffix(cmd)}.jpg"
		} else {
			"${cmd.fileUrl.substringBeforeLast('.', "")}_${getSuffix(cmd)}.jpg"
		}
		logI(TAG, "[persist] Persist file to server: $url")
		(URL(url).openConnection() as HttpURLConnection).apply {
			requestMethod = "PUT"
			instanceFollowRedirects = true
			connectTimeout = 8000
			for (entry in (cmd.headers ?: mapOf()).entries) {
				setRequestProperty(entry.key, entry.value)
			}
		}.use {
			file.inputStream()
				.use { iStream -> iStream.copyTo(it.outputStream) }
			val responseCode = it.responseCode
			if (responseCode / 100 != 2) {
				logE(TAG, "[persist] Failed uploading file: HTTP$responseCode")
				throw HttpException(
					responseCode, "Failed uploading file (HTTP$responseCode)"
				)
			}
		}
		return Uri.parse(url)
	}

	private fun getSuffix(cmd: ImageProcessorImageCommand): String {
		val epoch = System.currentTimeMillis() / 1000
		return if (!cmd.isEnhanceCommand()) {
			"edited_$epoch"
		} else {
			"enhanced_$epoch"
		}
	}
}

class EnhancedFileServerPersisterWithFallback(context: Context) :
	EnhancedFilePersister {
	companion object {
		const val TAG = "EnhancedFileServerPersisterWithFallback"
	}

	override fun persist(cmd: ImageProcessorImageCommand, file: File): Uri {
		try {
			return server.persist(cmd, file)
		} catch (e: Throwable) {
			logW(
				TAG,
				"[persist] Failed while persisting to server, switch to fallback",
				e
			)
		}
		return fallback.persist(cmd, file)
	}

	private val server = EnhancedFileServerPersister()
	private val fallback = EnhancedFileDevicePersister(context)
}
