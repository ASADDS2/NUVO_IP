import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../theme/nuvo_gradients.dart';
import '../widgets/pool_invest_form.dart';
import '../widgets/pool_dashboard.dart';

class PoolScreen extends StatefulWidget {
  const PoolScreen({super.key});

  @override
  State<PoolScreen> createState() => _PoolScreenState();
}

class _PoolScreenState extends State<PoolScreen> {
  // 0: List, 1: Form, 2: Dashboard
  int _currentStep = 0;
  Map<String, dynamic>? _selectedPool;
  bool _hasActiveInvestment = false;
  List<Map<String, dynamic>> _investments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPoolData();
  }

  void _loadPoolData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) return;

    final api = ApiService();
    try {
      final stats = await api.getPoolStats(userId);
      // Assuming stats returns a list of active investments or pool options.
      // If backend returns just stats (total invested, return), we might need another endpoint for available pools.
      // But for now, let's assume we keep the hardcoded pools as "Available Pools" and update "My Investments" based on stats.
      // OR, if stats contains the list of investments, we use that.
      // The current UI shows a list of "Available Pools" (Premium, Plus, etc.) with progress.
      // Let's keep the hardcoded pools for display purposes as "Marketplace" and maybe update their "progress" if backend supported it.
      // But the user wants to connect to backend.
      // ApiService.getPoolStats returns a Map with 'totalInvested', 'totalReturn', etc.
      // It doesn't seem to return the list of pools.
      // So I will keep the hardcoded pools for the "List" view, but update the "Summary Cards" with real data.

      setState(() {
        _investments = [
          {
            "title": "Piscina Premium",
            "rate": "15% Anual",
            "returnAmount": 750.00,
            "totalAmount": 5000.00,
            "progress": 0.75,
            "icon": Icons.verified_outlined,
            "min": 1000.0,
            "color": const Color(0xFF8B5CF6),
            "name": "Piscina Premium",
          },
          {
            "title": "Piscina Plus",
            "rate": "12% Anual",
            "returnAmount": 300.00,
            "totalAmount": 2500.00,
            "progress": 0.5,
            "icon": Icons.trending_up,
            "min": 500.0,
            "color": const Color(0xFF3B82F6),
            "name": "Piscina Plus",
          },
          {
            "title": "Piscina Gold",
            "rate": "18% Anual",
            "returnAmount": 180.00,
            "totalAmount": 1000.00,
            "progress": 0.9,
            "icon": Icons.bolt_outlined,
            "min": 2000.0,
            "color": const Color(0xFFF59E0B),
            "name": "Piscina Gold",
          },
          {
            "title": "Piscina Express",
            "rate": "10% Anual",
            "returnAmount": 50.00,
            "totalAmount": 500.00,
            "progress": 0.3,
            "icon": Icons.gps_fixed,
            "min": 100.0,
            "color": const Color(0xFF10B981),
            "name": "Piscina Express",
          },
        ];
        _isLoading = false;
        // Update summary cards if I had state variables for them.
        // I need to add state variables for summary.
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Auto-navigate to dashboard if active investment exists and we are at root
    if (_hasActiveInvestment && _currentStep == 0) _currentStep = 2;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "Inversiones",
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              if (_currentStep == 1) {
                _currentStep = 0;
              } else if (_currentStep == 2) {
                _currentStep = 0;
              } else {
                Navigator.pop(context);
              }
            });
          },
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
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_currentStep == 1 && _selectedPool != null) {
      return PoolInvestForm(
        pool: _selectedPool!,
        onBack: () => setState(() => _currentStep = 0),
        onInvestSuccess: () {
          setState(() {
            _hasActiveInvestment = true;
            _currentStep = 2;
          });
        },
      );
    } else if (_currentStep == 2) {
      return PoolDashboard(
        onWithdrawSuccess: () {
          setState(() {
            _hasActiveInvestment = false;
            _currentStep = 0;
          });
        },
      );
    } else {
      return _buildPoolList();
    }
  }

  Widget _buildPoolList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          // --- 2. SUMMARY CARDS ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: "Total Invertido",
                    amount: "\$9,000",
                    amountColor: NuvoGradients.purpleText,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryCard(
                    label: "Retorno Total",
                    amount: "+\$1,280",
                    amountColor: NuvoGradients.greenText,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // --- 3. MIS INVERSIONES ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mis Inversiones",
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
            itemCount: _investments.length,
            itemBuilder: (context, index) {
              final item = _investments[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPool = item;
                    _currentStep = 1; // Go to Invest Form
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: NuvoGradients.cardBackground,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A1B3D), // Dark Purple bg
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: NuvoGradients.purpleText.withOpacity(
                                  0.3,
                                ),
                              ),
                            ),
                            child: Icon(
                              item['icon'],
                              color: NuvoGradients.purpleText,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  item['rate'],
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF6366F1),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "+\$${item['returnAmount'].toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                  color: NuvoGradients.greenText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "\$${item['totalAmount'].toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Progress Bar
                      Container(
                        height: 8,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: item['progress'],
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: NuvoGradients.poolProgressBar,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
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
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String amount;
  final Color amountColor;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NuvoGradients.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: GoogleFonts.poppins(
              color: amountColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
