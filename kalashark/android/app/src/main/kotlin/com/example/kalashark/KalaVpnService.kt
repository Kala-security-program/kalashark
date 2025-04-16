package com.example.kalashark

import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor
import android.util.Log
import android.content.Intent
import java.io.FileInputStream
import java.io.IOException
import java.util.concurrent.Executors
import android.os.Handler
import android.os.Looper

class KalaVpnService : VpnService() {
    private var vpnInterface: ParcelFileDescriptor? = null
    private val executor = Executors.newSingleThreadExecutor()

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val ipv4 = intent?.getStringExtra("ipv4") ?: "10.0.0.2"
        val ipv6 = intent?.getStringExtra("ipv6") ?: ""

        executor.execute {
            try {
                val builder = Builder()
                builder.setSession("KalaShark")
                builder.setMtu(1500)
                builder.addAddress(ipv4, 32)
                builder.addRoute("0.0.0.0", 0)

                if (ipv6.isNotEmpty()) {
                    builder.addAddress(ipv6, 128)
                    builder.addRoute("::", 0)
                }

                builder.addDnsServer("8.8.8.8")

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    builder.allowBypass()
                    builder.addDisallowedApplication(packageName)
                }

                vpnInterface = builder.establish()

                val input = FileInputStream(vpnInterface!!.fileDescriptor)
                val buffer = ByteArray(32767)

                while (!Thread.currentThread().isInterrupted) {
                    val len = input.read(buffer)
                    if (len > 0) {
                        val data = buffer.copyOf(len)
                        val hex = data.toHex()
                        val json = "{\"raw\":\"$hex\"}"

                        Handler(Looper.getMainLooper()).post {
                            MethodChannelPlugin.sendToFlutter(json)
                        }
                    }
                }

                input.close()
            } catch (e: IOException) {
                Log.e("KalaVPN", "Read stopped: ${e.message}")
            } catch (e: Exception) {
                Log.e("KalaVPN", "Fatal VPN error: ${e.message}", e)
            }
        }

        return START_STICKY
    }

    override fun onDestroy() {
        vpnInterface?.close()
        vpnInterface = null
        executor.shutdownNow()
        super.onDestroy()
    }

    private fun ByteArray.toHex(): String {
        return joinToString("") { "%02x".format(it) }
    }
}
