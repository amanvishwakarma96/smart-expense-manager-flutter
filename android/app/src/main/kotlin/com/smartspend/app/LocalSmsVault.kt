package com.smartspend.app

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import org.json.JSONArray
import org.json.JSONObject
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

internal class LocalSmsVault(context: Context) {
    private val preferences =
        context.getSharedPreferences("piggyai_sms_vault", Context.MODE_PRIVATE)

    fun enqueue(sender: String, body: String, timestamp: Long) {
        val clearJson = JSONObject()
            .put("sender", sender)
            .put("body", body)
            .put("timestamp", timestamp)
            .toString()

        val existing = JSONArray(preferences.getString(QUEUE_KEY, "[]"))
        existing.put(encrypt(clearJson))
        preferences.edit().putString(QUEUE_KEY, existing.toString()).apply()
    }

    fun drain(): List<Map<String, Any>> {
        val encryptedItems = JSONArray(preferences.getString(QUEUE_KEY, "[]"))
        val output = mutableListOf<Map<String, Any>>()

        for (index in 0 until encryptedItems.length()) {
            val payload = encryptedItems.optString(index)
            if (payload.isBlank()) continue

            runCatching {
                val item = JSONObject(decrypt(payload))
                output.add(
                    mapOf(
                        "sender" to item.optString("sender"),
                        "body" to item.optString("body"),
                        "timestamp" to item.optLong("timestamp"),
                    ),
                )
            }
        }

        preferences.edit().remove(QUEUE_KEY).apply()
        return output
    }

    private fun encrypt(value: String): String {
        val cipher = Cipher.getInstance(TRANSFORMATION)
        cipher.init(Cipher.ENCRYPT_MODE, getOrCreateKey())
        val encrypted = cipher.doFinal(value.toByteArray(Charsets.UTF_8))
        val payload = cipher.iv + encrypted
        return Base64.encodeToString(payload, Base64.NO_WRAP)
    }

    private fun decrypt(value: String): String {
        val payload = Base64.decode(value, Base64.NO_WRAP)
        require(payload.size > IV_LENGTH)
        val iv = payload.copyOfRange(0, IV_LENGTH)
        val encrypted = payload.copyOfRange(IV_LENGTH, payload.size)
        val cipher = Cipher.getInstance(TRANSFORMATION)
        cipher.init(
            Cipher.DECRYPT_MODE,
            getOrCreateKey(),
            GCMParameterSpec(128, iv),
        )
        return String(cipher.doFinal(encrypted), Charsets.UTF_8)
    }

    private fun getOrCreateKey(): SecretKey {
        val keyStore = KeyStore.getInstance(ANDROID_KEYSTORE).apply { load(null) }
        (keyStore.getKey(KEY_ALIAS, null) as? SecretKey)?.let { return it }

        val generator =
            KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, ANDROID_KEYSTORE)
        generator.init(
            KeyGenParameterSpec.Builder(
                KEY_ALIAS,
                KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
            )
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(256)
                .build(),
        )
        return generator.generateKey()
    }

    private companion object {
        const val QUEUE_KEY = "encrypted_pending_sms"
        const val KEY_ALIAS = "piggyai_sms_queue_key"
        const val ANDROID_KEYSTORE = "AndroidKeyStore"
        const val TRANSFORMATION = "AES/GCM/NoPadding"
        const val IV_LENGTH = 12
    }
}
