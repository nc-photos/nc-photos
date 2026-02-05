package com.nkming.nc_photos.np_platform_uploader

import android.annotation.SuppressLint
import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
import android.net.Uri
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import androidx.core.app.NotificationChannelCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.ServiceCompat
import com.nkming.nc_photos.np_android_core.getDoubleOrNull
import com.nkming.nc_photos.np_android_core.getIntOrNull
import com.nkming.nc_photos.np_android_core.getPendingIntentFlagImmutable
import com.nkming.nc_photos.np_android_core.logE
import com.nkming.nc_photos.np_android_core.logI
import com.nkming.nc_photos.np_android_core.use
import com.nkming.nc_photos.np_platform_uploader.pigeon.Uploadable
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch
import java.io.File
import java.net.HttpURLConnection
import java.net.URL
import java.util.LinkedList
import java.util.Queue

internal class UploadService : Service(), CoroutineScope by MainScope() {
    companion object {
        private const val CHANNEL_ID = "UploadService"
        private const val ACTION_CANCEL = "cancel"
        const val EXTRA_TASK_ID = "taskId"
        const val EXTRA_FLUTTER_API_ID = "flutterApiId"
        const val EXTRA_CONTENT_URIS = "contentUris"
        const val EXTRA_END_POINTS = "endPoints"
        const val EXTRA_CAN_CONVERTS = "canConverts"
        const val EXTRA_HEADERS = "headers"

        /**
         * Setting EXTRA_CONVERT_FORMAT will make the uploader service to
         * compress your images before uploading
         */
        const val EXTRA_CONVERT_FORMAT = "convertFormat"
        const val EXTRA_CONVERT_QUALITY = "convertQuality"
        const val EXTRA_CONVERT_DOWNSIZE_MP = "convertDownsizeMp"

        private const val TAG = "UploadService"

        private val workQueue: Queue<UploadJob> = LinkedList()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    @SuppressLint("WakelockTimeout")
    override fun onCreate() {
        logI(TAG, "[onCreate] Service created")
        super.onCreate()
        wakeLock.acquire()
        createNotificationChannel()
        cleanUp()
    }

    override fun onDestroy() {
        logI(TAG, "[onDestroy] Service destroyed")
        wakeLock.release()
        super.onDestroy()
    }

    override fun onStartCommand(
        intent: Intent?, flags: Int, startId: Int
    ): Int {
        if (intent == null) {
            // service previously killed by system
            if (notificationManager.areNotificationsEnabled()) {
                notificationManager.notify(
                    K.KILLED_NOTIFICATION_ID, buildKilledNotification()
                )
            }
            synchronized(workQueue) {
                if (workQueue.isEmpty()) {
                    stopSelf()
                }
            }
            return START_STICKY
        }
        if (!isForeground) {
            try {
                ServiceCompat.startForeground(
                    this, K.FG_SERVICE_NOTIFICATION_ID, buildNotification(),
                    FOREGROUND_SERVICE_TYPE_DATA_SYNC
                )
                isForeground = true
            } catch (e: Throwable) {
                // ???
                logE(TAG, "[onStartCommand] Failed while startForeground", e)
            }
        }
        doWork(intent)
        return START_STICKY
    }

    private fun doWork(intent: Intent) {
        if (intent.action == ACTION_CANCEL) {
            if (notificationManager.areNotificationsEnabled()) {
                notificationManager.notify(
                    K.FG_SERVICE_NOTIFICATION_ID, buildCanceledNotification()
                )
            }
            shouldCancel = true
        } else {
            val taskId = intent.extras!!.getString(EXTRA_TASK_ID)!!
            val flutterApiId = intent.extras!!.getInt(EXTRA_FLUTTER_API_ID)
            val contentUris = intent.extras!!.getStringArrayList(EXTRA_CONTENT_URIS)!!
            val endPoints = intent.extras!!.getStringArrayList(EXTRA_END_POINTS)!!
            val canConverts = intent.extras!!.getBooleanArray(EXTRA_CAN_CONVERTS)!!.toList()
            assert(contentUris.size == endPoints.size)
            val headers = intent.extras!!.getSerializable(
                EXTRA_HEADERS
            ) as HashMap<String, String>
            val convertFormat = intent.extras!!.getIntOrNull(
                EXTRA_CONVERT_FORMAT
            )
            val convertQuality = intent.extras!!.getIntOrNull(
                EXTRA_CONVERT_QUALITY
            )
            val convertDownsizeMp = intent.extras!!.getDoubleOrNull(
                EXTRA_CONVERT_DOWNSIZE_MP
            )
            synchronized(workQueue) {
                var convertConfig: ConvertConfig? = null
                if (convertFormat != null) {
                    try {
                        convertConfig = ConvertConfig(
                            FormatConverter.Format.values()[convertFormat], convertQuality!!,
                            convertDownsizeMp
                        )
                    } catch (e: Throwable) {
                        logE(TAG, "[doWork] Invalid convert config", e)
                    }
                }
                workQueue.add(
                    UploadJob(
                        taskId, flutterApiId, contentUris, endPoints, canConverts, headers,
                        convertConfig
                    )
                )
                if (workQueue.size == 1) {
                    startJobRunner()
                }
            }
        }
    }

    private fun startJobRunner() {
        logI(TAG, "[startJobRunner] Begin")
        launch(Dispatchers.IO) {
            var okCount = 0
            var failureCount = 0
            while (workQueue.isNotEmpty() && !shouldCancel) {
                val job = workQueue.peek()
                if (job != null) {
                    val count = workOnce(job)
                    okCount += count
                    failureCount += job.contentUris.size - count
                }
                synchronized(workQueue) {
                    workQueue.remove()
                }
            }
            if (shouldCancel) {
                if (okCount > 0) {
                    if (notificationManager.areNotificationsEnabled()) {
                        notificationManager.notify(
                            K.RESULT_NOTIFICATION_ID, buildResultCanceledNotification(okCount)
                        )
                    }
                }
            } else {
                logI(
                    TAG, "[startJobRunner] All job finished, terminating service"
                )
                if (notificationManager.areNotificationsEnabled()) {
                    if (failureCount == 0) {
                        notificationManager.notify(
                            K.RESULT_NOTIFICATION_ID, buildResultSuccessfulNotification(okCount)
                        )
                    } else {
                        notificationManager.notify(
                            K.RESULT_NOTIFICATION_ID, buildResultPartialNotification(
                                okCount, failureCount
                            )
                        )
                    }
                }
            }
            notificationManager.cancel(K.FG_SERVICE_NOTIFICATION_ID)
            stopSelf()
        }
    }

    private fun workOnce(job: UploadJob): Int {
        var count = 0
        val converter = job.convertConfig?.let { FormatConverter(contentResolver) }
        for (i in job.contentUris.indices) {
            if (shouldCancel) {
                logI(TAG, "[workOnce] Canceled")
                return count
            }
            val uri = job.contentUris[i]
            val endPoint = job.endPoints[i]
            val canConvert = job.canConverts[i]
            val basename = endPoint.substringAfterLast("/")
            logI(TAG, "[workOnce] Uploading $basename")
            if (notificationManager.areNotificationsEnabled()) {
                notificationManager.notify(
                    K.FG_SERVICE_NOTIFICATION_ID, buildNotification(content = basename)
                )
            }
            var converted: File? = null
            try {
                if (converter != null && canConvert) {
                    logI(
                        TAG,
                        "[workOnce] Converting to $basename (${job.convertConfig.quality} | ${job.convertConfig.downsizeMp})"
                    )
                    converted = converter.convert(
                        Uri.parse(uri)!!, getTempDir(this), job.convertConfig.format,
                        job.convertConfig.quality, job.convertConfig.downsizeMp
                    )
                    if (converted == null) {
                        handler.post {
                            NpPlatformUploaderPlugin.flutterApis[job.flutterApiId]?.notifyUploadResult(
                                job.taskId, Uploadable(uri, endPoint, canConvert), false
                            ) {}
                        }
                        continue
                    }
                }
                (URL(endPoint).openConnection() as HttpURLConnection).apply {
                    requestMethod = "PUT"
                    instanceFollowRedirects = true
                    connectTimeout = 8000
                    for (e in job.headers.entries) {
                        setRequestProperty(e.key, e.value)
                    }
                    doOutput = true
                }.use { conn ->
                    (converted?.inputStream() ?: contentResolver.openInputStream(
                        Uri.parse(uri)
                    )!!).use { iStream ->
                        conn.outputStream.use { oStream ->
                            iStream.copyTo(oStream)
                        }
                    }
                    val responseCode = conn.responseCode
                    if (responseCode / 100 != 2) {
                        logE(
                            TAG, "[workOnce] Failed uploading file: HTTP$responseCode"
                        )
                        throw HttpException(
                            responseCode, "Failed uploading file (HTTP$responseCode)"
                        )
                    }
                    handler.post {
                        NpPlatformUploaderPlugin.flutterApis[job.flutterApiId]?.notifyUploadResult(
                            job.taskId, Uploadable(uri, endPoint, canConvert), true
                        ) {}
                    }
                    count += 1
                }
            } catch (e: Throwable) {
                logE(TAG, "[workOnce] Exception", e)
                handler.post {
                    NpPlatformUploaderPlugin.flutterApis[job.flutterApiId]?.notifyUploadResult(
                        job.taskId, Uploadable(uri, endPoint, canConvert), false
                    ) {}
                }
            } finally {
                converted?.delete()
            }
        }
        handler.post {
            NpPlatformUploaderPlugin.flutterApis[job.flutterApiId]?.notifyTaskComplete(
                job.taskId
            ) {}
        }
        return count
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannelCompat.Builder(
            CHANNEL_ID, NotificationManagerCompat.IMPORTANCE_LOW
        ).run {
            setName("Upload")
            setDescription("Upload files to your server in the background")
            build()
        }
        notificationManager.createNotificationChannel(channel)
    }

    private fun buildNotification(content: String? = null): Notification {
        val cancelIntent = Intent(this, UploadService::class.java).apply {
            action = ACTION_CANCEL
        }
        val cancelPendingIntent = PendingIntent.getService(
            this, 0, cancelIntent, getPendingIntentFlagImmutable()
        )
        return NotificationCompat.Builder(this, CHANNEL_ID).run {
            setSmallIcon(android.R.drawable.stat_sys_upload)
            setContentTitle("Uploading file")
            if (content != null) setContentText(content)
            addAction(
                0, getString(android.R.string.cancel), cancelPendingIntent
            )
            build()
        }
    }

    private fun buildKilledNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID).run {
            setSmallIcon(android.R.drawable.stat_notify_error)
            setContentTitle("File upload interrupted")
            setContentText("The service was terminated by the system")
            build()
        }
    }

    private fun buildCanceledNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID).run {
            setSmallIcon(android.R.drawable.stat_sys_upload)
            setContentTitle("Canceling upload")
            build()
        }
    }

    private fun buildResultSuccessfulNotification(count: Int): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID).run {
            setSmallIcon(android.R.drawable.stat_sys_upload_done)
            if (count == 1) {
                setContentTitle("Uploaded file successfully")
            } else {
                setContentTitle("Uploaded $count files successfully")
            }
            build()
        }
    }

    private fun buildResultPartialNotification(
        okCount: Int, failureCount: Int
    ): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID).run {
            setSmallIcon(android.R.drawable.stat_sys_upload_done)
            if (okCount == 0 && failureCount == 1) {
                setContentTitle("Failed to upload file")
            } else {
                setContentTitle(
                    "Uploaded $okCount out of ${okCount + failureCount} files successfully"
                )
            }
            build()
        }
    }

    private fun buildResultCanceledNotification(count: Int): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID).run {
            setSmallIcon(android.R.drawable.stat_sys_upload_done)
            if (count == 1) {
                setContentTitle(
                    "Uploaded 1 file successfully before canceled by user"
                )
            } else {
                setContentTitle(
                    "Uploaded $count files successfully before canceled by user"
                )
            }
            build()
        }
    }

    /**
     * Clean up temp files in case the service ended prematurely last time
     */
    private fun cleanUp() {
        try {
            getTempDir(this).deleteRecursively()
        } catch (e: Throwable) {
            logE(TAG, "[cleanUp] Failed while cleanUp", e)
        }
    }

    private var isForeground = false
    private var shouldCancel = false

    private val notificationManager by lazy {
        NotificationManagerCompat.from(this)
    }
    private val wakeLock: PowerManager.WakeLock by lazy {
        (getSystemService(POWER_SERVICE) as PowerManager).newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK, "nc-photos:UploadService"
        ).apply {
            setReferenceCounted(false)
        }
    }

    private val handler by lazy { Handler(Looper.getMainLooper()) }
}

private data class ConvertConfig(
    val format: FormatConverter.Format,
    val quality: Int,
    val downsizeMp: Double?,
)

private data class UploadJob(
    val taskId: String,
    val flutterApiId: Int,
    val contentUris: List<String>,
    val endPoints: List<String>,
    val canConverts: List<Boolean>,
    val headers: Map<String, String>,
    val convertConfig: ConvertConfig?,
)

private fun getTempDir(context: Context): File {
    val f = File(context.cacheDir, "uploader")
    if (!f.exists()) {
        f.mkdirs()
    } else if (!f.isDirectory) {
        f.delete()
        f.mkdirs()
    }
    return f
}
