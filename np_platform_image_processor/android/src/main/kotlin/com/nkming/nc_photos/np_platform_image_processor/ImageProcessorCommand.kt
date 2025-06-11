package com.nkming.nc_photos.np_platform_image_processor

import android.content.Context
import android.graphics.Bitmap
import android.net.Uri
import com.nkming.nc_photos.np_platform_image_processor.processor.ArbitraryStyleTransfer
import com.nkming.nc_photos.np_platform_image_processor.processor.DeepLab3ColorPop
import com.nkming.nc_photos.np_platform_image_processor.processor.DeepLab3Portrait
import com.nkming.nc_photos.np_platform_image_processor.processor.Esrgan
import com.nkming.nc_photos.np_platform_image_processor.processor.ImageFilterProcessor
import com.nkming.nc_photos.np_platform_image_processor.processor.NeurOp
import com.nkming.nc_photos.np_platform_image_processor.processor.ZeroDce

interface ImageProcessorCommand

abstract class ImageProcessorImageCommand(
	val params: Params,
) : ImageProcessorCommand {
	class Params(
		val startId: Int,
		val fileUri: Uri,
		val headers: Map<String, String>?,
		val filename: String,
		val maxWidth: Int,
		val maxHeight: Int,
		val isSaveToServer: Boolean,
	)

	abstract fun apply(context: Context, fileUri: Uri): Bitmap
	abstract fun isEnhanceCommand(): Boolean

	val startId: Int
		get() = params.startId
	val fileUri: Uri
		get() = params.fileUri
	val headers: Map<String, String>?
		get() = params.headers
	val filename: String
		get() = params.filename
	val maxWidth: Int
		get() = params.maxWidth
	val maxHeight: Int
		get() = params.maxHeight
	val isSaveToServer: Boolean
		get() = params.isSaveToServer
}

class ImageProcessorDummyCommand(
	params: Params,
) : ImageProcessorImageCommand(params) {
	override fun apply(context: Context, fileUri: Uri): Bitmap {
		throw UnsupportedOperationException()
	}

	override fun isEnhanceCommand() = true
}

class ImageProcessorZeroDceCommand(
	params: Params,
	val iteration: Int?,
) : ImageProcessorImageCommand(params) {
	override fun apply(context: Context, fileUri: Uri): Bitmap {
		return ZeroDce(
			context, maxWidth, maxHeight, iteration ?: 8
		).infer(fileUri)
	}

	override fun isEnhanceCommand() = true
}

class ImageProcessorDeepLapPortraitCommand(
	params: Params,
	val radius: Int?,
) : ImageProcessorImageCommand(params) {
	override fun apply(context: Context, fileUri: Uri): Bitmap {
		return DeepLab3Portrait(
			context, maxWidth, maxHeight, radius ?: 16
		).infer(fileUri)
	}

	override fun isEnhanceCommand() = true
}

class ImageProcessorEsrganCommand(
	params: Params,
) : ImageProcessorImageCommand(params) {
	override fun apply(context: Context, fileUri: Uri): Bitmap {
		return Esrgan(context, maxWidth, maxHeight).infer(fileUri)
	}

	override fun isEnhanceCommand() = true
}

class ImageProcessorArbitraryStyleTransferCommand(
	params: Params,
	val styleUri: Uri,
	val weight: Float,
) : ImageProcessorImageCommand(params) {
	override fun apply(context: Context, fileUri: Uri): Bitmap {
		return ArbitraryStyleTransfer(
			context, maxWidth, maxHeight, styleUri, weight
		).infer(fileUri)
	}

	override fun isEnhanceCommand() = true
}

class ImageProcessorDeepLapColorPopCommand(
	params: Params,
	val weight: Float,
) : ImageProcessorImageCommand(params) {
	override fun apply(context: Context, fileUri: Uri): Bitmap {
		return DeepLab3ColorPop(
			context, maxWidth, maxHeight, weight
		).infer(fileUri)
	}

	override fun isEnhanceCommand() = true
}

class ImageProcessorNeurOpCommand(
	params: Params,
) : ImageProcessorImageCommand(params) {
	override fun apply(context: Context, fileUri: Uri): Bitmap {
		return NeurOp(context, maxWidth, maxHeight).infer(fileUri)
	}

	override fun isEnhanceCommand() = true
}

class ImageProcessorFilterCommand(
	params: Params,
	val filters: List<ImageFilter>,
) : ImageProcessorImageCommand(params) {
	override fun apply(context: Context, fileUri: Uri): Bitmap {
		return ImageFilterProcessor(
			context, maxWidth, maxHeight, filters
		).apply(fileUri)
	}

	override fun isEnhanceCommand() = false
}

class ImageProcessorGracePeriodCommand : ImageProcessorCommand
