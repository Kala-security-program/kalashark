import 'package:flutter/material.dart';

class PacketCard extends StatelessWidget {
  final Map<String, String> packet;
  final VoidCallback onTap;
  final bool isSelected;

  const PacketCard({
    super.key,
    required this.packet,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF1A1A1A),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.cyanAccent : Colors.deepPurple,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.device_hub, color: Colors.cyanAccent, size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${packet["src"]} ➜ ${packet["dst"]}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'ShareTechMono',
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                packet["proto"] ?? "???",
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontFamily: 'Orbitron',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
