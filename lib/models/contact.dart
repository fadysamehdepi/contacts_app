class Contact {
  final int? id;
  final String name;
  final String surname;
  final String phone;
  final int? isFavorite;

  Contact({
    this.id,
    required this.name,
    required this.surname,
    required this.phone,
    this.isFavorite = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'phone': phone,
      'isFavorite': isFavorite,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int?,
      name: map['name'],
      surname: map['surname'],
      phone: map['phone'],
      isFavorite: map['isFavorite'] as int? ?? 0,
    );
  }

  Contact copyWith({
    int? id,
    String? name,
    String? surname,
    String? phone,
    int? isFavorite,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phone: phone ?? this.phone,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
