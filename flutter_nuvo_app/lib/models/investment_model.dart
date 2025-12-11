import 'pool_model.dart';

class Investment {
  final int? id;
  final int userId;
  final double investedAmount;
  final String investedAt;
  final String status; // ACTIVE, WITHDRAWN
  final int? poolId;
  final Pool? pool;

  Investment({
    this.id,
    required this.userId,
    required this.investedAmount,
    required this.investedAt,
    required this.status,
    this.poolId,
    this.pool,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'investedAmount': investedAmount,
      'investedAt': investedAt,
      'status': status,
      'poolId': poolId,
      'pool': pool?.toMap(),
    };
  }

  Map<String, dynamic> toJson() => toMap();

  factory Investment.fromMap(Map<String, dynamic> map) {
    return Investment(
      id: map['id'],
      userId: map['userId'],
      investedAmount: (map['investedAmount'] is num)
          ? (map['investedAmount'] as num).toDouble()
          : 0.0,
      investedAt: map['investedAt'] ?? '',
      status: map['status'] ?? 'ACTIVE',
      poolId: map['poolId'],
      pool: map['pool'] != null ? Pool.fromMap(map['pool']) : null,
    );
  }

  factory Investment.fromJson(Map<String, dynamic> json) =>
      Investment.fromMap(json);
}
