// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/hex_viewer.dart';

class PacketDetailsScreen extends StatelessWidget {
  final Map<String, String> packet;

  const PacketDetailsScreen({super.key, required this.packet});

  @override
  Widget build(BuildContext context) {
    final rawHex = packet["raw"] ?? "";
    print("🧪 rawHex: $rawHex");

    final ascii = _hexToAscii(rawHex);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: Text('Packet Details', style: GoogleFonts.orbitron()),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("📦 Packet Information", Colors.cyanAccent),
            _infoRow("🕒 Time", packet["time"] ?? "-"),
            _infoRow("🔗 Protocol", packet["proto"] ?? "-"),
            _infoRow("📤 Source", packet["src"] ?? "-"),
            _infoRow("📥 Destination", packet["dst"] ?? "-"),
            _infoRow("📦 Size", "${packet["length"] ?? "N/A"} bytes"),

            const SizedBox(height: 18),
            _sectionTitle("🔍 Raw Payload", Colors.greenAccent),

            SelectableText(
              packet["info"] ?? "No payload",
              style: GoogleFonts.shareTechMono(color: Colors.white70),
            ),

            const SizedBox(height: 18),
            _sectionTitle("🔢 Hex View", Colors.deepPurpleAccent),
            HexViewer(hexData: rawHex),

            const SizedBox(height: 18),
            _sectionTitle("🔤 ASCII View", Colors.amberAccent),
            SelectableText(
              ascii,
              style: GoogleFonts.sourceCodePro(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),
            _sectionTitle("📊 Protocol Analysis", Colors.orangeAccent),
            _advancedAnalysis(packet),
          ],
        ),
      ),
    );
  }

  /// 🔤 Converts raw hex to printable ASCII
  String _hexToAscii(String hex) {
    final buffer = StringBuffer();
    for (int i = 0; i < hex.length - 1; i += 2) {
      try {
        final byte = int.parse(hex.substring(i, i + 2), radix: 16);
        final char =
            byte >= 32 && byte <= 126 ? String.fromCharCode(byte) : '.';
        buffer.write(char);
      } catch (_) {
        buffer.write('.');
      }
    }
    return buffer.toString();
  }

  /// 🧾 Label & Value display
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: GoogleFonts.shareTechMono(color: Colors.lightBlueAccent),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.shareTechMono(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// 🖋 Section title style
  Widget _sectionTitle(String title, Color color) {
    return Text(
      title,
      style: GoogleFonts.orbitron(
        fontSize: 18,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// 🧠 Advanced protocol-specific analysis
  Widget _advancedAnalysis(Map<String, String> packet) {
    final proto = packet["proto"]?.toUpperCase();
    switch (proto) {
      case "TCP":
        return _infoBlock(
          "🧠 TCP Packet",
          "Likely part of a connection (SYN/ACK)\nCheck flags, ports, and sequence numbers.",
        );
      case "UDP":
        return _infoBlock(
          "📡 UDP Packet",
          "Connectionless protocol.\nOften used in DNS, VoIP, or LAN discovery.",
        );
      case "ICMP":
        return _infoBlock(
          "🛡 ICMP Packet",
          "Used in ping or traceroute tools.\nCheck type/code values for context.",
        );
      case "IPV6":
        return _infoBlock(
          "🌐 IPv6 Packet",
          "Modern network addressing.\nMay include extension headers.",
        );
      default:
        return const Text(
          "🔎 No specific protocol analysis available",
          style: TextStyle(color: Colors.white54),
        );
    }
  }

  Widget _infoBlock(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: GoogleFonts.sourceCodePro(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}
