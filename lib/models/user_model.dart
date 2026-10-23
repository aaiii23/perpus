class UserModel {
  final String id;
  final String username;
  final String password;
  final String name;
  final String email;
  final String role; // 'petugas' | 'anggota'
  final String? nisn;
  final String? kelas;
  final String? phone;
  final String? avatar;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.email,
    required this.role,
    this.nisn,
    this.kelas,
    this.phone,
    this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'email': email,
      'role': role,
      'nisn': nisn,
      'kelas': kelas,
      'phone': phone,
      'avatar': avatar,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'anggota',
      nisn: json['nisn'] as String?,
      kelas: json['kelas'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
    );
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? password,
    String? name,
    String? email,
    String? role,
    String? nisn,
    String? kelas,
    String? phone,
    String? avatar,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      nisn: nisn ?? this.nisn,
      kelas: kelas ?? this.kelas,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
    );
  }
}
