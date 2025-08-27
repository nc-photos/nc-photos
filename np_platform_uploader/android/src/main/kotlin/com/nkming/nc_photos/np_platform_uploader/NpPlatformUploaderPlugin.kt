package com.nkming.nc_photos.np_platform_uploader

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

class NpPlatformUploaderPlugin : FlutterPlugin {
	companion object {
		init {
			System.loadLibrary("np_platform_uploader")
		}
	}

	override fun onAttachedToEngine(
		flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
	) {
		val channelHandler =
			UploaderChannelHandler(flutterPluginBinding.applicationContext)
		methodChannel = MethodChannel(
			flutterPluginBinding.binaryMessenger,
			UploaderChannelHandler.METHOD_CHANNEL
		)
		methodChannel.setMethodCallHandler(channelHandler)
	}

	override fun onDetachedFromEngine(
		binding: FlutterPlugin.FlutterPluginBinding
	) {
		methodChannel.setMethodCallHandler(null)
	}

	private lateinit var methodChannel: MethodChannel
}
