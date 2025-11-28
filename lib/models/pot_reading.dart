class PotReading {
  final int rawValue;
  final double normalized;
  final DateTime createdAt;

  PotReading({
    required this.rawValue,
    required this.normalized,
    required this.createdAt,
  });

  double get percent => (normalized * 100).clamp(0.0, 100.0);

  factory PotReading.fromMap(Map<String, dynamic> map) {
    final raw = (map['raw_value'] as int?) ?? 0;
    final norm = (map['normalized'] as num?)?.toDouble() ?? (raw / 4095.0);

    return PotReading(
      rawValue: raw,
      normalized: norm.clamp(0.0, 1.0),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}