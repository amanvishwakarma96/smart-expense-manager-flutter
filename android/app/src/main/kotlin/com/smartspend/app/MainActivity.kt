package com.smartspend.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private var smsQueueChannel: MethodChannel? = null
    private var smsQueuedReceiverRegistered = false

    private val smsQueuedReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == SMS_QUEUED_ACTION) {
                smsQueueChannel?.invokeMethod("smsQueued", null)
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        smsQueueChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SMS_QUEUE_CHANNEL,
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "drainPendingSms" -> result.success(LocalSmsVault(this).drain())
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun onStart() {
        super.onStart()
        if (!smsQueuedReceiverRegistered) {
            val filter = IntentFilter(SMS_QUEUED_ACTION)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                registerReceiver(
                    smsQueuedReceiver,
                    filter,
                    Context.RECEIVER_NOT_EXPORTED,
                )
            } else {
                @Suppress("DEPRECATION")
                registerReceiver(smsQueuedReceiver, filter)
            }
            smsQueuedReceiverRegistered = true
        }
    }

    override fun onStop() {
        if (smsQueuedReceiverRegistered) {
            unregisterReceiver(smsQueuedReceiver)
            smsQueuedReceiverRegistered = false
        }
        super.onStop()
    }

    override fun onDestroy() {
        smsQueueChannel = null
        super.onDestroy()
    }

    private companion object {
        const val SMS_QUEUE_CHANNEL = "com.smartspend.app/sms_queue"
        const val SMS_QUEUED_ACTION = "com.smartspend.app.SMS_QUEUED"
    }
}
