class Pool {
  final int? id;
  final String name;
  final String? description;
  final double interestRatePerDay;
  final int maxParticipants;
  final bool active;
  final String createdAt;

  Pool({
    this.id,
    required this.name,
    this.description,
    required this.interestRatePerDay,
    required this.maxParticipants,
    required this.active,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'interestRatePerDay': interestRatePerDay,
      'maxParticipants': maxParticipants,
      'active': active ? 1 : 0,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'interestRatePerDay': interestRatePerDay,
      'maxParticipants': maxParticipants,
      'active': active,
      'createdAt': createdAt,
    };
  }

  factory Pool.fromMap(Map<String, dynamic> map) {
    return Pool(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'],
      interestRatePerDay: (map['interestRatePerDay'] is num)
          ? (map['interestRatePerDay'] as num).toDouble()
          : 0.0,
      maxParticipants: map['maxParticipants'] ?? 0,
      active: map['active'] == 1 || map['active'] == true,
      createdAt: map['createdAt'] ?? '',
    );
  }

  factory Pool.fromJson(Map<String, dynamic> json) {
    return Pool(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      interestRatePerDay: (json['interestRatePerDay'] is num)
          ? (json['interestRatePerDay'] as num).toDouble()
          : 0.0,
      maxParticipants: json['maxParticipants'] ?? 0,
      active: json['active'] == true,
      createdAt: json['createdAt'] ?? '',
    );
  }

  // Helper getter for annual rate display
  double get annualRate => interestRatePerDay * 365;
}
