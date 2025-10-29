class PlaybackItem {
  final String id;
  final String title;
  final String thumbUrl;     // boleh kosong → placeholder
  final String videoUrl;     // http(s) atau file://
  final DateTime uploadedAt;
  final int sizeMb;
  final Duration duration;
  final String status;       // "Done" | "Process" | "Failed"
  final List<DetectedPerson> persons;

  PlaybackItem({
    required this.id,
    required this.title,
    required this.thumbUrl,
    required this.videoUrl,
    required this.uploadedAt,
    required this.sizeMb,
    required this.duration,
    required this.status,
    required this.persons,
  });
}

class DetectedPerson {
  final String name;
  final String idNumber;
  final int confidence;      // 0..100
  final String label;        // "Internal", "Blacklist", etc.
  final String avatarUrl;

  DetectedPerson({
    required this.name,
    required this.idNumber,
    required this.confidence,
    required this.label,
    required this.avatarUrl,
  });
}