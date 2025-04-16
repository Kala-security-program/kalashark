import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HexViewer extends StatelessWidget {
  final String hexData;

  const HexViewer({super.key, required this.hexData});

  @override
  Widget build(BuildContext context) {
    if (hexData.isEmpty) {
      return const Text(
        "No hex data available.",
        style: TextStyle(color: Colors.white54),
      );
    }

    final lines = _formatHexDump(hexData);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SelectableText(
        lines.join('\n'),
        style: GoogleFonts.sourceCodePro(
          fontSize: 13,
          color: Colors.lightGreenAccent,
        ),
      ),
    );
  }

  List<String> _formatHexDump(String hex) {
    final bytes = <int>[];
    for (int i = 0; i < hex.length - 1; i += 2) {
      try {
        bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
      } catch (_) {
        bytes.add(0);
      }
    }

    final lines = <String>[];
    for (int i = 0; i < bytes.length; i += 16) {
      final hexPart = List.generate(16, (j) {
        final index = i + j;
        return index < bytes.length
            ? bytes[index].toRadixString(16).padLeft(2, '0')
            : '  ';
      }).join(' ');

      final asciiPart =
          List.generate(16, (j) {
            final index = i + j;
            if (index < bytes.length) {
              final b = bytes[index];
              return b >= 32 && b <= 126 ? String.fromCharCode(b) : '.';
            } else {
              return ' ';
            }
          }).join();

      lines.add(
        '${i.toRadixString(16).padLeft(8, '0')}  $hexPart  |$asciiPart|',
      );
    }

    return lines;
  }
}
