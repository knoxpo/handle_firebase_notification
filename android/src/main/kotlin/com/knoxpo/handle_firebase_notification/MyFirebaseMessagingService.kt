package com.knoxpo.handle_firebase_notification

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.google.firebase.iid.FirebaseInstanceId
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {

    override fun onCreate() {
        super.onCreate()
        FirebaseInstanceId.getInstance()
                .instanceId
                .addOnSuccessListener {

                    Log.e("Token : ","${it.token}")
                }
    }


    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        Log.e("Firebase Message", "Firebase Message")
        val intent=Intent(HandleFirebaseNotificationPlugin.ACTION_RESUME)
        intent.putExtra(HandleFirebaseNotificationPlugin.EXTRA_MESSAGE,remoteMessage)
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent)
    }
}
