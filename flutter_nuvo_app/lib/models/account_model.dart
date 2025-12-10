class Account {
  final int? id;
  final int userId;
  final String accountNumber;
  final double balance;
  final String createdAt;

  Account({
    this.id,
    required this.userId,
    required this.accountNumber,
    required this.balance,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'accountNumber': accountNumber,
      'balance': balance,
      'createdAt': createdAt,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      userId: map['userId'],
      accountNumber: map['accountNumber'],
      balance: map['balance'],
      createdAt: map['createdAt'],
    );
  }
}
