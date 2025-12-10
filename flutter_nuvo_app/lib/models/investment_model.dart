class Investment {
  final int? id;
  final int userId;
  final double investedAmount;
  final String investedAt;
  final String status;
  final int? poolId;

  Investment({
    this.id,
    required this.userId,
    required this.investedAmount,
    required this.investedAt,
    required this.status,
    this.poolId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'investedAmount': investedAmount,
      'investedAt': investedAt,
      'status': status,
      'poolId': poolId,
    };
  }

  factory Investment.fromMap(Map<String, dynamic> map) {
    return Investment(
      id: map['id'],
      userId: map['userId'],
      investedAmount: map['investedAmount'],
      investedAt: map['investedAt'],
      status: map['status'],
      poolId: map['poolId'],
    );
  }
}
