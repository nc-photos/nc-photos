package com.nkming.nc_photos.np_platform_image_processor

import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.core.content.ContextCompat
import com.nkming.nc_photos.np_android_core.logE
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal class ImageProcessorChannelHandler(context: Context) :
	MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
	companion object {
		const val EVENT_CHANNEL = "${K.LIB_ID}/image_processor_event"
		const val METHOD_CHANNEL = "${K.LIB_ID}/image_processor_method"

		fun fire(ev: ImageProcessorEvent) {
			synchronized(eventSinks) {
				for (s in eventSinks.values) {
					s.success(buildMap {
						put("event", ev.getId())
					})
				}
			}
		}

		private val eventSinks = mutableMapOf<Int, EventChannel.EventSink>()
		private var nextId = 0

		private const val TAG = "ImageProcessorChannelHandler"
	}

	override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
		when (call.method) {
			"zeroDce" -> {
				try {
					zeroDce(
						call.argument("fileUri")!!, call.argument("headers"),
						call.argument("filename")!!,
						call.argument("maxWidth")!!,
						call.argument("maxHeight")!!,
						call.argument<Boolean>("isSaveToServer")!!,
						call.argument("iteration")!!, result
					)
				} catch (e: Throwable) {
					logE(TAG, "Uncaught exception", e)
					result.error("systemException", e.toString(), null)
				}
			}

			"deepLab3Portrait" -> {
				try {
					deepLab3Portrait(
						call.argument("fileUri")!!, call.argument("headers"),
						call.argument("filename")!!,
						call.argument("maxWidth")!!,
						call.argument("maxHeight")!!,
						call.argument<Boolean>("isSaveToServer")!!,
						call.argument("radius")!!, result
					)
				} catch (e: Throwable) {
					logE(TAG, "Uncaught exception", e)
					result.error("systemException", e.toString(), null)
				}
			}

			"esrgan" -> {
				try {
					esrgan(
						call.argument("fileUri")!!, call.argument("headers"),
						call.argument("filename")!!,
						call.argument("maxWidth")!!,
						call.argument("maxHeight")!!,
						call.argument<Boolean>("isSaveToServer")!!, result
					)
				} catch (e: Throwable) {
					logE(TAG, "Uncaught exception", e)
					result.error("systemException", e.toString(), null)
				}
			}

			"arbitraryStyleTransfer" -> {
				try {
					arbitraryStyleTransfer(
						call.argument("fileUri")!!, call.argument("headers"),
						call.argument("filename")!!,
						call.argument("maxWidth")!!,
						call.argument("maxHeight")!!,
						call.argument<Boolean>("isSaveToServer")!!,
						call.argument("styleUri")!!, call.argument("weight")!!,
						result
					)
				} catch (e: Throwable) {
					logE(TAG, "Uncaught exception", e)
					result.error("systemException", e.toString(), null)
				}
			}

			"deepLab3ColorPop" -> {
				try {
					deepLab3ColorPop(
						call.argument("fileUri")!!, call.argument("headers"),
						call.argument("filename")!!,
						call.argument("maxWidth")!!,
						call.argument("maxHeight")!!,
						call.argument<Boolean>("isSaveToServer")!!,
						call.argument("weight")!!, result
					)
				} catch (e: Throwable) {
					logE(TAG, "Uncaught exception", e)
					result.error("systemException", e.toString(), null)
				}
			}

			"neurOp" -> {
				try {
					neurOp(
						call.argument("fileUri")!!, call.argument("headers"),
						call.argument("filename")!!,
						call.argument("maxWidth")!!,
						call.argument("maxHeight")!!,
						call.argument<Boolean>("isSaveToServer")!!, result
					)
				} catch (e: Throwable) {
					logE(TAG, "Uncaught exception", e)
					result.error("systemException", e.toString(), null)
				}
			}

			else -> result.notImplemented()
		}
	}

	override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
		synchronized(eventSinks) {
			eventSinks[id] = events
		}
	}

	override fun onCancel(arguments: Any?) {
		synchronized(eventSinks) {
			eventSinks.remove(id)
		}
	}

	private fun zeroDce(
		fileUri: String, headers: Map<String, String>?, filename: String,
		maxWidth: Int, maxHeight: Int, isSaveToServer: Boolean, iteration: Int,
		result: MethodChannel.Result
	) = method(fileUri, headers, filename, maxWidth, maxHeight, isSaveToServer,
		ImageProcessorService.METHOD_ZERO_DCE, result, onIntent = {
			it.putExtra(ImageProcessorService.EXTRA_ITERATION, iteration)
		})

	private fun deepLab3Portrait(
		fileUri: String, headers: Map<String, String>?, filename: String,
		maxWidth: Int, maxHeight: Int, isSaveToServer: Boolean, radius: Int,
		result: MethodChannel.Result
	) = method(fileUri, headers, filename, maxWidth, maxHeight, isSaveToServer,
		ImageProcessorService.METHOD_DEEP_LAP_PORTRAIT, result, onIntent = {
			it.putExtra(ImageProcessorService.EXTRA_RADIUS, radius)
		})

	private fun esrgan(
		fileUri: String, headers: Map<String, String>?, filename: String,
		maxWidth: Int, maxHeight: Int, isSaveToServer: Boolean,
		result: MethodChannel.Result
	) = method(
		fileUri, headers, filename, maxWidth, maxHeight, isSaveToServer,
		ImageProcessorService.METHOD_ESRGAN, result
	)

	private fun arbitraryStyleTransfer(
		fileUri: String, headers: Map<String, String>?, filename: String,
		maxWidth: Int, maxHeight: Int, isSaveToServer: Boolean,
		styleUri: String, weight: Float, result: MethodChannel.Result
	) = method(fileUri, headers, filename, maxWidth, maxHeight, isSaveToServer,
		ImageProcessorService.METHOD_ARBITRARY_STYLE_TRANSFER, result,
		onIntent = {
			it.putExtra(
				ImageProcessorService.EXTRA_STYLE_URI, Uri.parse(styleUri)
			)
			it.putExtra(ImageProcessorService.EXTRA_WEIGHT, weight)
		})

	private fun deepLab3ColorPop(
		fileUri: String, headers: Map<String, String>?, filename: String,
		maxWidth: Int, maxHeight: Int, isSaveToServer: Boolean, weight: Float,
		result: MethodChannel.Result
	) = method(fileUri, headers, filename, maxWidth, maxHeight, isSaveToServer,
		ImageProcessorService.METHOD_DEEP_LAP_COLOR_POP, result, onIntent = {
			it.putExtra(ImageProcessorService.EXTRA_WEIGHT, weight)
		})

	private fun neurOp(
		fileUri: String, headers: Map<String, String>?, filename: String,
		maxWidth: Int, maxHeight: Int, isSaveToServer: Boolean,
		result: MethodChannel.Result
	) = method(
		fileUri, headers, filename, maxWidth, maxHeight, isSaveToServer,
		ImageProcessorService.METHOD_NEUR_OP, result
	)

	private fun method(
		fileUri: String, headers: Map<String, String>?, filename: String,
		maxWidth: Int, maxHeight: Int, isSaveToServer: Boolean, method: String,
		result: MethodChannel.Result, onIntent: ((Intent) -> Unit)? = null
	) {
		val intent = Intent(context, ImageProcessorService::class.java).apply {
			putExtra(ImageProcessorService.EXTRA_METHOD, method)
			putExtra(ImageProcessorService.EXTRA_FILE_URI, Uri.parse(fileUri))
			putExtra(ImageProcessorService.EXTRA_HEADERS,
				headers?.let { HashMap(it) })
			putExtra(ImageProcessorService.EXTRA_FILENAME, filename)
			putExtra(ImageProcessorService.EXTRA_MAX_WIDTH, maxWidth)
			putExtra(ImageProcessorService.EXTRA_MAX_HEIGHT, maxHeight)
			putExtra(
				ImageProcessorService.EXTRA_IS_SAVE_TO_SERVER, isSaveToServer
			)
			onIntent?.invoke(this)
		}
		ContextCompat.startForegroundService(context, intent)
		result.success(null)
	}

	private val context = context
	private val id = nextId++
}
