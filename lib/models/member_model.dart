class MemberModel {
  final String id;
  final String userId;
  final String nisn;
  final String name;
  final String gender;
  final String kelas;
  final String jurusan;
  final String email;
  final String phone;
  final String address;
  final String joinedDate;
  final String status; // 'Aktif' | 'Nonaktif'
  final String avatar;

  MemberModel({
    required this.id,
    required this.userId,
    required this.nisn,
    required this.name,
    this.gender = 'Laki-laki',
    required this.kelas,
    this.jurusan = 'Rekayasa Perangkat Lunak',
    required this.email,
    this.phone = '-',
    this.address = 'Bandung, Jawa Barat',
    required this.joinedDate,
    this.status = 'Aktif',
    this.avatar = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'nisn': nisn,
      'name': name,
      'gender': gender,
      'kelas': kelas,
      'jurusan': jurusan,
      'email': email,
      'phone': phone,
      'address': address,
      'joinedDate': joinedDate,
      'status': status,
      'avatar': avatar,
    };
  }

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      nisn: json['nisn'] as String? ?? '',
      name: json['name'] as String? ?? '',
      gender: json['gender'] as String? ?? 'Laki-laki',
      kelas: json['kelas'] as String? ?? '',
      jurusan: json['jurusan'] as String? ?? 'Rekayasa Perangkat Lunak',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '-',
      address: json['address'] as String? ?? '',
      joinedDate: json['joinedDate'] as String? ?? '',
      status: json['status'] as String? ?? 'Aktif',
      avatar: json['avatar'] as String? ?? '',
    );
  }

  MemberModel copyWith({
    String? id,
    String? userId,
    String? nisn,
    String? name,
    String? gender,
    String? kelas,
    String? jurusan,
    String? email,
    String? phone,
    String? address,
    String? joinedDate,
    String? status,
    String? avatar,
  }) {
    return MemberModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nisn: nisn ?? this.nisn,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      kelas: kelas ?? this.kelas,
      jurusan: jurusan ?? this.jurusan,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      joinedDate: joinedDate ?? this.joinedDate,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
    );
  }
}
