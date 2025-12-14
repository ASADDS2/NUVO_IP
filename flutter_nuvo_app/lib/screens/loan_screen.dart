import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../theme/nuvo_gradients.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  // Controladores
  final _amountController = TextEditingController();

  // Estado de la simulación
  int _selectedMonths = 12; // Plazo por defecto
  double _interestRate = 0.085; // 8.5% Anual (Simulado)
  bool _isLoading = false;
  Map<String, dynamic>? _activeLoan;
  final ApiService _apiService = ApiService();

  // --- CÁLCULOS EN TIEMPO REAL ---
  double get _amount => double.tryParse(_amountController.text) ?? 0.0;
  // Cálculo simple de cuota mensual (Amortización simple para demo)
  // Cuota = (Monto + (Monto * TasaAnual * (Meses/12))) / Meses
  double get _monthlyPayment {
    if (_selectedMonths == 0) return 0;
    double totalInterest = _amount * _interestRate * (_selectedMonths / 12);
    return (_amount + totalInterest) / _selectedMonths;
  }

  void _calculateMonthlyPayment() {
    setState(() {}); // Trigger rebuild to update _monthlyPayment getter usage
  }

  @override
  void initState() {
    super.initState();
    _fetchActiveLoan();
  }

  Future<void> _fetchActiveLoan() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      final loans = await _apiService.getMyLoans(userId);
      // Find active loans (APPROVED or PENDING) and get the most recent one
      try {
        final activeLoans = loans
            .where((l) => l['status'] == 'APPROVED' || l['status'] == 'PENDING')
            .toList();

        if (activeLoans.isNotEmpty) {
          // Take the most recent loan (last one in the list)
          setState(() => _activeLoan = activeLoans.last);
        } else {
          setState(() => _activeLoan = null);
        }
      } catch (e) {
        print("Error filtering loans: $e");
        setState(() => _activeLoan = null);
      }
    }
    setState(() => _isLoading = false);
  }

  // Lógica de Envío
  void _submitRequest() async {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ingresa un monto válido"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) throw Exception("Usuario no identificado");

      final api = ApiService();
      final success = await api.requestLoan(userId, _amount);

      setState(() => _isLoading = false);

      if (mounted) {
        if (success) {
          // Refresh loan status to show the new pending loan
          await _fetchActiveLoan();

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (c) => AlertDialog(
              backgroundColor: NuvoGradients.cardBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: NuvoGradients.blackBackground,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.orange,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "¡Solicitud Enviada!",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Tu préstamo está en revisión.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(c); // Close dialog only
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NuvoGradients.blackBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "ENTENDIDO",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error al solicitar préstamo"),
              backgroundColor: NuvoGradients.redText,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: NuvoGradients.redText,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          _activeLoan != null ? "Gestionar Préstamo" : "Solicitar Préstamo",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: NuvoGradients.headerGradient,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A1B3D), // Purple dark top
              Color(0xFF0F1512), // Dark Greenish/Black bottom
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              const SizedBox(height: 20),

              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              else if (_activeLoan != null)
                _buildActiveLoanDetails()
              else
                _buildLoanRequestForm(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoanRequestForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: NuvoGradients.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. INPUT MONTO
            Text(
              "Monto Solicitado",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                _calculateMonthlyPayment();
                setState(() {});
              },
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.attach_money, color: Colors.white),
                hintText: "0.00",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                filled: true,
                fillColor: NuvoGradients.blackBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 20),

            // 2. PLAZO (Dropdown)
            Text(
              "Plazo (Meses)",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: NuvoGradients.blackBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedMonths,
                  dropdownColor: NuvoGradients.cardBackground,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  isExpanded: true,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                  items: [6, 12, 18, 24, 36].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text("$value meses"),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMonths = newValue!;
                      _calculateMonthlyPayment();
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3. TARJETA RESUMEN INTERES
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D1F),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                ), // Purple border
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tasa de Interés Aproximada",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "8.5% Anual",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B5CF6), // Purple text
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Cuota mensual estimada: \$${_monthlyPayment.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 4. BOTÓN ENVIAR SOLICITUD
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: NuvoGradients.actionLoans, // Orange gradient
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "SOLICITAR PRÉSTAMO",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveLoanDetails() {
    final loan = _activeLoan!;

    if (loan['status'] == 'PENDING') {
      return _buildPendingLoanDetails();
    }

    final amount = (loan['amount'] as num).toDouble();
    final paid = (loan['paidAmount'] as num).toDouble();
    final interestRate = (loan['interestRate'] as num).toDouble();
    final totalToPay = amount * (1 + interestRate);
    final remaining = totalToPay - paid;
    final termMonths = loan['termMonths'] as int;
    final monthlyInstallment = totalToPay / termMonths;

    // Calculate how many payments have been made
    final paymentsMade = (paid / monthlyInstallment).floor();
    final paymentsRemaining = termMonths - paymentsMade;
    final progressPercentage = (paid / totalToPay).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: NuvoGradients.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with progress indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mi Préstamo",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Circular progress indicator
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: progressPercentage,
                        strokeWidth: 6,
                        backgroundColor: Colors.grey.shade800,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF8B5CF6),
                        ),
                      ),
                    ),
                    Text(
                      "${(progressPercentage * 100).toInt()}%",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Loan details
            _buildDetailRow("Monto Prestado", "\$${amount.toStringAsFixed(2)}"),
            _buildDetailRow(
              "Total a Pagar",
              "\$${totalToPay.toStringAsFixed(2)}",
            ),
            _buildDetailRow("Pagado", "\$${paid.toStringAsFixed(2)}"),
            const Divider(color: Colors.grey, height: 24),
            _buildDetailRow(
              "Restante",
              "\$${remaining.toStringAsFixed(2)}",
              isBold: true,
              color: const Color(0xFFFF6B6B),
            ),
            _buildDetailRow(
              "Cuotas Pagadas",
              "$paymentsMade de $termMonths",
              color: const Color(0xFF8B5CF6),
            ),
            const SizedBox(height: 20),

            // Monthly installment card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF8B5CF6).withOpacity(0.2),
                    const Color(0xFF6366F1).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cuota Mensual",
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade300,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$${monthlyInstallment.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "$paymentsRemaining cuotas restantes",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Payment options title
            Text(
              "Opciones de Pago",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Payment buttons - Pagar Cuota (Purple gradient)
            Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () => _payLoan(monthlyInstallment),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.credit_card,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pagar Cuota Mensual",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "\$${monthlyInstallment.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Payment buttons - Pagar Todo (Orange gradient)
            Container(
              width: double.infinity,
              height: 64,
              decoration: BoxDecoration(
                gradient: NuvoGradients.actionWithdraw, // Orange/Red gradient
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _payLoan(remaining),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.payments_outlined,
                      color: Colors.black,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Liquidar Préstamo",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "\$${remaining.toStringAsFixed(2)} (Total restante)",
                          style: GoogleFonts.poppins(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
              color: color ?? Colors.white,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _payLoan(double amount) async {
    if (_activeLoan == null) return;
    setState(() => _isLoading = true);

    final success = await _apiService.payLoan(_activeLoan!['id'], amount);

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pago realizado con éxito"),
          backgroundColor: Colors.green,
        ),
      );
      // Refresh the loan data to show updated information
      // The user stays on this screen to see the progress
      await _fetchActiveLoan();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al realizar el pago (Fondos insuficientes?)"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildPendingLoanDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: NuvoGradients.cardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NuvoGradients.blackBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_empty,
                color: Colors.orange,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Solicitud en Revisión",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tu solicitud de préstamo está siendo procesada. Te notificaremos cuando sea aprobada.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _fetchActiveLoan,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "ACTUALIZAR ESTADO",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
