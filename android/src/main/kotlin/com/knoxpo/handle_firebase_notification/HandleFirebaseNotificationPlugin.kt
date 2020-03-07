package com.knoxpo.handle_firebase_notification

import android.app.Activity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.*
import android.graphics.Color
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.google.firebase.messaging.RemoteMessage
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** HandleFirebaseNotificationPlugin */
class HandleFirebaseNotificationPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, BroadcastReceiver() {


    private var context: Context? = null
    private var activity: Activity? = null


    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    var eventChannelSink: EventChannel.EventSink? = null

    companion object {

        private val TAG = HandleFirebaseNotificationPlugin::class.java.simpleName
        private const val METHOD_OPEN_SCREEN = "openScreen"
        private const val METHOD_CHANNEL = "handle_notification_method"
        private const val EVENT_CHANNEL = "handle_notification_event"
        private var ACTION_NOTIFICATION = "ACTION_NOTIFICATION"
        const val ACTION_RESUME = "ACTION_RESUME"
        const val EXTRA_MESSAGE = "EXTRA_MESSAGE"
        private const val KEY_GOOGLE_MESSAGE="google.message_id"
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        flutterPluginBinding.applicationContext.let {
            this.context = it
        }

        val manager = LocalBroadcastManager.getInstance(context!!)
        manager.registerReceiver(
                this,
                IntentFilter().apply {
                    addAction(ACTION_RESUME)
                }
        )

        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL)
        eventChannel?.setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, event: EventChannel.EventSink?) {
                        Log.d(TAG, "on Listen")
                        eventChannelSink = event

                        val isFromHistory = (activity!!.intent!!.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY) != 0

                        val receivedIntent = activity?.intent

                        receivedIntent?.let { intent ->
                            if(intent.hasExtra(KEY_GOOGLE_MESSAGE) && !isFromHistory){
                                sendData(intent)
                            }
                        }
                    }

                    override fun onCancel(arguments: Any?) {
                        Log.e(TAG, "onCancel")
                    }
                }
        )
        methodChannel?.setMethodCallHandler(this)

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        LocalBroadcastManager.getInstance(binding.applicationContext).unregisterReceiver(this);
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {

//            "notification" -> {
//                showNotification("Pratik", "abcgmail", "Hello")
//            }
            METHOD_OPEN_SCREEN -> {
                val isFromHistory = (activity!!.intent!!.flags and Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY) != 0

                if (this.activity?.intent?.action == ACTION_NOTIFICATION && !isFromHistory) {
                    result.success(true)
                } else {
                    result.success(false)
                }
            }
//            "action" -> {
//                val action = call.argument<String>("action")
//                Log.e(TAG, "$action")
//                action?.let {
//                    ACTION_NOTIFICATION = it
//                }
//            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun showNotification(name: String, email: String, message: String) {
        val notificationManager = context?.getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val mChannel =
                    NotificationChannel("CHANNEL_ID", name, NotificationManager.IMPORTANCE_DEFAULT)
            notificationManager?.createNotificationChannel(mChannel)
        }

        val builder = NotificationCompat.Builder(context)
                .setContentTitle(name)
                .setContentInfo(email)
                .setTicker(name)
                .setContentText(message)
                .setStyle(NotificationCompat.MessagingStyle(name))
                .setSmallIcon(android.R.drawable.star_big_on)
                .setAutoCancel(true)
                .setColor(Color.BLUE)
                .setContentIntent(setPendingIntent())

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            builder.setChannelId("CHANNEL_ID") // Channel ID
        }
        notificationManager?.notify(0, builder.build())
    }

    private fun setPendingIntent(): PendingIntent {
        val intent = Intent(context, getActivityClass(context!!))
        intent.action = ACTION_NOTIFICATION

        intent.putExtra("name", "Pratik")
        intent.putExtra("email", "Pratik.sherdiwala@gmail.com")
        intent.putExtra("message", "Hello flutter.. I m calling from native..")

        return PendingIntent
                .getActivity(
                        context,
                        0,
                        intent,
                        PendingIntent.FLAG_UPDATE_CURRENT
                )
    }

    private fun getActivityClass(context: Context): Class<*> {
        val packageName = context.packageName
        val launchIntent = context.packageManager.getLaunchIntentForPackage(packageName)
        val className = launchIntent?.component?.className
        return try {
            Class.forName(className!!)
        } catch (e: Exception) {
            e.printStackTrace()
            throw e
        }
    }


    override fun onDetachedFromActivity() {
        Log.e(TAG, "onDetachedFromActivity")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Log.e(TAG, "onReattachedToActivityForConfigChanges")
    }

    override fun onAttachedToActivity(activityBinding: ActivityPluginBinding) {
        this.activity = activityBinding.activity

        activityBinding.lifecycle

        Log.e(TAG, "OnAttachToEngine${activity?.intent?.extras?.get("name")}")
        Log.e(TAG, "OnAttachToEngine${activity?.intent?.action}")

        activityBinding.addOnNewIntentListener {
            Log.e(TAG, "IntentListener :${it.extras?.get("name")}")

            Log.e(TAG, "${it.action}")
            try {
                if (it.hasExtra(KEY_GOOGLE_MESSAGE)) {
                    sendData(it)
                } else {
                    eventChannelSink?.success("No result to be set")
                }
            } catch (e: java.lang.Exception) {
                Log.e(TAG, "Error ", e)
            }
            true
        }
    }


    private fun sendData(intent: Intent) {
        val dataMap = getDataMap(intent)
        Log.e(TAG, "$dataMap")
        try {
            eventChannelSink?.success(dataMap)
        } catch (e: java.lang.Exception) {
            Log.e(TAG, "Error while sending data: ${e.printStackTrace()}")
        }
    }

    private fun getDataMap(intent: Intent): Map<String, Any> {

        val dataMap = mutableMapOf<String, Any>()

        intent.extras!!.keySet().map { key ->
            dataMap[key] = intent.extras?.get(key) as Any
        }
        return dataMap
    }


    override fun onDetachedFromActivityForConfigChanges() {
        Log.e(ContentValues.TAG, "onDetachedFromActivityForConfigChanges")
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == ACTION_RESUME) {
            val data = intent.getParcelableExtra<RemoteMessage>(EXTRA_MESSAGE)
            Log.e(ContentValues.TAG, "${data}")
            eventChannelSink?.success(data.data)
        }
    }
}
