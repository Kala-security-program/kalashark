// lib/services/vpn_channel.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../screens/packet_parser.dart';

class VpnChannel {
  static const MethodChannel _channel = MethodChannel('kalashark');

  static void listen(void Function(Map<String, String>) onPacket) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onPacket') {
        try {
          final rawJson = call.arguments as String;
          final hex = extractRawHex(rawJson);
          final parsed = parseIpPacket(hex); // ✅ parsed Map<String, String>
          if (parsed.isNotEmpty) {
            onPacket(parsed); // 🔥 Sends correct type
          }
        } catch (e) {
          print("❌ Packet parsing error: $e");
        }
      }
    });
  }

  static Future<void> startVpn({required String ipv4, String? ipv6}) async {
    await _channel.invokeMethod('startVpn', {'ipv4': ipv4, 'ipv6': ipv6 ?? ''});
  }

  static Future<void> stopVpn() async {
    await _channel.invokeMethod('stopVpn');
  }

  static String extractRawHex(String json) {
    final match = RegExp(r'"raw":"([^"]+)"').firstMatch(json);
    return match?.group(1) ?? "";
  }
}
