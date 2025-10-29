// lib/features/playback/pages/playback_detail_page.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../models/playback_item.dart';
import '../widgets/detected_person_card.dart';
import 'dart:math' as math;

class PlaybackDetailPage extends StatefulWidget {
  static const route = '/playback/detail';
  final PlaybackItem item;

  const PlaybackDetailPage({super.key, required this.item});

  @override
  State<PlaybackDetailPage> createState() => _PlaybackDetailPageState();
}

class _PlaybackDetailPageState extends State<PlaybackDetailPage> {
  VideoPlayerController? _vp;
  ChewieController? _chewie;

  @override
  void initState() {
    super.initState();
    _vp = VideoPlayerController.networkUrl(Uri.parse(widget.item.videoUrl));
    _vp!.initialize().then((_) {
      _chewie = ChewieController(
        videoPlayerController: _vp!,
        autoPlay: false,
        looping: false,
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _chewie?.dispose();
    _vp?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    // Dummy persons jika kosong
    final persons = (item.persons.isNotEmpty)
        ? item.persons
        : [
      DetectedPerson(
        name: 'Budi Santoso',
        idNumber: '3173123456780001',
        confidence: 92,
        label: 'Netral',
        avatarUrl: '',
      ),
      DetectedPerson(
        name: 'Siti Aminah',
        idNumber: '3173123456780002',
        confidence: 81,
        label: 'Redlist',
        avatarUrl: '',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Playback Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // <<< Sama seperti upload button: padding bawah pakai safe inset, tinggi 56
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12), // <<< sama persis
          child: _DeleteBarButton(onConfirm: _onDelete),
        ),
      ),

      // <<< Kurangi padding bawah konten agar tidak “berjauhan” dengan tombol bar
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        children: [
          _Section(title: 'Video Preview', child: _buildPlayer()),
          const SizedBox(height: 12),

          // VIDEO INFO
          _Section(
            title: 'Video Information',
            child: Column(
              children: [
                _kvRow('Filename', _displayTitle(item.title)),
                _kvRow('Size', '${item.sizeMb} MB'),
                _kvRow('Duration', _fmtDuration(item.duration)),
                _kvRow('Type', 'video/mp4'),
                _kvRow('Upload Date',
                    item.uploadedAt.toIso8601String().split('T').first),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('Status',
                            style: TextStyle(color: Colors.white70)),
                      ),
                      _statusChip(item.status),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // DETECTED PERSONS
          _Section(
            title: 'Detected Person (${persons.length})',
            child: Column(
              children: List.generate(
                persons.length,
                    (i) => Padding(
                  padding: EdgeInsets.only(top: i == 0 ? 0 : 10),
                  child: DetectedPersonCard(
                    person: persons[i],
                    index: i + 1,
                  ),
                ),
              ),
            ),
          ),

          // HAPUS tombol di sini (sudah pindah ke bottomNavigationBar)
          // const SizedBox(height: 12),
          // _DeleteButton(onConfirm: _onDelete),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    if (_chewie == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF1E2430),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const CircularProgressIndicator(),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio:
        _vp!.value.aspectRatio == 0 ? 16 / 9 : _vp!.value.aspectRatio,
        child: Chewie(controller: _chewie!),
      ),
    );
  }

  String _fmtDuration(Duration d) {
    final hh = d.inHours.toString().padLeft(2, '0');
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  // Nilai rata kanan
  Widget _kvRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(k, style: const TextStyle(color: Colors.white70)),
          ),
          Expanded(
            child: Text(
              v,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // Chip status high-contrast
  Widget _statusChip(String status) {
    final s = status.trim().toLowerCase();

    final bool isDone = s == 'done' || s == 'success' || s == 'completed';
    final bool isProc =
        s == 'process' || s == 'processing' || s == 'in progress' || s == 'pending';
    final bool isBad = s == 'minus' || s == 'failed' || s == 'error' || s == 'cancelled' || s == 'rejected';

    final Color base = isBad
        ? const Color(0xFFC62828) // red 800
        : (isProc
        ? const Color(0xFFEF6C00) // orange 800
        : (isDone
        ? const Color(0xFF2E7D32) // green 800
        : const Color(0xFF607D8B))); // blueGrey 500

    final Color bg = base.withOpacity(.42);
    final Color border = base;
    final Color fg = Colors.white;

    final String label =
    isDone ? 'Done' : (isProc ? 'Process' : _titleCase(status));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: border, width: 1.2),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: 12.5,
          letterSpacing: .2,
          height: 1.0,
        ),
      ),
    );
  }

  String _titleCase(String input) {
    if (input.isEmpty) return input;
    return input
        .split(RegExp(r'\s+'))
        .map((w) => w.isEmpty
        ? w
        : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }

  String _displayTitle(String t) {
    return t.replaceFirst(RegExp(r'^\s*\d+\.\s*'), '');
  }

  Future<void> _onDelete() async {
    // TODO: panggil API delete -> pop bila sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delete belum diimplementasikan')),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2430),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

/// Tombol delete versi bottom bar (tinggi 56, sejajar dengan Upload Video)
class _DeleteBarButton extends StatelessWidget {
  final VoidCallback onConfirm;
  const _DeleteBarButton({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    const Color bg = Color(0xFFDC2626); // red-600
    const Color fg = Colors.white;

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final ok = await _confirmDelete(context);
          if (ok == true) onConfirm();
        },
        icon: const Icon(Icons.delete_forever_rounded, size: 22),
        label: const Text(
          'Delete Video',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w800,
            letterSpacing: .2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2430),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Hapus video ini?'),
          content: const Text('Tindakan ini tidak bisa dibatalkan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB91C1C), // red-700
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}