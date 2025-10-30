import 'dart:math' as math;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'playback_detail_page.dart';
import '../models/playback_item.dart';
import '../widgets/status_badge.dart';

class PlaybackListPage extends StatefulWidget {
  static const route = '/playback';
  const PlaybackListPage({super.key});

  @override
  State<PlaybackListPage> createState() => _PlaybackListPageState();
}

class _PlaybackListPageState extends State<PlaybackListPage> {
  final _searchCtrl = TextEditingController();

  // ukuran compact
  static const double _thumbW = 92;
  static const double _thumbH = 54; // tinggi minimal kartu

  int _pageSize = 7;
  int _currentPage = 1;

  // TODO: ganti ini pakai fetch API
  late final List<PlaybackItem> _all = List.generate(125, (i) {
    return PlaybackItem(
      id: '$i',
      title: '${i + 1}. Video Name here.MP4',
      thumbUrl: '',
      videoUrl:
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      uploadedAt: DateTime.now().subtract(Duration(minutes: i * 7)),
      sizeMb: 254,
      duration: const Duration(minutes: 10),
      status: (i % 3 == 0) ? 'Process' : 'Done',
      persons: const [],
    );
  });

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() => setState(() => _currentPage = 1));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('yyyy-MM-dd | HH:mm:ss');

    // Filter
    final filtered = _all.where((e) {
      final q = _searchCtrl.text.trim().toLowerCase();
      return q.isEmpty || e.title.toLowerCase().contains(q);
    }).toList();

    // Paging (client-side demo)
    final total = filtered.length;
    final totalPages = (total == 0) ? 1 : ((total - 1) ~/ _pageSize) + 1;
    _currentPage = _currentPage.clamp(1, totalPages);
    final start = (_currentPage - 1) * _pageSize;
    final end = math.min(start + _pageSize, total);
    final pageItems =
    (total == 0) ? const <PlaybackItem>[] : filtered.sublist(start, end);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Playback Video'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false, // cuma jaga area bawah (notch/home bar)
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12), // <<< jarak atas 12px (sama)
          child: _UploadButton(
            onPressed: _onUploadPressed,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          children: [
            // Search
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search video here',
                prefixIcon: const Icon(Icons.search),
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // 7/125 Videos + Show
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${pageItems.length}/${_all.length} Videos',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                _ShowDropdown(
                  value: _pageSize,
                  onChanged: (v) => setState(() {
                    _pageSize = v;
                    _currentPage = 1;
                  }),
                ),

              ],
            ),
            const SizedBox(height: 12),

            // List
            Expanded(
              child: pageItems.isEmpty
                  ? const Center(child: Text('No videos found'))
                  : ListView.separated(
                itemCount: pageItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final item = pageItems[i];
                  return InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      PlaybackDetailPage.route,
                      arguments: item,
                    ),
                    child: Container(
                      // tidak fixed height -> biar adaptif, tapi minimal setinggi thumbnail
                      constraints:
                      const BoxConstraints(minHeight: _thumbH),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2430),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.06)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const _ThumbBox(w: _thumbW, h: _thumbH),
                          const SizedBox(width: 12),

                          // Kanan: judul, tanggal, baris (size + badge kanan)
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Judul
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                      fontSize: 14.5, height: 1.15),
                                ),
                                const SizedBox(height: 4),
                                // Tanggal
                                Text(
                                  df.format(item.uploadedAt),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                      fontSize: 12, height: 1.15),
                                ),
                                const SizedBox(height: 4),
                                // Size (kiri) + Badge (kanan)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${item.sizeMb} MB',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                            fontSize: 12,
                                            height: 1.15),
                                      ),
                                    ),
                                    StatusBadge(
                                      status: item.status,
                                      dense: true,
                                      scale: 0.9,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),
                          // Eye icon center vertikal
                          Align(
                            alignment: Alignment.center,
                            child: _EyeButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                PlaybackDetailPage.route,
                                arguments: item,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onUploadPressed() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['mp4', 'mov', 'm4v'],
    );
    if (result == null) return;
    if (!mounted) return;
    final file = result.files.single;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: ${file.name}')),
    );
  }
}

class _ThumbBox extends StatelessWidget {
  final double w;
  final double h;
  const _ThumbBox({required this.w, required this.h});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: w,
        height: h,
        color: const Color(0xFF2A3140),
        alignment: Alignment.center,
        child: const Icon(Icons.videocam_outlined, size: 18),
      ),
    );
  }
}

class _EyeButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _EyeButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF2A3140),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.remove_red_eye_outlined, size: 18),
        ),
      ),
    );
  }
}

class _ShowDropdown extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _ShowDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2430),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Text('Show:  '),
          DropdownButton<int>(
            value: value,
            underline: const SizedBox.shrink(),
            onChanged: (v) => v == null ? null : onChanged(v),
            items: const [7, 15, 25]
                .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _UploadButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // warna primer yang kontras di dark theme
    const Color bg = Color(0xFF2563EB); // blue-600
    const Color fg = Colors.white;

    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.white.withOpacity(0.12), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_rounded, size: 22),
            SizedBox(width: 10),
            Text(
              'Upload Video',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                letterSpacing: .2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}