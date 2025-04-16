package com.example.kalashark

import io.flutter.plugin.common.MethodChannel

object MethodChannelPlugin {
    lateinit var channel: MethodChannel

    fun sendToFlutter(message: String) {
        channel.invokeMethod("onPacket", message)
    }
}
