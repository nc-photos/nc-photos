package com.nkming.nc_photos

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
				MediaStoreChannelHandler.CHANNEL).setMethodCallHandler(
				MediaStoreChannelHandler(this))
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
				NotificationChannelHandler.CHANNEL).setMethodCallHandler(
				NotificationChannelHandler(this))
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
				SelfSignedCertChannelHandler.CHANNEL).setMethodCallHandler(
				SelfSignedCertChannelHandler(this))
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
				ShareChannelHandler.CHANNEL).setMethodCallHandler(
				ShareChannelHandler(this))
	}
}