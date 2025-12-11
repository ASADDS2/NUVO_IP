import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../theme/nuvo_gradients.dart';
import '../models/investment_model.dart';

class PoolDashboard extends StatefulWidget {
  final VoidCallback onWithdrawSuccess;

  const PoolDashboard({super.key, required this.onWithdrawSuccess});

  @override
  State<PoolDashboard> createState() => _PoolDashboardState();
}

class _PoolDashboardState extends State<PoolDashboard> {
  bool _isLoading = true;
  bool _isWithdrawing = false;
  final ApiService _api = ApiService();
  List<Investment> _investments = [];
  double _totalInvested = 0.0;
  double _totalProfit = 0.0;

  @override
  void initState() {
    super.initState();
    _loadInvestments();
  }

  void _loadInvestments() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final investmentsData = await _api.getMyInvestments(userId);
      final stats = await _api.getPoolStats(userId);

      setState(() {
        _investments = investmentsData
            .map((data) => Investment.fromJson(data))
            .where((inv) => inv.status == 'ACTIVE')
            .toList();
        _totalInvested = stats['totalInvested'] ?? 0.0;
        _totalProfit = stats['currentProfit'] ?? 0.0;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading investments: $e");
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar inversiones: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _withdraw() async {
    if (_investments.isEmpty) return;

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NuvoGradients.cardBackground,
        title: Text(
          '¿Retirar inversión?',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Text(
          '¿Estás seguro de que deseas retirar toda tu inversión y ganancias?',
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'CANCELAR',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'RETIRAR',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isWithdrawing = true);

    try {
      // Withdraw all active investments
      for (final investment in _investments) {
        if (investment.id != null) {
          await _api.withdrawFromPool(investment.id!);
        }
      }

      setState(() => _isWithdrawing = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Retiro exitoso. Fondos depositados en tu cuenta"),
            backgroundColor: NuvoGradients.greenText,
          ),
        );
        widget.onWithdrawSuccess();
      }
    } catch (e) {
      setState(() => _isWithdrawing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error al retirar: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_investments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 80,
                color: Colors.grey.shade700,
              ),
              const SizedBox(height: 20),
              Text(
                "No tienes inversiones activas",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    final totalValue = _totalInvested + _totalProfit;
    final firstInvestment = _investments.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Tarjeta Principal
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF101214), Color(0xFF1E2228)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: NuvoGradients.blackBackground,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: NuvoGradients.purpleText.withOpacity(0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: NuvoGradients.purpleText,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Tu Inversión Activa",
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  "\$ ${totalValue.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: NuvoGradients.greenText.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: NuvoGradients.greenText.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    "+ \$${_totalProfit.toStringAsFixed(2)} Ganancia",
                    style: GoogleFonts.poppins(
                      color: NuvoGradients.greenText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: NuvoGradients.cardBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              children: [
                _DetailItem(
                  "Capital Inicial",
                  "\$ ${_totalInvested.toStringAsFixed(2)}",
                ),
                Divider(color: Colors.white.withOpacity(0.05)),
                _DetailItem("Piscina", firstInvestment.pool?.name ?? "N/A"),
                Divider(color: Colors.white.withOpacity(0.05)),
                _DetailItem(
                  "Tasa de Interés",
                  firstInvestment.pool != null
                      ? "${firstInvestment.pool!.annualRate.toStringAsFixed(1)}% Anual"
                      : "N/A",
                ),
                Divider(color: Colors.white.withOpacity(0.05)),
                _DetailItem("Inversiones Activas", "${_investments.length}"),
              ],
            ),
          ),

          const SizedBox(height: 50),

          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: NuvoGradients.actionWithdraw, // Orange/Red gradient
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isWithdrawing ? null : _withdraw,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isWithdrawing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "RETIRAR CAPITAL Y GANANCIAS",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _DetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
