package com.nkming.nc_photos.np_platform_uploader

internal class HttpException(statusCode: Int, message: String) :
	Exception(message)
