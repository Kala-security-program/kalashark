// lib/screens/chart_screen.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChartScreen extends StatelessWidget {
  final List<Map<String, String>> packets;

  const ChartScreen(this.packets, {super.key});

  Map<String, int> _countProtocols() {
    final counts = <String, int>{};
    for (var p in packets) {
      final proto = p['proto'] ?? 'Unknown';
      counts[proto] = (counts[proto] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final data = _countProtocols();
    final total = data.values.fold(0, (sum, v) => sum + v);

    final chartSections =
        data.entries.map((e) {
          final percent = e.value / total * 100;
          return PieChartSectionData(
            title: '${e.key} (${percent.toStringAsFixed(1)}%)',
            color: _getColorByProto(e.key),
            value: e.value.toDouble(),
            radius: 80,
            titleStyle: GoogleFonts.shareTechMono(
              color: Colors.white,
              fontSize: 12,
            ),
          );
        }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        title: Text(
          "Protocol Chart",
          style: GoogleFonts.orbitron(color: Colors.cyanAccent),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
      body: Center(
        child: PieChart(
          PieChartData(
            sections: chartSections,
            sectionsSpace: 2,
            centerSpaceRadius: 40,
            borderData: FlBorderData(show: false),
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
        return Colors.deepPurpleAccent;
      default:
        return Colors.grey;
    }
  }
}
