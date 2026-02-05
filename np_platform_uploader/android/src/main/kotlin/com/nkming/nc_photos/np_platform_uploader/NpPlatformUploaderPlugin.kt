package com.nkming.nc_photos.np_platform_uploader

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat
import com.nkming.nc_photos.np_platform_uploader.pigeon.MyFlutterApi
import com.nkming.nc_photos.np_platform_uploader.pigeon.MyHostApi
import com.nkming.nc_photos.np_platform_uploader.pigeon.Uploadable
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.MainScope

private class PigeonApiImpl(private val flutterApiId: Int) : MyHostApi, ActivityAware,
    CoroutineScope by MainScope() {
    companion object {
        private const val TAG = "NpPlatformUploaderPlugin"
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

    override fun asyncUpload(
        taskId: String,
        uploadables: List<Uploadable>,
        httpHeaders: Map<String, String>,
        convertConfig: com.nkming.nc_photos.np_platform_uploader.pigeon.ConvertConfig?,
    ) {
        if (activity == null) {
            throw IllegalStateException("Context is null")
        }
        val contentUris = arrayListOf<String>()
        val endPoints = arrayListOf<String>()
        val canConverts = arrayListOf<Boolean>()
        for (u in uploadables) {
            contentUris.add(u.platformIdentifier)
            endPoints.add(u.endPoint)
            canConverts.add(u.canConvert)
        }
        val intent = Intent(context, UploadService::class.java).apply {
            putExtra(UploadService.EXTRA_TASK_ID, taskId)
            putExtra(UploadService.EXTRA_FLUTTER_API_ID, flutterApiId)
            putExtra(UploadService.EXTRA_CONTENT_URIS, contentUris)
            putExtra(UploadService.EXTRA_END_POINTS, endPoints)
            putExtra(
                UploadService.EXTRA_CAN_CONVERTS, canConverts.toBooleanArray()
            )
            putExtra(UploadService.EXTRA_HEADERS, HashMap(httpHeaders))
            putExtra(UploadService.EXTRA_CONVERT_FORMAT, convertConfig?.format?.toInt())
            putExtra(UploadService.EXTRA_CONVERT_QUALITY, convertConfig?.quality?.toInt())
            putExtra(UploadService.EXTRA_CONVERT_DOWNSIZE_MP, convertConfig?.downsizeMp)
        }
        ContextCompat.startForegroundService(context!!, intent)
    }

    private val context: Context?
        get() = activity

    private var activity: Activity? = null
}

class NpPlatformUploaderPlugin : FlutterPlugin, ActivityAware {
    companion object {
        val flutterApis = mutableMapOf<Int, MyFlutterApi>()
        private var nextFlutterApiId = 0
    }

    override fun onAttachedToEngine(
        flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    ) {
        val flutterApi = MyFlutterApi(flutterPluginBinding.binaryMessenger)
        flutterApiId = synchronized(flutterApis) {
            val id = nextFlutterApiId++
            flutterApis[id] = flutterApi
            id
        }
        val api = PigeonApiImpl(flutterApiId!!)
        MyHostApi.setUp(flutterPluginBinding.binaryMessenger, api)
        this.api = api
    }

    override fun onDetachedFromEngine(
        binding: FlutterPlugin.FlutterPluginBinding
    ) {
        if (flutterApiId != null) {
            flutterApis.remove(flutterApiId)
        }
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
    private var flutterApiId: Int? = null
}
