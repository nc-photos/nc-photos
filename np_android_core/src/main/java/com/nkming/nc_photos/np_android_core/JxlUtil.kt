package com.nkming.nc_photos.np_android_core

class JxlUtil {
	companion object {
		@JvmStatic
		fun isJxl(src: ByteArray): Boolean {
			return src.sliceArray(magic1.indices).contentEquals(magic1) ||
					src.sliceArray(magic2.indices).contentEquals(magic2)
		}

		private val magic1 = byteArrayOf(0xFF.toByte(), 0x0A)
		private val magic2 = byteArrayOf(
			0x0.toByte(),
			0x0.toByte(),
			0x0.toByte(),
			0x0C.toByte(),
			0x4A,
			0x58,
			0x4C,
			0x20,
			0x0D,
			0x0A,
			0x87.toByte(),
			0x0A
		)
	}
}
