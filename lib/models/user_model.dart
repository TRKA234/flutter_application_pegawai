class User {
  final int id;
  final String name;
  final String email;
  final String? token;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final dynamic idValue = json['id'] ?? json['user_id'];
    final int parsedId = idValue is String
        ? int.tryParse(idValue) ?? 0
        : (idValue as int? ?? 0);
    return User(
      id: parsedId,
      name: (json['name'] ?? json['nama'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (token != null) 'token': token,
    };
  }
}
