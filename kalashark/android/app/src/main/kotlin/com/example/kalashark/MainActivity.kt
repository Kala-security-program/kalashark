package com.example.kalashark

import android.app.Activity
import android.content.Intent
import android.net.VpnService
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "kalashark"
    private val VPN_REQUEST_CODE = 1000
    private var pendingArgs: Map<String, String>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startVpn" -> {
                    val args = call.arguments as? Map<String, String> ?: emptyMap()
                    pendingArgs = args

                    val intent = VpnService.prepare(this)
                    if (intent != null) {
                        startActivityForResult(intent, VPN_REQUEST_CODE)
                    } else {
                        startVpnService(args)
                    }
                    result.success(null)
                }

                "stopVpn" -> {
                    stopService(Intent(this, KalaVpnService::class.java))

                    // 👇 Open VPN Settings UI so user can disconnect manually
                    val vpnIntent = Intent("android.net.vpn.SETTINGS")
                    vpnIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    startActivity(vpnIntent)

                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }

        // Channel for sending packets from Kotlin → Flutter
        MethodChannelPlugin.channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == VPN_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            startVpnService(pendingArgs ?: emptyMap())
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    private fun startVpnService(args: Map<String, String>) {
        val intent = Intent(this, KalaVpnService::class.java)
        intent.putExtra("ipv4", args["ipv4"] ?: "10.0.0.2")
        intent.putExtra("ipv6", args["ipv6"] ?: "")
        startService(intent)
    }
}
