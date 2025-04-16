import 'dart:convert';
import 'dart:typed_data';

Map<String, String> parseIpPacket(String hex) {
  if (hex.length < 40) return {}; // Not enough for IPv4 header

  final version = int.tryParse(hex.substring(0, 1), radix: 16);
  if (version == 6) return {}; // Skip IPv6 for now

  try {
    final totalLength = int.parse(hex.substring(4, 8), radix: 16);

    final protocolCode = int.parse(hex.substring(18, 20), radix: 16);
    final protoName = {1: 'ICMP', 6: 'TCP', 17: 'UDP'}[protocolCode] ?? 'Other';

    final srcIp = List.generate(4, (i) {
      final start = 26 + i * 2;
      return int.parse(hex.substring(start, start + 2), radix: 16);
    }).join(".");

    final dstIp = List.generate(4, (i) {
      final start = 34 + i * 2;
      return int.parse(hex.substring(start, start + 2), radix: 16);
    }).join(".");

    String ports = "";
    if (protoName == "TCP" || protoName == "UDP") {
      final srcPort = int.parse(hex.substring(40, 44), radix: 16);
      final dstPort = int.parse(hex.substring(44, 48), radix: 16);
      ports = "$srcPort → $dstPort";
    }

    String tcpFlags = "";
    if (protoName == "TCP" && hex.length >= 54) {
      final flagsByte = int.parse(hex.substring(52, 54), radix: 16);
      final flagNames = ["FIN", "SYN", "RST", "PSH", "ACK", "URG"];
      for (int i = 0; i < flagNames.length; i++) {
        if ((flagsByte & (1 << i)) != 0) {
          tcpFlags += "${flagNames[i]} ";
        }
      }
      tcpFlags = tcpFlags.trim();
    }

    final payloadStart = 40 + (protoName == "TCP" ? 40 : 8);
    final payloadHex =
        hex.length > payloadStart
            ? hex.substring(
              payloadStart,
              payloadStart + 32.clamp(0, hex.length - payloadStart),
            )
            : "";
    final preview = payloadHex.replaceAllMapped(RegExp(r'.{2}'), (match) {
      final byte = int.parse(match.group(0)!, radix: 16);
      return (byte >= 32 && byte <= 126) ? String.fromCharCode(byte) : '.';
    });

    return {
      "src": srcIp,
      "dst": dstIp,
      "proto": protoName,
      "ports": ports,
      "flags": tcpFlags,
      "length": "$totalLength",
      "info": preview,
      "time": DateTime.now().toIso8601String(),
      "raw": hex, // ✅ required for HexViewer to work
    };
  } catch (e) {
    print("❌ Error parsing packet: $e");
    return {};
  }
}
