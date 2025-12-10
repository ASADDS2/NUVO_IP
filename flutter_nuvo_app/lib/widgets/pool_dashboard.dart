import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../theme/nuvo_gradients.dart';

class PoolDashboard extends StatefulWidget {
  final VoidCallback onWithdrawSuccess;

  const PoolDashboard({super.key, required this.onWithdrawSuccess});

  @override
  State<PoolDashboard> createState() => _PoolDashboardState();
}

class _PoolDashboardState extends State<PoolDashboard> {
  bool _isLoading = false;
  final ApiService _api = ApiService();

  // Datos simulados de la inversión activa
  final double _invested = 5000.00;
  final double _profit = 150.50;

  void _withdraw() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    // await _api.deposit(_invested + _profit); // Reembolso real
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Retiro exitoso a tu cuenta"),
          backgroundColor: NuvoGradients.greenText,
        ),
      );
      widget.onWithdrawSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  "\$ ${(_invested + _profit).toStringAsFixed(2)}",
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
                    "+ \$${_profit.toStringAsFixed(2)} Ganancia",
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
                _DetailItem("Capital Inicial", "\$ $_invested"),
                Divider(color: Colors.white.withOpacity(0.05)),
                _DetailItem("Piscina", "Premium (15%)"),
                Divider(color: Colors.white.withOpacity(0.05)),
                _DetailItem("Fecha Inicio", "20 Nov 2025"),
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
              onPressed: _isLoading ? null : _withdraw,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading
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
