package com.knoxpo.handle_firebase_notification

import android.content.Intent
import android.util.Log
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.google.firebase.iid.FirebaseInstanceId
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

private val TAG = MyFirebaseMessagingService::class.java.simpleName

class MyFirebaseMessagingService : FirebaseMessagingService() {

    override fun onCreate() {
        super.onCreate()
        FirebaseInstanceId.getInstance()
                .instanceId
                .addOnSuccessListener {

                    Log.e("Token : ", "${it.token}")
                }
    }

    override fun onNewToken(token: String) {
        Log.e(TAG, "New Token : $token")
        val intent = Intent(HandleFirebaseNotificationPlugin.ACTION_TOKEN)
        intent.putExtra(HandleFirebaseNotificationPlugin.EXTRA_TOKEN, token)
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent)
    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        Log.e("Firebase Message", "Firebase Message")
        val intent = Intent(HandleFirebaseNotificationPlugin.ACTION_MESSAGE)
        intent.putExtra(HandleFirebaseNotificationPlugin.EXTRA_MESSAGE, remoteMessage)
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent)
    }
}
