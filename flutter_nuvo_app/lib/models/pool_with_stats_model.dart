import 'pool_model.dart';

class PoolWithStats {
  final Pool pool;
  final int currentInvestors;
  final int availableSlots;
  final double totalInvested;
  final double totalCurrentValue;

  PoolWithStats({
    required this.pool,
    required this.currentInvestors,
    required this.availableSlots,
    required this.totalInvested,
    required this.totalCurrentValue,
  });

  factory PoolWithStats.fromJson(Map<String, dynamic> json) {
    return PoolWithStats(
      pool: Pool.fromJson(json['pool']),
      currentInvestors: json['currentInvestors'] ?? 0,
      availableSlots: json['availableSlots'] ?? 0,
      totalInvested: (json['totalInvested'] is num)
          ? (json['totalInvested'] as num).toDouble()
          : 0.0,
      totalCurrentValue: (json['totalCurrentValue'] is num)
          ? (json['totalCurrentValue'] as num).toDouble()
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pool': pool.toJson(),
      'currentInvestors': currentInvestors,
      'availableSlots': availableSlots,
      'totalInvested': totalInvested,
      'totalCurrentValue': totalCurrentValue,
    };
  }

  // Helper getters for UI
  double get progress {
    if (pool.maxParticipants == 0) return 0.0;
    return currentInvestors / pool.maxParticipants;
  }

  bool get isFull => currentInvestors >= pool.maxParticipants;
}
