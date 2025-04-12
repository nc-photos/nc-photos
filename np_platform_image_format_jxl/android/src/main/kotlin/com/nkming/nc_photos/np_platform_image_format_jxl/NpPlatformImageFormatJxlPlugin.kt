package com.nkming.nc_photos.np_platform_image_format_jxl

import com.awxkee.jxlcoder.JxlCoder
import com.awxkee.jxlcoder.ScaleMode
import com.nkming.nc_photos.np_android_core.Rgba8Image
import com.nkming.nc_photos.np_android_core.logE
import com.nkming.nc_photos.np_android_core.use
import io.flutter.embedding.engine.plugins.FlutterPlugin
import java.io.File

private class PigeonApiImpl : MyHostApi {
  companion object {
    private const val TAG = "PigeonApiImpl"
  }

  override fun load(filepath: String, w: Long?, h: Long?): Image {
    return loadBytes(File(filepath).readBytes(), w, h)
  }

  override fun loadBytes(bytes: ByteArray, w: Long?, h: Long?): Image {
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
      throw FlutterError("decode-error", "Failed to decode bytes", e.message)
    }
    try {
      val rgba8 = bitmap.use { Rgba8Image.fromBitmap(bitmap) }
      return Image(
        pixel = rgba8.pixel,
        width = rgba8.width.toLong(),
        height = rgba8.height.toLong()
      )
    } catch (e: Throwable) {
      logE(TAG, "Failed to convert decoded data", e)
      throw FlutterError("convert-error", "Failed to convert decoded data", e.message)
    }
  }

  override fun loadMetadata(filepath: String): Metadata? {
    val size = try {
      JxlCoder.getSize(File(filepath).readBytes())
    } catch (e: Throwable) {
      logE(TAG, "Failed to decode file: $filepath", e)
      throw FlutterError("decode-error", "Failed to decode file", e.message)
    }
    size ?: return null
    return Metadata(size.width.toLong(), size.height.toLong())
  }

  override fun save(img: Image, filepath: String): Boolean {
    TODO("Not yet implemented")
  }
}

class NpPlatformImageFormatJxlPlugin: FlutterPlugin {
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val api = PigeonApiImpl()
    MyHostApi.setUp(flutterPluginBinding.binaryMessenger, api)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
  }
}
