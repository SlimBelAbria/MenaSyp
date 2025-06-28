class User {
  final String id;
  final String name;
  final String lastname;
  final String email;
  final String role;
  final String? phone;
  final String? country;
  final String? institution;
  final String? position;
  final bool isActive;

  const User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.role,
    this.phone,
    this.country,
    this.institution,
    this.position,
    this.isActive = true,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      lastname: map['lastname']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      role: map['role']?.toString() ?? 'user',
      phone: map['phone']?.toString(),
      country: map['country']?.toString(),
      institution: map['institution']?.toString(),
      position: map['position']?.toString(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'email': email,
      'role': role,
      'phone': phone,
      'country': country,
      'institution': institution,
      'position': position,
      'isActive': isActive,
    };
  }

  String get fullName => '$name $lastname'.trim();
  bool get isAdmin => role.toLowerCase() == 'admin';

  User copyWith({
    String? id,
    String? name,
    String? lastname,
    String? email,
    String? role,
    String? phone,
    String? country,
    String? institution,
    String? position,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      institution: institution ?? this.institution,
      position: position ?? this.position,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, name: $name, lastname: $lastname, email: $email, role: $role)';
  }
} 