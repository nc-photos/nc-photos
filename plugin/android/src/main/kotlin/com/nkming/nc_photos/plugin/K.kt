package com.nkming.nc_photos.plugin

internal interface K {
	companion object {
		const val DOWNLOAD_NOTIFICATION_ID_MIN = 1000
		const val DOWNLOAD_NOTIFICATION_ID_MAX = 2000

		const val MEDIA_STORE_DELETE_REQUEST_CODE = 11012
		const val MEDIA_STORE_TRASH_REQUEST_CODE = 11013

		const val LIB_ID = "com.nkming.nc_photos.plugin"

		const val ACTION_DOWNLOAD_CANCEL = "${LIB_ID}.ACTION_DOWNLOAD_CANCEL"

		const val EXTRA_NOTIFICATION_ID = "${LIB_ID}.EXTRA_NOTIFICATION_ID"
	}
}
