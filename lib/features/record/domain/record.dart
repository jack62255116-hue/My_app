class Record {
  final int? id;
  final String category;
  final String value;
  final DateTime recordedAt;
  final String source;

  const Record({
    this.id,
    required this.category,
    required this.value,
    required this.recordedAt,
    this.source = 'manual',
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'category': category,
        'value': value,
        'recorded_at': recordedAt.toIso8601String(),
        'source': source,
      };

  factory Record.fromMap(Map<String, dynamic> map) => Record(
        id: map['id'] as int,
        category: map['category'] as String,
        value: map['value'] as String,
        recordedAt: DateTime.parse(map['recorded_at'] as String),
        source: map['source'] as String,
      );

  Record copyWith({
    int? id,
    String? category,
    String? value,
    DateTime? recordedAt,
    String? source,
  }) =>
      Record(
        id: id ?? this.id,
        category: category ?? this.category,
        value: value ?? this.value,
        recordedAt: recordedAt ?? this.recordedAt,
        source: source ?? this.source,
      );
}

class RecordCategory {
  final String name;
  final String emoji;
  final bool isNumeric;

  const RecordCategory({
    required this.name,
    required this.emoji,
    required this.isNumeric,
  });
}

const kCategories = [
  RecordCategory(name: '지출', emoji: '💰', isNumeric: true),
  RecordCategory(name: '운동', emoji: '💪', isNumeric: false),
  RecordCategory(name: '식단', emoji: '🍱', isNumeric: false),
  RecordCategory(name: '수면', emoji: '😴', isNumeric: false),
  RecordCategory(name: '메모', emoji: '📝', isNumeric: false),
];
