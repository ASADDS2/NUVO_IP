import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    // Detectar si es ingreso o egreso
    final double amount = (transaction['amount'] as num).toDouble();
    final bool isDeposit = amount > 0;

    // Colores del tema oscuro
    const greenColor = Color(0xFF8B5CF6); // Verde brillante
    const redColor = Color(0xFFFF4C4C); // Rojo brillante
    final highlightColor = isDeposit ? greenColor : redColor;
    final iconData = isDeposit ? Icons.south_west : Icons.north_east;

    return Scaffold(
      backgroundColor: Colors.transparent,
      // Fondo con gradiente oscuro (Purple to Black)
      body: Container(
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
        child: SafeArea(
          child: Column(
            children: [
              // AppBar custom
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Detalle de Movimiento",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Icono Grande Circular con brillo
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: highlightColor.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(iconData, color: highlightColor, size: 40),
                      ),

                      const SizedBox(height: 24),

                      // Tipo y Monto
                      Text(
                        transaction['type'].toString().toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "\$${amount.abs().toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: highlightColor,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Tarjeta de Detalles
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF121212,
                          ), // Fondo casi negro para la tarjeta
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        child: Column(
                          children: [
                            _DetailRow(
                              icon: Icons.person_outline,
                              label: "Destinatario/Origen",
                              value: "Usuario NUVO", // Dato simulado
                              subValue: "**** 4521",
                            ),
                            const Divider(color: Colors.white10, height: 32),
                            _DetailRow(
                              icon: Icons.calendar_today_outlined,
                              label: "Fecha y Hora",
                              value: transaction['date'] ?? "Hoy",
                              subValue: "14:32 PM", // Hora simulada
                            ),
                            const Divider(color: Colors.white10, height: 32),
                            _DetailRow(
                              icon: Icons.tag,
                              label: "Referencia",
                              value:
                                  "TRF-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}",
                            ),
                            const Divider(color: Colors.white10, height: 32),
                            _DetailRow(
                              icon: Icons.description_outlined,
                              label: "Descripción",
                              value:
                                  transaction['description'] ??
                                  "Movimiento bancario",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Botón Cerrar Grande
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: greenColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "CERRAR",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subValue;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Icon(icon, color: const Color(0xFF8B5CF6), size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (subValue != null)
                Text(
                  subValue!,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
