import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

import '../theme/nuvo_gradients.dart';
import 'recharge_screen.dart';
import 'withdraw_screen.dart'; // Importamos la nueva pantalla

import 'transfer_screen.dart';
import 'loan_screen.dart';
import 'pool_screen.dart';
import 'profile_screen.dart';
import 'transaction_detail_screen.dart'; // Importamos la nueva pantalla

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // --- DATOS MOCK ---
  double _balance = 0.00;
  String _userName = "Cargando...";
  String _accountNumber = "****";
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when the app comes back to foreground
      _loadUserData();
    }
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final userName = prefs.getString('userName') ?? "Usuario";

    if (userId == null) return;

    final api = ApiService();

    // 1. Obtener Cuenta
    final accountData = await api.getAccountData(userId);

    setState(() {
      _balance = (accountData['balance'] as num).toDouble();
      _accountNumber = accountData['accountNumber'].toString().substring(
        accountData['accountNumber'].toString().length - 4,
      );
      _userName = userName;
    });

    // 2. Obtener Transacciones
    final history = await api.getHistory(userId);

    setState(() {
      _transactions = history
          .map((t) {
            // Backend returns transaction object. We need to adapt it if necessary.
            // Assuming backend returns: { type, amount, timestamp, ... }
            // And amount is signed correctly or we need to check source/target.
            // For now, let's assume the backend returns a list of transactions where the user is involved.
            // We need to determine if it's positive or negative based on source/target or if backend does it.
            // Let's assume backend returns raw transaction data.

            final isSource =
                t['sourceAccountId'] ==
                userId; // Assuming backend uses sourceAccountId
            // Or check my previous ApiService implementation or backend controller.
            // TransactionController returns List<Transaction>. Transaction has sourceAccountId, targetAccountId.

            // If I am source, it's negative (unless it's a deposit to myself? No, deposit has source null).
            // If I am target, it's positive.

            double amount = (t['amount'] as num).toDouble();
            String type = t['type'] ?? "UNKNOWN";

            // Determine sign based on type and role
            if (type == 'DEPOSIT' ||
                type == 'POOL_WITHDRAWAL' ||
                type == 'LOAN_DISBURSEMENT') {
              amount = amount.abs(); // Always positive (Income)
            } else if (type == 'INVESTMENT' ||
                type == 'WITHDRAWAL' ||
                type == 'LOAN_PAYMENT') {
              amount = -amount.abs(); // Always negative (Expense)
            } else if (type == 'TRANSFER') {
              if (isSource) {
                amount = -amount.abs();
              } else {
                amount = amount.abs();
              }
            } else {
              // Fallback for unknown types
              if (isSource) {
                amount = -amount.abs();
              } else {
                amount = amount.abs();
              }
            }

            return {
              "type": t['type'] ?? "TRANSACCIÓN",
              "amount": amount,
              "date": (t['timestamp'] ?? DateTime.now().toIso8601String())
                  .toString()
                  .split('T')[0],
              "description": t['description'] ?? "Movimiento",
              ...t,
            };
          })
          .toList()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    });
  }

  void _refreshData() {
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NuvoGradients.blackBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. HEADER GRADIENT ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
              decoration: const BoxDecoration(
                gradient: NuvoGradients.headerGradient,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF4C1D95,
                              ).withOpacity(0.5), // Deep Purple
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: const Text(
                              "U",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hola,",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _userName,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.wb_sunny_outlined,
                            color: Colors.orangeAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfileScreen(),
                              ),
                            ),
                            child: const Icon(
                              Icons.settings_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- 2. BALANCE CARD ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: NuvoGradients.cardBackground,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Saldo Disponible",
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ShaderMask(
                          shaderCallback: (bounds) => NuvoGradients
                              .balanceGradient
                              .createShader(bounds),
                          child: Text(
                            "\$${_balance.toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Required for ShaderMask
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF8B5CF6),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Cuenta: .... $_accountNumber",
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- 3. ACTION BUTTONS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ActionButton(
                    icon: Icons.send_outlined,
                    label: "Enviar",
                    gradient: NuvoGradients.actionSend,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TransferScreen()),
                    ),
                  ),
                  _ActionButton(
                    icon: Icons.add,
                    label: "Recargar",
                    gradient: NuvoGradients.actionRecharge,
                    onTap: () =>
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RechargeScreen(),
                          ),
                        ).then((res) {
                          if (res == true) _refreshData();
                        }),
                  ),
                  _ActionButton(
                    icon: Icons.south_west, // Arrow down-leftish for withdraw
                    label: "Retirar",
                    gradient: NuvoGradients.actionWithdraw,
                    onTap: () async {
                      // AHORA NAVEGAMOS A LA PANTALLA COMPLETA
                      final res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WithdrawScreen(),
                        ),
                      );
                      if (res == true) _refreshData();
                    },
                  ),
                  _ActionButton(
                    icon: Icons.account_balance_wallet_outlined,
                    label: "Préstamos",
                    gradient: NuvoGradients.actionLoans,
                    onTap: () =>
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoanScreen()),
                        ).then((res) {
                          if (res == true) _refreshData();
                        }),
                  ),
                  _ActionButton(
                    icon: Icons.trending_up,
                    label: "Piscina",
                    gradient: NuvoGradients.actionPool,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PoolScreen()),
                    ).then((_) => _refreshData()),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 4. MOVIMIENTOS RECIENTES ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Movimientos Recientes",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final t = _transactions[index];
                final isPositive = (t['amount'] as double) > 0;

                return GestureDetector(
                  onTap: () {
                    // AHORA NAVEGAMOS A LA PANTALLA COMPLETA
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TransactionDetailScreen(transaction: t),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: NuvoGradients.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        // Icono
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isPositive
                                ? NuvoGradients.transactionIconBgPositive
                                : NuvoGradients.transactionIconBgNegative,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPositive ? Icons.south_west : Icons.north_east,
                            color: isPositive
                                ? NuvoGradients.greenText
                                : NuvoGradients.redText,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Detalles
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t['type'],
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                t['date'],
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Monto
                        Text(
                          "${isPositive ? '+' : ''}\$${t['amount'].abs().toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: isPositive
                                ? NuvoGradients.greenText
                                : NuvoGradients.redText,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(
                20,
              ), // Squircle shape like in image
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
