package com.nkming.nc_photos.np_platform_local_media

import android.app.Activity
import android.content.ContentResolver
import android.content.ContentUris
import android.content.Context
import android.graphics.Bitmap
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.util.Size
import androidx.core.database.getLongOrNull
import androidx.core.net.toUri
import com.nkming.nc_photos.np_android_core.PermissionUtil
import com.nkming.nc_photos.np_android_core.UriUtil
import com.nkming.nc_photos.np_android_core.logE
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch
import java.io.ByteArrayOutputStream
import java.io.FileNotFoundException
import java.time.Instant
import java.time.ZoneId
import java.time.ZonedDateTime.ofInstant
import java.time.temporal.ChronoField
import java.time.temporal.ChronoUnit
import java.util.Locale

private class PigeonApiImpl : MyHostApi, ActivityAware, CoroutineScope by MainScope() {
    companion object {
        private const val TAG = "NpPlatformLocalMediaPlugin"
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onReattachedToActivityForConfigChanges(
        binding: ActivityPluginBinding
    ) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun getFilesSummary(
        dirWhitelist: List<String>?, callback: (Result<Map<String, Long>>) -> Unit
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
            callback(Result.success(mapOf()))
            return
        }
        if (activity == null) {
            callback(Result.failure(IllegalStateException("Context is null")))
            return
        }
        if (!PermissionUtil.hasReadMedia(context!!)) {
            callback(
                Result.failure(
                    FlutterError(
                        "permissionError", "Permission not granted", null
                    )
                )
            )
            return
        }
        launch(Dispatchers.IO) {
            try {
                val dateCount = mutableMapOf<String, Long>()
                var thisDateStr = ""
                var thisDateBeg = 0L
                var thisDateEnd = 0L
                var thisDateCount = 0L

                val whereArgs = mutableListOf<String>()
                var where =
                    "(" + "${MediaStore.Files.FileColumns.MEDIA_TYPE}=${MediaStore.Files.FileColumns.MEDIA_TYPE_IMAGE}" + " OR " + "${MediaStore.Files.FileColumns.MEDIA_TYPE}=${MediaStore.Files.FileColumns.MEDIA_TYPE_VIDEO}" + ")"
                where += " AND ${MediaStore.MediaColumns.DATE_TAKEN} IS NOT NULL"
                if (!dirWhitelist.isNullOrEmpty()) {
                    val (w, wa) = dirWhitelistToSql(dirWhitelist)
                    where += " AND $w"
                    whereArgs.addAll(wa)
                }
                context!!.contentResolver.query(
                    MediaStore.Files.getContentUri("external"),
                    arrayOf(
                        MediaStore.MediaColumns.DATE_TAKEN,
                    ),
                    Bundle().apply {
                        putString(ContentResolver.QUERY_ARG_SQL_SELECTION, where)
                        if (whereArgs.isNotEmpty()) {
                            putStringArray(
                                ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS,
                                whereArgs.toTypedArray(),
                            )
                        }
                        putString(
                            ContentResolver.QUERY_ARG_SQL_SORT_ORDER,
                            "${MediaStore.MediaColumns.DATE_TAKEN} DESC"
                        )
                    },
                    null,
                )?.use {
                    if (it.moveToFirst()) {
                        val dateColumn = it.getColumnIndexOrThrow(
                            MediaStore.MediaColumns.DATE_TAKEN
                        )
                        do {
                            val time = it.getLong(dateColumn)
                            if (time in thisDateBeg until thisDateEnd) {
                                // same date
                                ++thisDateCount
                            } else {
                                // new date
                                if (thisDateCount > 0) {
                                    dateCount[thisDateStr] = thisDateCount
                                }
                                val thisDate = ofInstant(
                                    Instant.ofEpochMilli(time), ZoneId.systemDefault()
                                ).truncatedTo(ChronoUnit.DAYS)
                                thisDateStr = String.format(
                                    Locale.US,
                                    "%04d%02d%02d",
                                    thisDate.get(ChronoField.YEAR),
                                    thisDate.get(ChronoField.MONTH_OF_YEAR),
                                    thisDate.get(ChronoField.DAY_OF_MONTH)
                                )
                                thisDateBeg = thisDate.toInstant().toEpochMilli()
                                thisDateEnd = thisDate.plusDays(1).toInstant().toEpochMilli()
                                thisDateCount = 1
                            }
                        } while (it.moveToNext())
                        if (thisDateCount > 0) {
                            dateCount[thisDateStr] = thisDateCount
                        }
                    }
                }
                callback(Result.success(dateCount))
            } catch (e: Throwable) {
                callback(Result.failure(FlutterError("systemException", e.message, null)))
            }
        }
    }

