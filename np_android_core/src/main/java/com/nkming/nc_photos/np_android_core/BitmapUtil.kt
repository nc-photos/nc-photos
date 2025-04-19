package com.nkming.nc_photos.np_android_core

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.net.Uri
import androidx.exifinterface.media.ExifInterface
import com.awxkee.jxlcoder.JxlCoder
import com.awxkee.jxlcoder.PreferredColorConfig
import com.awxkee.jxlcoder.ScaleMode
import java.io.InputStream
import java.nio.ByteBuffer
import kotlin.contracts.ExperimentalContracts
import kotlin.contracts.InvocationKind
import kotlin.contracts.contract

fun Bitmap.aspectRatio() = width / height.toFloat()

/**
 * Recycle the bitmap after @c block returns.
 *
 * @param block
 * @return
 */
@OptIn(ExperimentalContracts::class)
inline fun <T> Bitmap.use(block: (Bitmap) -> T): T {
	contract {
		callsInPlace(block, InvocationKind.EXACTLY_ONCE)
	}
	try {
		return block(this)
	} finally {
		recycle()
	}
}

enum class BitmapResizeMethod {
	FIT, FILL,
}

interface BitmapUtil {
	companion object {
		fun loadImageFixed(
			context: Context, uri: Uri, targetW: Int, targetH: Int
		): Bitmap {
			val opt = loadImageBounds(context, uri)
			val subsample = calcBitmapSubsample(
				opt.outWidth, opt.outHeight, targetW, targetH,
				BitmapResizeMethod.FILL
			)
			if (subsample > 1) {
				logD(
					TAG,
					"Subsample image to fixed: $subsample ${opt.outWidth}x${opt.outHeight} -> ${targetW}x$targetH"
				)
			}
			val outOpt = BitmapFactory.Options().apply {
				inSampleSize = subsample
			}
			val bitmap = loadImage(context, uri, outOpt)
			if (subsample > 1) {
				logD(TAG, "Bitmap subsampled: ${bitmap.width}x${bitmap.height}")
			}
			return Bitmap.createScaledBitmap(bitmap, targetW, targetH, true)
		}

		/**
		 * Load a bitmap
		 *
		 * If @c resizeMethod == FIT, make sure the size of the bitmap can fit
		 * inside the bound defined by @c targetW and @c targetH, i.e.,
		 * bitmap.w <= @c targetW and bitmap.h <= @c targetH
		 *
		 * If @c resizeMethod == FILL, make sure the size of the bitmap can
		 * completely fill the bound defined by @c targetW and @c targetH, i.e.,
		 * bitmap.w >= @c targetW and bitmap.h >= @c targetH
		 *
		 * If bitmap is smaller than the bound and @c shouldUpscale == true, it
		 * will be upscaled
		 *
		 * @param context
		 * @param uri
		 * @param targetW
		 * @param targetH
		 * @param resizeMethod
		 * @param isAllowSwapSide
		 * @param shouldUpscale
		 * @return
		 */
		fun loadImage(
			context: Context,
			uri: Uri,
			targetW: Int,
			targetH: Int,
			resizeMethod: BitmapResizeMethod,
			isAllowSwapSide: Boolean = false,
			shouldUpscale: Boolean = true,
			shouldFixOrientation: Boolean = false,
		): Bitmap {
			val isJxl = openUriInputStream(context, uri)!!.use {
				val bytes = ByteArray(16)
				it.read(bytes)
				return@use JxlUtil.isJxl(bytes)
			}
			return if (isJxl) {
				loadJxlImage(
					context, uri, targetW, targetH, resizeMethod,
					isAllowSwapSide, shouldUpscale, shouldFixOrientation
				)
			} else {
				loadAndroidImage(
					context, uri, targetW, targetH, resizeMethod,
					isAllowSwapSide, shouldUpscale, shouldFixOrientation
				)
			}
		}

		private fun loadJxlImage(
			context: Context,
			uri: Uri,
			targetW: Int,
			targetH: Int,
			resizeMethod: BitmapResizeMethod,
			isAllowSwapSide: Boolean,
			shouldUpscale: Boolean,
			shouldFixOrientation: Boolean,
		): Bitmap {
			val bytes =
				openUriInputStream(context, uri)!!.use { it.readBytes() }
			val imgSize = JxlCoder.getSize(bytes)!!
			val shouldSwapSide = isAllowSwapSide &&
					imgSize.width != imgSize.height &&
					(imgSize.width >= imgSize.height) != (targetW >= targetH)
			val dstW = if (shouldSwapSide) targetH else targetW
			val dstH = if (shouldSwapSide) targetW else targetH
			val scaleMode = when (resizeMethod) {
				BitmapResizeMethod.FIT -> ScaleMode.FIT
				BitmapResizeMethod.FILL -> ScaleMode.FILL
			}
			val result = JxlCoder.decodeSampled(bytes, dstW, dstH,
				PreferredColorConfig.RGBA_8888, scaleMode)
			return if (shouldFixOrientation) {
				fixOrientation(context, uri, result)
			} else {
				result
			}
		}

		private fun loadAndroidImage(
			context: Context,
			uri: Uri,
			targetW: Int,
			targetH: Int,
			resizeMethod: BitmapResizeMethod,
			isAllowSwapSide: Boolean,
			shouldUpscale: Boolean,
			shouldFixOrientation: Boolean,
		): Bitmap {
			val opt = loadImageBounds(context, uri)
			val shouldSwapSide = isAllowSwapSide &&
					opt.outWidth != opt.outHeight &&
					(opt.outWidth >= opt.outHeight) != (targetW >= targetH)
			val dstW = if (shouldSwapSide) targetH else targetW
			val dstH = if (shouldSwapSide) targetW else targetH
			val subsample = calcBitmapSubsample(
				opt.outWidth, opt.outHeight, dstW, dstH, resizeMethod
			)
			if (subsample > 1) {
				logD(
					TAG,
					"Subsample image to ${resizeMethod.name}: $subsample ${opt.outWidth}x${opt.outHeight} -> ${dstW}x$dstH" + (if (shouldSwapSide) " (swapped)" else "")
				)
			}
			val outOpt = BitmapFactory.Options().apply {
				inSampleSize = subsample
			}
			val bitmap = loadImage(context, uri, outOpt)
			if (subsample > 1) {
				logD(TAG, "Bitmap subsampled: ${bitmap.width}x${bitmap.height}")
			}
			if (bitmap.width < dstW && bitmap.height < dstH && !shouldUpscale) {
				return if (shouldFixOrientation) {
					fixOrientation(context, uri, bitmap)
				} else {
					bitmap
				}
			}
			val result = when (resizeMethod) {
				BitmapResizeMethod.FIT -> Bitmap.createScaledBitmap(
					bitmap, minOf(dstW, (dstH * bitmap.aspectRatio()).toInt()),
					minOf(dstH, (dstW / bitmap.aspectRatio()).toInt()), true
				)

				BitmapResizeMethod.FILL -> Bitmap.createScaledBitmap(
					bitmap, maxOf(dstW, (dstH * bitmap.aspectRatio()).toInt()),
					maxOf(dstH, (dstW / bitmap.aspectRatio()).toInt()), true
				)
			}
			return if (shouldFixOrientation) {
				fixOrientation(context, uri, result)
			} else {
				result
			}
		}

		/**
		 * Rotate the image to its visible orientation
		 */
		private fun fixOrientation(
			context: Context, uri: Uri, bitmap: Bitmap
		): Bitmap {
			return try {
				openUriInputStream(context, uri)!!.use {
					val iExif = ExifInterface(it)
					val orientation =
						iExif.getAttributeInt(ExifInterface.TAG_ORIENTATION, 1)
					logI(
						TAG,
						"[fixOrientation] Input file orientation: $orientation"
					)
					val rotate = when (orientation) {
						ExifInterface.ORIENTATION_ROTATE_90, ExifInterface.ORIENTATION_TRANSPOSE -> 90f

						ExifInterface.ORIENTATION_ROTATE_180, ExifInterface.ORIENTATION_FLIP_VERTICAL -> 180f

						ExifInterface.ORIENTATION_ROTATE_270, ExifInterface.ORIENTATION_TRANSVERSE -> 270f

						ExifInterface.ORIENTATION_FLIP_HORIZONTAL -> 0f
						else -> return bitmap
					}
					val mat = Matrix()
					mat.postRotate(rotate)
					if (orientation == ExifInterface.ORIENTATION_FLIP_HORIZONTAL || orientation == ExifInterface.ORIENTATION_TRANSVERSE || orientation == ExifInterface.ORIENTATION_FLIP_VERTICAL || orientation == ExifInterface.ORIENTATION_TRANSPOSE) {
						mat.postScale(-1f, 1f)
					}
					Bitmap.createBitmap(
						bitmap, 0, 0, bitmap.width, bitmap.height, mat, true
					)
				}
			} catch (e: Throwable) {
				logE(
					TAG,
					"[fixOrientation] Failed fixing, assume normal orientation",
					e
				)
				bitmap
			}
		}

		private fun openUriInputStream(
			context: Context, uri: Uri
		): InputStream? {
			return if (UriUtil.isAssetUri(uri)) {
				context.assets.open(UriUtil.getAssetUriPath(uri))
			} else {
				context.contentResolver.openInputStream(uri)
			}
		}

		private fun loadImageBounds(
			context: Context, uri: Uri
		): BitmapFactory.Options {
			openUriInputStream(context, uri)!!.use {
				val opt = BitmapFactory.Options().apply {
					inJustDecodeBounds = true
				}
				BitmapFactory.decodeStream(it, null, opt)
				return opt
			}
		}

		private fun loadImage(
			context: Context, uri: Uri, opt: BitmapFactory.Options
		): Bitmap {
			openUriInputStream(context, uri)!!.use {
				return BitmapFactory.decodeStream(it, null, opt)!!
			}
		}

		private fun calcBitmapSubsample(
			originalW: Int, originalH: Int, targetW: Int, targetH: Int,
			resizeMethod: BitmapResizeMethod
		): Int {
			return when (resizeMethod) {
				BitmapResizeMethod.FIT -> maxOf(
					originalW / targetW, originalH / targetH
				)

				BitmapResizeMethod.FILL -> minOf(
					originalW / targetW, originalH / targetH
				)
			}
		}

		private const val TAG = "BitmapUtil"
	}
}
