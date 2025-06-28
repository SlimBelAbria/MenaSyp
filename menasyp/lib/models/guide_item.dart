class GuideItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GuideItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory GuideItem.fromMap(Map<String, dynamic> map) {
    return GuideItem(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      category: map['category']?.toString() ?? 'General',
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
      'title': title,
      'description': description,
      'category': category,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  GuideItem copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GuideItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GuideItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'GuideItem(id: $id, title: $title, category: $category)';
  }
} 