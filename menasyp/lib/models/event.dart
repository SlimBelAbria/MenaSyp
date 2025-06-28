class Event {
  final String id;
  final String name;
  final String description;
  final String time;
  final String day;
  final String type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Event({
    required this.id,
    required this.name,
    required this.description,
    required this.time,
    required this.day,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      time: map['time']?.toString() ?? '',
      day: map['day']?.toString() ?? '',
      type: map['type']?.toString() ?? 'general',
      createdAt: map['createdAt'] != null 
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null 
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'time': time,
      'day': day,
      'type': type,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Event copyWith({
    String? id,
    String? name,
    String? description,
    String? time,
    String? day,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      time: time ?? this.time,
      day: day ?? this.day,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Event && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Event(id: $id, name: $name, day: $day, time: $time, type: $type)';
  }
} 