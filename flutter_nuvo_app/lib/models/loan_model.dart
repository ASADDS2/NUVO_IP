class Loan {
  final int? id;
  final int userId;
  final double amount;
  final int termMonths;
  final double interestRate;
  final String status;
  final String createdAt;
  final String? approvedAt;
  final double paidAmount;

  Loan({
    this.id,
    required this.userId,
    required this.amount,
    required this.termMonths,
    required this.interestRate,
    required this.status,
    required this.createdAt,
    this.approvedAt,
    required this.paidAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'termMonths': termMonths,
      'interestRate': interestRate,
      'status': status,
      'createdAt': createdAt,
      'approvedAt': approvedAt,
      'paidAmount': paidAmount,
    };
  }

  factory Loan.fromMap(Map<String, dynamic> map) {
    return Loan(
      id: map['id'],
      userId: map['userId'],
      amount: map['amount'],
      termMonths: map['termMonths'],
      interestRate: map['interestRate'],
      status: map['status'],
      createdAt: map['createdAt'],
      approvedAt: map['approvedAt'],
      paidAmount: map['paidAmount'],
    );
  }
}
