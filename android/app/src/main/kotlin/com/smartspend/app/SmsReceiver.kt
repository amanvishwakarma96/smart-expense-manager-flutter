package com.smartspend.app

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Telephony
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat

class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return

        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        if (messages.isEmpty()) return

        val sender = messages.firstOrNull()?.originatingAddress.orEmpty()
        val body = messages.joinToString(separator = "") { it.messageBody.orEmpty() }
        val timestamp = messages.firstOrNull()?.timestampMillis ?: System.currentTimeMillis()

        if (!looksLikeTransaction(body)) return

        LocalSmsVault(context).enqueue(sender, body, timestamp)
        showGenericNotification(context)
    }

    private fun looksLikeTransaction(body: String): Boolean {
        val lower = body.lowercase()
        val hasSignal = listOf(
            "debited",
            "credited",
            "spent",
            "paid",
            "received",
            "withdrawn",
            "refund",
        ).any(lower::contains)
        val hasAmount = Regex(
            pattern = """(?i)(?:INR|Rs\.?|₹|USD|\$)\s*[\d,]+(?:\.\d{1,2})?""",
        ).containsMatchIn(body)
        val isSensitiveCode = lower.contains("otp") ||
            lower.contains("one time password") ||
            lower.contains("verification code")
        return hasSignal && hasAmount && !isSensitiveCode
    }

    private fun showGenericNotification(context: Context) {
        if (
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.POST_NOTIFICATIONS,
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }

        val manager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            manager.createNotificationChannel(
                NotificationChannel(
                    CHANNEL_ID,
                    "Transaction review",
                    NotificationManager.IMPORTANCE_DEFAULT,
                ).apply {
                    description = "Private alerts for locally detected transactions"
                },
            )
        }

        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(context.applicationInfo.icon)
            .setContentTitle("Transaction ready to review")
            .setContentText("Open PiggyAI to confirm or edit it.")
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .build()

        manager.notify(NOTIFICATION_ID, notification)
    }

    private companion object {
        const val CHANNEL_ID = "piggyai_pending_transactions"
        const val NOTIFICATION_ID = 1201
    }
}
