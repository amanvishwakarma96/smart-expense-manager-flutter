package com.smartspend.app

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SMS_QUEUE_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "drainPendingSms" -> result.success(LocalSmsVault(this).drain())
                else -> result.notImplemented()
            }
        }
    }

    private companion object {
        const val SMS_QUEUE_CHANNEL = "com.smartspend.app/sms_queue"
    }
}
