import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import '../services/vpn_channel.dart';
import 'chart_screen.dart';
import 'about_screen.dart';
import 'packet_details_screen.dart';

class KalaSharkScreen extends StatefulWidget {
  const KalaSharkScreen({super.key});

  @override
  State<KalaSharkScreen> createState() => _KalaSharkScreenState();
}

class _KalaSharkScreenState extends State<KalaSharkScreen> {
  bool isRunning = false;
  final List<Map<String, String>> packets = [];
  String filter = "";
  final TextEditingController _ipController = TextEditingController(
    text: "10.0.0.2",
  );

  @override
  void initState() {
    super.initState();
    VpnChannel.listen((packet) {
      setState(() {
        packets.insert(0, packet);
        if (packets.length > 300) packets.removeLast();
      });
    });
  }

  Future<void> _exportToJson() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/kalashark_log.json');
    await file.writeAsString(jsonEncode(packets));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Exported to kalashark_log.json')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        packets.where((p) {
          return filter.isEmpty ||
              p.values.any(
                (v) => v.toLowerCase().contains(filter.toLowerCase()),
              );
        }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: Text(
          "KalaShark Terminal",
          style: GoogleFonts.orbitron(color: Colors.cyanAccent),
        ),
        backgroundColor: const Color(0xFF111111),
        actions: [
          IconButton(
            icon: Icon(
              isRunning ? Icons.stop : Icons.play_arrow,
              color: isRunning ? Colors.redAccent : Colors.greenAccent,
            ),
            tooltip: isRunning ? 'Stop VPN' : 'Start VPN',
            onPressed: () async {
              setState(() => isRunning = !isRunning);
              if (isRunning) {
                await VpnChannel.startVpn(ipv4: _ipController.text);
              } else {
                await VpnChannel.stopVpn();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.cyanAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: TextField(
              controller: _ipController,
              style: GoogleFonts.shareTechMono(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Custom IP for VPN (e.g., 10.0.0.2)',
                labelStyle: const TextStyle(color: Colors.cyanAccent),
                prefixIcon: const Icon(
                  Icons.network_wifi,
                  color: Colors.cyanAccent,
                ),
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (val) => setState(() => filter = val),
              style: GoogleFonts.shareTechMono(color: Colors.white),
              decoration: InputDecoration(
                hintText: '🔍 Filter by IP, port, proto...',
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(
                  Icons.filter_alt,
                  color: Colors.cyanAccent,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                final p = filtered[i];
                final color = _getColorByProto(p["proto"] ?? "");
                final time = p["time"]?.substring(11, 19) ?? "--:--:--";

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PacketDetailsScreen(packet: p),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.shareTechMono(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(
                            text: "[ $time ] ",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text: p["src"] ?? "",
                            style: const TextStyle(color: Colors.cyanAccent),
                          ),
                          const TextSpan(
                            text: " → ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: p["dst"] ?? "",
                            style: const TextStyle(
                              color: Colors.lightGreenAccent,
                            ),
                          ),
                          TextSpan(
                            text: " [${p["proto"] ?? "?"}] ",
                            style: TextStyle(color: color),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF111111),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              const Icon(
                Icons.network_check,
                color: Colors.cyanAccent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "Packets: ${packets.length}",
                style: GoogleFonts.shareTechMono(color: Colors.white70),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.pie_chart),
                tooltip: 'Show Protocol Chart',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChartScreen(packets)),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.download),
                tooltip: 'Export to JSON',
                onPressed: _exportToJson,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorByProto(String proto) {
    switch (proto.toUpperCase()) {
      case "TCP":
        return Colors.orangeAccent;
      case "UDP":
        return Colors.yellowAccent;
      case "ICMP":
        return Colors.lightBlueAccent;
      case "DNS":
        return Colors.purpleAccent;
      default:
        return Colors.white70;
    }
  }
}
