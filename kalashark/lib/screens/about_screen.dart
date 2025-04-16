import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        title: Text(
          'KΛLΛ :: SYSTEM INFO',
          style: GoogleFonts.orbitron(
            fontSize: 18,
            color: Colors.redAccent,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color(0xFF101010),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _sectionTitle("🤖 TERMINATOR :: Kala Security Program"),
            _sectionBody(
              "An elite cybersecurity & futuristic AI initiative founded by "
              "Dr. Sai Kamesh Yadavalli, Ph.D. Our tools simulate time-aware systems, quantum encryption, and offensive defense strategies.",
            ),
            const SizedBox(height: 20),

            _sectionTitle("🔧 ACTIVE MODULES"),
            _bullet("KalaShark - Real-time packet scanner with VPN sniffing"),
            _bullet("KalaCrypt - Encrypted messenger for agents"),
            _bullet("KalaRavana - Ethical RAT with command center"),
            _bullet("KalaTheory - Multiverse time-travel encryption logic"),
            _bullet("KPU Engine - Quantum packet processor simulation"),

            const SizedBox(height: 20),
            _sectionTitle("💻 CEO & CYBER ARCHITECT"),
            _monospacedText(
              "Dr. Sai Kamesh Yadavalli, Ph.D\nFounder & Lead Architect",
            ),

            const SizedBox(height: 20),
            _sectionTitle("🌐 INTEL LINKS"),
            _link("GitHub: github.com/Kala-security-program"),
            _link("Email: saikamesh.y@gmail.com"),

            const SizedBox(height: 30),
            Center(
              child: Text(
                ">> STATUS: ONLINE • SECURE :: 2025 Kala Security Program",
                style: GoogleFonts.shareTechMono(
                  color: Colors.redAccent.shade100,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      text,
      style: GoogleFonts.orbitron(
        fontSize: 16,
        color: Colors.redAccent,
        letterSpacing: 1.1,
      ),
    ),
  );

  Widget _sectionBody(String text) => Text(
    text,
    style: GoogleFonts.shareTechMono(color: Colors.grey.shade300, height: 1.5),
  );

  Widget _bullet(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("• ", style: GoogleFonts.shareTechMono(color: Colors.redAccent)),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.shareTechMono(color: Colors.white70),
          ),
        ),
      ],
    ),
  );

  Widget _link(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text(
      text,
      style: GoogleFonts.shareTechMono(
        color: Colors.cyanAccent,
        decoration: TextDecoration.underline,
      ),
    ),
  );

  Widget _monospacedText(String text) => Text(
    text,
    style: GoogleFonts.shareTechMono(
      color: Colors.greenAccent,
      fontWeight: FontWeight.bold,
      height: 1.4,
    ),
  );
}
