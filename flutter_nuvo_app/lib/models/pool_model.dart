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

  factory Pool.fromMap(Map<String, dynamic> map) {
    return Pool(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      interestRatePerDay: map['interestRatePerDay'],
      maxParticipants: map['maxParticipants'],
      active: map['active'] == 1,
      createdAt: map['createdAt'],
    );
  }
}
