import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../theme/nuvo_gradients.dart';
import '../widgets/pool_invest_form.dart';
import '../widgets/pool_dashboard.dart';
import '../models/pool_with_stats_model.dart';
import '../models/pool_model.dart';

class PoolScreen extends StatefulWidget {
  const PoolScreen({super.key});

  @override
  State<PoolScreen> createState() => _PoolScreenState();
}

class _PoolScreenState extends State<PoolScreen> {
  // 0: List, 1: Form, 2: Dashboard
  int _currentStep = 0;
  Pool? _selectedPool;
  bool _hasActiveInvestment = false;
  List<PoolWithStats> _availablePools = [];
  bool _isLoading = true;
  double _totalInvested = 0.0;
  double _totalReturn = 0.0;

  @override
  void initState() {
    super.initState();
    _loadPoolData();
  }

  void _loadPoolData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    final api = ApiService();
    try {
      // Fetch pools with statistics from backend
      final poolsData = await api.getAllPoolsWithStats();

      // Fetch user stats
      final stats = await api.getPoolStats(userId);

      // Check if user has active investments
      final investments = await api.getMyInvestments(userId);

      setState(() {
        _availablePools = poolsData
            .map((poolData) => PoolWithStats.fromJson(poolData))
            .where((poolWithStats) => poolWithStats.pool.active)
            .toList();

        _totalInvested = stats['totalInvested'] ?? 0.0;
        _totalReturn = stats['currentProfit'] ?? 0.0;
        _hasActiveInvestment = investments.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading pool data: $e");
      setState(() => _isLoading = false);
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar piscinas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _hasActiveInvestment ? 0 : 1,
      child: Scaffold(
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
          bottom: TabBar(
            indicatorColor: const Color(0xFF6366F1),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "Mis Inversiones"),
              Tab(text: "Piscinas"),
            ],
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
          child: _currentStep == 1 && _selectedPool != null
              ? PoolInvestForm(
                  pool: _selectedPool!,
                  onBack: () => setState(() => _currentStep = 0),
                  onInvestSuccess: () {
                    setState(() {
                      _hasActiveInvestment = true;
                      _currentStep = 0;
                      _loadPoolData(); // Reload data
                    });
                    // Switch to "Mis Inversiones" tab?
                    // DefaultTabController state is not easily accessible here without a key or controller.
                    // For now, reloading data and setting _hasActiveInvestment might be enough if we rebuild.
                    // But we are inside TabBarView... wait.
                    // If I show PoolInvestForm covering everything, it's fine.
                    // But better to have it inside the "Piscinas" tab or as a separate route.
                    // Given the current structure, I'll keep it simple:
                    // If investing, show form. If not, show Tabs.
                  },
                )
              : TabBarView(
                  children: [_buildMyInvestmentsTab(), _buildPoolsTab()],
                ),
        ),
      ),
    );
  }

  Widget _buildMyInvestmentsTab() {
    if (!_hasActiveInvestment) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.savings_outlined,
              size: 64,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "No tienes inversiones activas",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }
    return PoolDashboard(
      onWithdrawSuccess: () {
        setState(() {
          _hasActiveInvestment = false;
          _loadPoolData();
        });
      },
    );
  }

  Widget _buildPoolsTab() {
    return _buildPoolList();
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
                    amount: "\$${_totalInvested.toStringAsFixed(2)}",
                    amountColor: NuvoGradients.purpleText,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryCard(
                    label: "Retorno Total",
                    amount: "+\$${_totalReturn.toStringAsFixed(2)}",
                    amountColor: NuvoGradients.greenText,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // --- 3. PISCINAS DISPONIBLES ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Piscinas Disponibles",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          else if (_availablePools.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  "No hay piscinas disponibles",
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
          else
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _availablePools.length,
              itemBuilder: (context, index) {
                final poolWithStats = _availablePools[index];
                final pool = poolWithStats.pool;

                // Map pool to icon based on name or use default
                IconData poolIcon = Icons.verified_outlined;
                if (pool.name.toLowerCase().contains('plus')) {
                  poolIcon = Icons.trending_up;
                } else if (pool.name.toLowerCase().contains('gold')) {
                  poolIcon = Icons.bolt_outlined;
                } else if (pool.name.toLowerCase().contains('express')) {
                  poolIcon = Icons.gps_fixed;
                }

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPool = pool;
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
                                color: const Color(
                                  0xFF2A1B3D,
                                ), // Dark Purple bg
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: NuvoGradients.purpleText.withOpacity(
                                    0.3,
                                  ),
                                ),
                              ),
                              child: Icon(
                                poolIcon,
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
                                    pool.name,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "${pool.annualRate.toStringAsFixed(1)}% Anual",
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
                                  "${poolWithStats.currentInvestors}/${pool.maxParticipants}",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Inversores",
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
                            widthFactor: poolWithStats.progress,
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
