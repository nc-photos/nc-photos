package com.nkming.nc_photos.np_android_core

import android.app.PendingIntent
import android.os.Build
import android.os.Bundle
import java.io.Serializable
import java.net.HttpURLConnection

fun getPendingIntentFlagImmutable(): Int {
	return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) PendingIntent.FLAG_IMMUTABLE else 0
}

fun getPendingIntentFlagMutable(): Int {
	return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) PendingIntent.FLAG_MUTABLE else 0
}

inline fun <T> HttpURLConnection.use(block: (HttpURLConnection) -> T): T {
	try {
		connect()
		return block(this)
	} finally {
		disconnect()
	}
}

inline fun ByteArray.transform(transform: (Byte) -> Byte) {
	forEachIndexed { i, v -> this[i] = transform(v) }
}

inline fun <T> measureTime(tag: String, message: String, block: () -> T): T {
	val begin = System.currentTimeMillis()
	try {
		return block()
	} finally {
		val end = System.currentTimeMillis()
		val elapsed = end - begin
		logI(tag, "$message: ${elapsed}ms")
	}
}

fun Bundle.getIntOrNull(key: String) = get(key) as? Int

fun Bundle.getDoubleOrNull(key: String) = get(key) as? Double

@Suppress("Unchecked_cast")
fun <T> Serializable.asType() = this as T
