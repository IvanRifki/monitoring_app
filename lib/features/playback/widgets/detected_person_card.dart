import 'package:flutter/material.dart';
import '../models/playback_item.dart';

class DetectedPersonCard extends StatelessWidget {
  final DetectedPerson person;
  final int index;

  const DetectedPersonCard({
    super.key,
    required this.person,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final label = (person.label.isEmpty) ? 'Netral' : person.label;
    final low = label.toLowerCase();
    final isRedlist = low == 'redlist' || low == 'blacklist';
    final isNetral  = low == 'netral'  || low == 'neutral';

    // warna label (kontras tinggi)
    final Color labelBase = isRedlist
        ? const Color(0xFFC62828) // red 800
        : (isNetral
        ? const Color(0xFF1565C0) // blue 800
        : const Color(0xFF607D8B)); // blueGrey 500 (fallback)

    final Color labelBg   = labelBase.withOpacity(.42);
    const Color labelText = Colors.white;

    // warna similarity
    final int sim = person.confidence;
    final Color simColor = sim >= 90
        ? const Color(0xFF00FF07) // green 800
        : (sim >= 70 ? const Color(0xFFFF7400) // orange 800
        : const Color(0xFFC62828)); // red 800

    return Container
      (
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF202733),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Row(
        children: [
          // avatar / placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 52,
              height: 52,
              color: const Color(0xFF2A3140),
              alignment: Alignment.center,
              child: const Icon(Icons.person_outline, size: 22),
            ),
          ),
          const SizedBox(width: 12),

          // teks kiri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // nomor. nama
                Text(
                  '$index. ${person.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 14.5, height: 1.15),
                ),
                const SizedBox(height: 2),
                // NIK
                Text(
                  person.idNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(height: 1.15),
                ),
                const SizedBox(height: 8),

                // badge label (kontras tinggi)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: labelBg,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: labelBase, width: 1.2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isRedlist ? 'Redlist' : (isNetral ? 'Netral' : label[0].toUpperCase()+label.substring(1)),
                        style: TextStyle(
                          color: labelText,
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                          letterSpacing: .2,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // similarity kanan (kontras & tebal)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Similarity',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 2),
              Text(
                '$sim%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: simColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}