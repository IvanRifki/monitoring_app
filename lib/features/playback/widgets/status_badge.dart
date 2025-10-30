import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool dense;
  final double scale;       // 1.0 normal; <1.0 lebih kecil
  final bool highContrast;  // true = lebih tegas/kontras

  const StatusBadge({
    super.key,
    required this.status,
    this.dense = false,
    this.scale = 1.0,
    this.highContrast = true,
  });

  @override
  Widget build(BuildContext context) {
    final s = status.trim().toLowerCase();

    // Palet warna per status
    // - "minus", "failed", "error", "cancelled", "rejected" => merah
    // - "process", "processing", "in progress", "pending"   => amber
    // - "done", "success", "completed"                      => hijau
    // - lainnya => abu
    final bool isBad = s == 'minus' || s == 'failed' || s == 'error' || s == 'cancelled' || s == 'rejected';
    final bool isProc = s == 'process' || s == 'processing' || s == 'in progress' || s == 'pending';
    final bool isGood = s == 'done' || s == 'success' || s == 'completed';

    final Color base = isBad
        ? const Color(0xFFC62828) // red 800
        : (isProc
        ? const Color(0xFFEF6C00) // orange 800
        : (isGood
        ? const Color(0xFF2E7D32) // green 800
        : const Color(0xFF607D8B))); // blueGrey 500

    // Background lebih solid kalau highContrast = true
    final double bgOpacity = highContrast ? 0.42 : 0.22;
    final Color bg = base.withOpacity(bgOpacity);
    final Color border = base;
    // Agar selalu terbaca di dark UI, pakai teks putih
    const Color fg = Colors.white;

    // Sizing berbasis dense + scale
    final double basePadV = dense ? 3.0 : 7.0;
    final double basePadH = dense ? 9.0 : 12.0;
    final double baseRadius = dense ? 7.0 : 9.0;
    final double baseFont = dense ? 11.5 : 13.5;

    final padV = (basePadV * scale).clamp(2.0, 10.0);
    final padH = (basePadH * scale).clamp(6.0, 18.0);
    final radius = (baseRadius * scale).clamp(5.0, 12.0);
    final fontSize = (baseFont * scale).clamp(10.0, 16.0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border, width: highContrast ? 1.2 : 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            // Tampilkan kapitalisasi rapi (e.g. "Process", "Done", "Minus")
            _titleCase(status),
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w800,
              fontSize: fontSize,
              height: 1.0,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  String _titleCase(String input) {
    if (input.isEmpty) return input;
    return input
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }
}