    override fun queryFiles(
        fileIds: List<String>?,
        timeRangeBeg: Long?,
        isTimeRangeBegInclusive: Boolean?,
        timeRangeEnd: Long?,
        isTimeRangeEndInclusive: Boolean?,
        dirWhitelist: List<String>?,
        isAscending: Boolean,
        offset: Long?,
        limit: Long?,
        callback: (Result<List<QueryResult>>) -> Unit
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
            callback(Result.success(listOf()))
            return
        }
        if (activity == null) {
            callback(Result.failure(IllegalStateException("Context is null")))
            return
        }
        if (!PermissionUtil.hasReadMedia(context!!)) {
            callback(
                Result.failure(
                    FlutterError(
                        "permissionError", "Permission not granted", null
                    )
                )
            )
            return
        }
        launch(Dispatchers.IO) {
            try {
                val wheres = mutableListOf<String>()
                val whereArgs = mutableListOf<String>()
                wheres.add(
                    "(${MediaStore.Files.FileColumns.MEDIA_TYPE}=${MediaStore.Files.FileColumns.MEDIA_TYPE_IMAGE} OR ${MediaStore.Files.FileColumns.MEDIA_TYPE}=${MediaStore.Files.FileColumns.MEDIA_TYPE_VIDEO})"
                )
                if (fileIds != null) {
                    val args = fileIds.joinToString(",", transform = { it.toString() })
                    wheres.add("${MediaStore.MediaColumns._ID} IN (${args})")
                }
                if (timeRangeBeg != null) {
                    if (isTimeRangeBegInclusive == false) {
                        wheres.add(
                            "${MediaStore.MediaColumns.DATE_TAKEN} > $timeRangeBeg"
                        )
                    } else {
                        wheres.add(
                            "${MediaStore.MediaColumns.DATE_TAKEN} >= $timeRangeBeg"
                        )
                    }
                }
                if (timeRangeEnd != null) {
                    if (isTimeRangeEndInclusive == true) {
                        wheres.add(
                            "${MediaStore.MediaColumns.DATE_TAKEN} <= $timeRangeEnd"
                        )
                    } else {
                        wheres.add(
                            "${MediaStore.MediaColumns.DATE_TAKEN} < $timeRangeEnd"
                        )
                    }
                }
                if (!dirWhitelist.isNullOrEmpty()) {
                    val (w, wa) = dirWhitelistToSql(dirWhitelist)
                    wheres.add(w)
                    whereArgs.addAll(wa)
                }

                context!!.contentResolver.query(
                    MediaStore.Files.getContentUri("external"),
                    arrayOf(
                        MediaStore.MediaColumns._ID,
                        MediaStore.MediaColumns.DATE_MODIFIED,
                        MediaStore.MediaColumns.MIME_TYPE,
                        MediaStore.MediaColumns.DATE_TAKEN,
                        MediaStore.MediaColumns.DISPLAY_NAME,
                        MediaStore.MediaColumns.RELATIVE_PATH,
                        MediaStore.MediaColumns.WIDTH,
                        MediaStore.MediaColumns.HEIGHT,
                        MediaStore.MediaColumns.SIZE,
                    ),
                    Bundle().apply {
                        if (wheres.isNotEmpty()) {
                            putString(
                                ContentResolver.QUERY_ARG_SQL_SELECTION,
                                wheres.joinToString(" AND "),
                            )
                        }
                        if (whereArgs.isNotEmpty()) {
                            putStringArray(
                                ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS,
                                whereArgs.toTypedArray(),
                            )
                        }
                        val order = if (isAscending) "ASC" else "DESC"
                        putString(
                            ContentResolver.QUERY_ARG_SQL_SORT_ORDER,
                            "${MediaStore.MediaColumns.DATE_TAKEN} $order, ${MediaStore.MediaColumns._ID} $order"
                        )
                        if (offset != null) {
                            putInt(ContentResolver.QUERY_ARG_OFFSET, offset.toInt())
                        }
                        if (limit != null) {
                            putInt(ContentResolver.QUERY_ARG_LIMIT, limit.toInt())
                        }
                    },
                    null,
                )?.use {
                    val products = mutableListOf<QueryResult>()
                    if (it.moveToFirst()) {
                        val idColumn = it.getColumnIndexOrThrow(
                            MediaStore.MediaColumns._ID
                        )
                        val dateModifiedColumn = it.getColumnIndexOrThrow(
                            MediaStore.MediaColumns.DATE_MODIFIED
                        )
                        val mimeTypeColumn = it.getColumnIndexOrThrow(
                            MediaStore.MediaColumns.MIME_TYPE
                        )
                        val dateTakenColumn = it.getColumnIndexOrThrow(
                            MediaStore.MediaColumns.DATE_TAKEN
                        )
                        val displayNameColumn = it.getColumnIndexOrThrow(
                            MediaStore.MediaColumns.DISPLAY_NAME
                        )
                        val relativePathColumn = it.getColumnIndexOrThrow(
                            MediaStore.MediaColumns.RELATIVE_PATH
                        )
                        val widthColumn = it.getColumnIndexOrThrow(
                            MediaStore.MediaColumns.WIDTH
                        )
                        val heightColumn = it.getColumnIndexOrThrow(
                            MediaStore.MediaColumns.HEIGHT
                        )
                        val sizeColumn = it.getColumnIndexOrThrow(
                            MediaStore.MediaColumns.SIZE
                        )
                        do {
                            try {
                                val id = it.getLong(idColumn)
                                val contentUri = ContentUris.withAppendedId(
                                    MediaStore.Files.getContentUri("external"), id
                                )
                                val displayName = it.getString(displayNameColumn)
                                val relativePath = "${
                                    it.getString(relativePathColumn).trimEnd('/')
                                }/$displayName"
                                var width: Int? = null
                                var height: Int? = null
                                if (!it.isNull(widthColumn) && !it.isNull(heightColumn)) {
                                    width = it.getInt(widthColumn)
                                    height = it.getInt(heightColumn)
                                }

                                products.add(
                                    QueryResult(
                                        id = id.toString(),
                                        displayName = it.getString(displayNameColumn),
                                        dateModified = it.getLong(dateModifiedColumn) * 1000,
                                        mimeType = it.getString(mimeTypeColumn),
                                        dateTaken = it.getLongOrNull(dateTakenColumn),
                                        width = width?.toLong(),
                                        height = height?.toLong(),
                                        size = it.getLong(sizeColumn),
                                        androidUri = contentUri.toString(),
                                        androidPath = relativePath,
                                    )
                                )
                            } catch (e: Throwable) {
                                logE(TAG, "Failed to read row", e)
                            }
                        } while (it.moveToNext())
                    }
                    callback(Result.success(products))
                }
            } catch (e: Throwable) {
                callback(Result.failure(FlutterError("systemException", e.message, null)))
            }
        }
    }

    override fun readFile(platformIdentifier: String, callback: (Result<ByteArray>) -> Unit) {
        if (activity == null) {
            callback(Result.failure(IllegalStateException("Context is null")))
            return
        }
        launch(Dispatchers.IO) {
            try {
                val uri = platformIdentifier.toUri()
                val bytes = if (UriUtil.isAssetUri(uri)) {
                    context!!.assets.open(UriUtil.getAssetUriPath(uri)).use {
                        it.readBytes()
                    }
                } else {
                    context!!.contentResolver.openInputStream(uri)!!.use {
                        it.readBytes()
                    }
                }
                callback(Result.success(bytes))
            } catch (e: FileNotFoundException) {
                callback(Result.failure(FlutterError("fileNotFoundException", e.message, null)))
            } catch (e: Throwable) {
                callback(Result.failure(FlutterError("systemException", e.message, null)))
            }
        }
    }

    override fun readThumbnail(
        platformIdentifier: String, width: Long, height: Long, callback: (Result<ByteArray>) -> Unit
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            callback(Result.failure(NotImplementedError("Require Android 10+")))
            return
        }
        if (activity == null) {
            callback(Result.failure(IllegalStateException("Context is null")))
            return
        }
        launch(Dispatchers.IO) {
            try {
                val uri = platformIdentifier.toUri()
                val bitmap = context!!.contentResolver.loadThumbnail(
                    uri, Size(width.toInt(), height.toInt()), null
                )
                val bytes = ByteArrayOutputStream().use {
                    bitmap.compress(Bitmap.CompressFormat.JPEG, 82, it)
                    it.toByteArray()
                }
                callback(Result.success(bytes))
            } catch (e: FileNotFoundException) {
                callback(Result.failure(FlutterError("fileNotFoundException", e.message, null)))
            } catch (e: Throwable) {
                callback(Result.failure(FlutterError("systemException", e.message, null)))
            }
        }
    }

    private fun dirWhitelistToSql(dirWhitelist: List<String>): Pair<String, List<String>> {
        val wheres = mutableListOf<String>()
        val whereArgs = mutableListOf<String>()
        for (w in dirWhitelist) {
            wheres.add("${MediaStore.MediaColumns.RELATIVE_PATH} LIKE ?")
            whereArgs.add("%$w%")
        }
        return Pair("(" + wheres.joinToString(" OR ") + ")", whereArgs)
    }

    private val context: Context?
        get() = activity

    private var activity: Activity? = null
}

class NpPlatformLocalMediaPlugin : FlutterPlugin, ActivityAware {
    override fun onAttachedToEngine(
        flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    ) {
        val api = PigeonApiImpl()
        MyHostApi.setUp(flutterPluginBinding.binaryMessenger, api)
        this.api = api
    }

    override fun onDetachedFromEngine(
        binding: FlutterPlugin.FlutterPluginBinding
    ) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        api?.onAttachedToActivity(binding)
    }

    override fun onReattachedToActivityForConfigChanges(
        binding: ActivityPluginBinding
    ) {
        api?.onReattachedToActivityForConfigChanges(binding)
    }

    override fun onDetachedFromActivity() {
        api?.onDetachedFromActivity()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        api?.onDetachedFromActivityForConfigChanges()
    }

    private var api: PigeonApiImpl? = null
}
