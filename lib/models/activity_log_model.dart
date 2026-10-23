class ActivityLogModel {
  final String id;
  final String timestamp;
  final String user;
  final String action;
  final String details;

  ActivityLogModel({
    required this.id,
    required this.timestamp,
    required this.user,
    required this.action,
    required this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp,
      'user': user,
      'action': action,
      'details': details,
    };
  }

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      user: json['user'] as String? ?? 'Sistem',
      action: json['action'] as String? ?? '',
      details: json['details'] as String? ?? '',
    );
  }
}
