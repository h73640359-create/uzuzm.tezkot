class Address {
  const Address({
    required this.id,
    required this.title,
    required this.city,
    required this.street,
    required this.details,
    this.isDefault = false,
  });

  final String id;
  final String title;
  final String city;
  final String street;
  final String details;
  final bool isDefault;

  String get full => '$city, $street${details.isNotEmpty ? ', $details' : ''}';

  Address copyWith({
    String? title,
    String? city,
    String? street,
    String? details,
    bool? isDefault,
  }) =>
      Address(
        id: id,
        title: title ?? this.title,
        city: city ?? this.city,
        street: street ?? this.street,
        details: details ?? this.details,
        isDefault: isDefault ?? this.isDefault,
      );

  factory Address.fromJson(Map<String, dynamic> j) => Address(
        id: j['id'] as String,
        title: j['title'] as String,
        city: j['city'] as String,
        street: j['street'] as String,
        details: j['details'] as String? ?? '',
        isDefault: j['isDefault'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'city': city,
        'street': street,
        'details': details,
        'isDefault': isDefault,
      };
}
