import '../core/enums.dart';

/// Represents one relay-controlled electrical load connected to the grid.
class Load {
  final String id;
  final String name;
  final LoadCategory category;
  final double powerWatts;
  final bool isOn;

  const Load({
    required this.id,
    required this.name,
    required this.category,
    required this.powerWatts,
    required this.isOn,
  });

  factory Load.fromJson(Map<String, dynamic> json) => Load(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] == 'essential'
            ? LoadCategory.essential
            : LoadCategory.nonEssential,
        powerWatts: (json['powerWatts'] as num).toDouble(),
        isOn: json['isOn'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category == LoadCategory.essential ? 'essential' : 'nonEssential',
        'powerWatts': powerWatts,
        'isOn': isOn,
      };

  Load copyWith({
    String? id,
    String? name,
    LoadCategory? category,
    double? powerWatts,
    bool? isOn,
  }) {
    return Load(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      powerWatts: powerWatts ?? this.powerWatts,
      isOn: isOn ?? this.isOn,
    );
  }
}
