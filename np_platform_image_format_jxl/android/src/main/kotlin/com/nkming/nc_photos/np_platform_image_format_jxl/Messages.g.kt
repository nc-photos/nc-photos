// Autogenerated from Pigeon (v22.6.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
@file:Suppress("UNCHECKED_CAST", "ArrayInDataClass")

package com.nkming.nc_photos.np_platform_image_format_jxl

import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  return if (exception is FlutterError) {
    listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

/** Generated class from Pigeon that represents data sent in messages. */
data class Image (
  val pixel: ByteArray,
  val width: Long,
  val height: Long
)
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): Image {
      val pixel = pigeonVar_list[0] as ByteArray
      val width = pigeonVar_list[1] as Long
      val height = pigeonVar_list[2] as Long
      return Image(pixel, width, height)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      pixel,
      width,
      height,
    )
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class Metadata (
  val w: Long,
  val h: Long
)
 {
  companion object {
    fun fromList(pigeonVar_list: List<Any?>): Metadata {
      val w = pigeonVar_list[0] as Long
      val h = pigeonVar_list[1] as Long
      return Metadata(w, h)
    }
  }
  fun toList(): List<Any?> {
    return listOf(
      w,
      h,
    )
  }
}
private open class MessagesPigeonCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      129.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          Image.fromList(it)
        }
      }
      130.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          Metadata.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is Image -> {
        stream.write(129)
        writeValue(stream, value.toList())
      }
      is Metadata -> {
        stream.write(130)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface MyHostApi {
  fun load(filepath: String, w: Long?, h: Long?): Image
  fun loadBytes(bytes: ByteArray, w: Long?, h: Long?): Image
  fun loadMetadata(filepath: String): Metadata?
  fun save(img: Image, filepath: String): Boolean

  companion object {
    /** The codec used by MyHostApi. */
    val codec: MessageCodec<Any?> by lazy {
      MessagesPigeonCodec()
    }
    /** Sets up an instance of `MyHostApi` to handle messages through the `binaryMessenger`. */
    @JvmOverloads
    fun setUp(binaryMessenger: BinaryMessenger, api: MyHostApi?, messageChannelSuffix: String = "") {
      val separatedMessageChannelSuffix = if (messageChannelSuffix.isNotEmpty()) ".$messageChannelSuffix" else ""
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.np_platform_image_format_jxl.MyHostApi.load$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val filepathArg = args[0] as String
            val wArg = args[1] as Long?
            val hArg = args[2] as Long?
            val wrapped: List<Any?> = try {
              listOf(api.load(filepathArg, wArg, hArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.np_platform_image_format_jxl.MyHostApi.loadBytes$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val bytesArg = args[0] as ByteArray
            val wArg = args[1] as Long?
            val hArg = args[2] as Long?
            val wrapped: List<Any?> = try {
              listOf(api.loadBytes(bytesArg, wArg, hArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.np_platform_image_format_jxl.MyHostApi.loadMetadata$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val filepathArg = args[0] as String
            val wrapped: List<Any?> = try {
              listOf(api.loadMetadata(filepathArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.np_platform_image_format_jxl.MyHostApi.save$separatedMessageChannelSuffix", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val imgArg = args[0] as Image
            val filepathArg = args[1] as String
            val wrapped: List<Any?> = try {
              listOf(api.save(imgArg, filepathArg))
            } catch (exception: Throwable) {
              wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
