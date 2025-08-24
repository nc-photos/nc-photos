package com.nkming.nc_photos.plugin

import android.content.Intent
import androidx.annotation.NonNull
import com.nkming.nc_photos.np_android_core.logE
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class NcPhotosPlugin : FlutterPlugin, ActivityAware,
	PluginRegistry.ActivityResultListener {
	companion object {
		const val ACTION_DOWNLOAD_CANCEL = K.ACTION_DOWNLOAD_CANCEL
		const val EXTRA_NOTIFICATION_ID = K.EXTRA_NOTIFICATION_ID

		private const val TAG = "NcPhotosPlugin"
	}

	override fun onAttachedToEngine(
		@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
	) {
		notificationChannel = MethodChannel(
			flutterPluginBinding.binaryMessenger,
			NotificationChannelHandler.CHANNEL
		)
		notificationChannel.setMethodCallHandler(
			NotificationChannelHandler(
				flutterPluginBinding.applicationContext
			)
		)

		mediaStoreChannelHandler =
			MediaStoreChannelHandler(flutterPluginBinding.applicationContext)
		mediaStoreChannel = EventChannel(
			flutterPluginBinding.binaryMessenger,
			MediaStoreChannelHandler.EVENT_CHANNEL
		)
		mediaStoreChannel.setStreamHandler(mediaStoreChannelHandler)
		mediaStoreMethodChannel = MethodChannel(
			flutterPluginBinding.binaryMessenger,
			MediaStoreChannelHandler.METHOD_CHANNEL
		)
		mediaStoreMethodChannel.setMethodCallHandler(mediaStoreChannelHandler)

		contentUriMethodChannel = MethodChannel(
			flutterPluginBinding.binaryMessenger,
			ContentUriChannelHandler.METHOD_CHANNEL
		)
		contentUriMethodChannel.setMethodCallHandler(
			ContentUriChannelHandler(flutterPluginBinding.applicationContext)
		)

		val preferenceChannelHandler =
			PreferenceChannelHandler(flutterPluginBinding.applicationContext)
		preferenceMethodChannel = MethodChannel(
			flutterPluginBinding.binaryMessenger,
			PreferenceChannelHandler.METHOD_CHANNEL
		)
		preferenceMethodChannel.setMethodCallHandler(preferenceChannelHandler)
	}

	override fun onDetachedFromEngine(
		@NonNull binding: FlutterPlugin.FlutterPluginBinding
	) {
		notificationChannel.setMethodCallHandler(null)
		mediaStoreChannel.setStreamHandler(null)
		mediaStoreMethodChannel.setMethodCallHandler(null)
		contentUriMethodChannel.setMethodCallHandler(null)
		preferenceMethodChannel.setMethodCallHandler(null)
	}

	override fun onAttachedToActivity(binding: ActivityPluginBinding) {
		mediaStoreChannelHandler.onAttachedToActivity(binding)
		pluginBinding = binding
		binding.addActivityResultListener(this)
	}

	override fun onReattachedToActivityForConfigChanges(
		binding: ActivityPluginBinding
	) {
		mediaStoreChannelHandler.onReattachedToActivityForConfigChanges(binding)
		pluginBinding = binding
		binding.addActivityResultListener(this)
	}

	override fun onDetachedFromActivity() {
		mediaStoreChannelHandler.onDetachedFromActivity()
		pluginBinding?.removeActivityResultListener(this)
	}

	override fun onDetachedFromActivityForConfigChanges() {
		mediaStoreChannelHandler.onDetachedFromActivityForConfigChanges()
		pluginBinding?.removeActivityResultListener(this)
	}

	override fun onActivityResult(
		requestCode: Int, resultCode: Int, data: Intent?
	): Boolean {
		return try {
			when (requestCode) {
				K.MEDIA_STORE_DELETE_REQUEST_CODE -> {
					mediaStoreChannelHandler.onActivityResult(
						requestCode, resultCode, data
					)
				}

				K.MEDIA_STORE_TRASH_REQUEST_CODE -> {
					mediaStoreChannelHandler.onActivityResult(
						requestCode, resultCode, data
					)
				}

				else -> false
			}
		} catch (e: Throwable) {
			logE(TAG, "Failed while onActivityResult, requestCode=$requestCode")
			false
		}
	}

	private var pluginBinding: ActivityPluginBinding? = null

	private lateinit var notificationChannel: MethodChannel
	private lateinit var mediaStoreChannel: EventChannel
	private lateinit var mediaStoreMethodChannel: MethodChannel
	private lateinit var contentUriMethodChannel: MethodChannel
	private lateinit var preferenceMethodChannel: MethodChannel

	private lateinit var mediaStoreChannelHandler: MediaStoreChannelHandler
}
