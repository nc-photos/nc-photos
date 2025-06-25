package com.nkming.nc_photos.np_android_core

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

interface PermissionUtil {
	companion object {
		const val REQUEST_CODE = K.PERMISSION_REQUEST_CODE

		fun request(
			activity: Activity, vararg permissions: String
		) {
			ActivityCompat.requestPermissions(
				activity, permissions, REQUEST_CODE
			)
		}

		/// readExternalStorage + accessMediaLocation
		fun hasReadMedia(context: Context): Boolean {
			return hasReadExternalStorage(context) &&
					hasAccessMediaLocation(context)
		}

		fun requestReadMedia(activity: Activity) {
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
				request(
					activity,
					Manifest.permission.READ_MEDIA_IMAGES,
					Manifest.permission.READ_MEDIA_VIDEO,
					Manifest.permission.ACCESS_MEDIA_LOCATION
				)
			} else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
				request(
					activity,
					Manifest.permission.READ_EXTERNAL_STORAGE,
					Manifest.permission.ACCESS_MEDIA_LOCATION
				)
			} else {
				request(activity, Manifest.permission.READ_EXTERNAL_STORAGE)
			}
		}

		fun hasReadExternalStorage(context: Context): Boolean {
			return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
				hasReadExternalStorage33(context)
			} else {
				hasReadExternalStorage0(context)
			}
		}

		fun requestReadExternalStorage(activity: Activity) {
			return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
				requestReadExternalStorage33(activity)
			} else {
				requestReadExternalStorage0(activity)
			}
		}

		fun hasWriteExternalStorage(context: Context): Boolean {
			return ContextCompat.checkSelfPermission(
				context, Manifest.permission.WRITE_EXTERNAL_STORAGE
			) == PackageManager.PERMISSION_GRANTED
		}

		fun requestWriteExternalStorage(activity: Activity) = request(
			activity, Manifest.permission.WRITE_EXTERNAL_STORAGE
		)

		fun hasPostNotifications(context: Context): Boolean {
			return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
				hasPostNotifications33(context)
			} else {
				true
			}
		}

		fun requestPostNotifications(activity: Activity) {
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
				requestPostNotifications33(activity)
			}
		}

		fun hasAccessMediaLocation(context: Context): Boolean {
			return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
				hasAccessMediaLocation30(context)
			} else {
				true
			}
		}

		@RequiresApi(Build.VERSION_CODES.TIRAMISU)
		private fun hasReadExternalStorage33(context: Context): Boolean {
			return ContextCompat.checkSelfPermission(
				context, Manifest.permission.READ_MEDIA_IMAGES
			) == PackageManager.PERMISSION_GRANTED && ContextCompat.checkSelfPermission(
				context, Manifest.permission.READ_MEDIA_VIDEO
			) == PackageManager.PERMISSION_GRANTED
		}

		private fun hasReadExternalStorage0(context: Context): Boolean {
			return ContextCompat.checkSelfPermission(
				context, Manifest.permission.READ_EXTERNAL_STORAGE
			) == PackageManager.PERMISSION_GRANTED
		}

		@RequiresApi(Build.VERSION_CODES.TIRAMISU)
		private fun requestReadExternalStorage33(activity: Activity) = request(
			activity,
			Manifest.permission.READ_MEDIA_IMAGES,
			Manifest.permission.READ_MEDIA_VIDEO
		)

		private fun requestReadExternalStorage0(activity: Activity) = request(
			activity, Manifest.permission.READ_EXTERNAL_STORAGE
		)

		@RequiresApi(Build.VERSION_CODES.TIRAMISU)
		private fun hasPostNotifications33(context: Context): Boolean {
			return ContextCompat.checkSelfPermission(
				context, Manifest.permission.POST_NOTIFICATIONS
			) == PackageManager.PERMISSION_GRANTED
		}

		@RequiresApi(Build.VERSION_CODES.TIRAMISU)
		private fun requestPostNotifications33(activity: Activity) = request(
			activity, Manifest.permission.POST_NOTIFICATIONS
		)

		@RequiresApi(Build.VERSION_CODES.R)
		private fun hasAccessMediaLocation30(context: Context): Boolean {
			return ContextCompat.checkSelfPermission(
				context, Manifest.permission.ACCESS_MEDIA_LOCATION
			) == PackageManager.PERMISSION_GRANTED
		}
	}
}
