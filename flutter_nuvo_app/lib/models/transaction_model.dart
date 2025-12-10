class TransactionModel {
  final int? id;
  final int? sourceUserId;
  final int? targetUserId;
  final double amount;
  final String type;
  final String timestamp;

  TransactionModel({
    this.id,
    this.sourceUserId,
    this.targetUserId,
    required this.amount,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sourceUserId': sourceUserId,
      'targetUserId': targetUserId,
      'amount': amount,
      'type': type,
      'timestamp': timestamp,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      sourceUserId: map['sourceUserId'],
      targetUserId: map['targetUserId'],
      amount: map['amount'],
      type: map['type'],
      timestamp: map['timestamp'],
    );
  }
}
