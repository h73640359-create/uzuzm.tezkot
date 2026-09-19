class UserProfile {
  const UserProfile({
    required this.name,
    required this.phone,
    required this.email,
    this.avatarUrl,
  });

  final String name;
  final String phone;
  final String email;
  final String? avatarUrl;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }

  UserProfile copyWith({String? name, String? phone, String? email, String? avatarUrl}) =>
      UserProfile(
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
        name: j['name'] as String,
        phone: j['phone'] as String,
        email: j['email'] as String,
        avatarUrl: j['avatarUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'avatarUrl': avatarUrl,
      };
}
