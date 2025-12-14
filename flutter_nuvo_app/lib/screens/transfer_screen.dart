import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../theme/nuvo_gradients.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _destinatarioCtrl = TextEditingController();
  final _montoCtrl = TextEditingController();
  final _conceptoCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();

  final ApiService _api = ApiService();
  bool _isLoading = false;

  void _startTransfer() {
    if (_destinatarioCtrl.text.isEmpty || _montoCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Faltan datos obligatorios"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    // Abrir el diálogo de PIN
    _showPinDialog();
  }

  void _processTransfer() async {
    // Validar PIN (Simulado 1234)
    if (_pinCtrl.text != "1234") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("PIN Incorrecto"),
          backgroundColor: NuvoGradients.redText,
        ),
      );
      _pinCtrl.clear();
      return;
    }

    setState(() => _isLoading = true);
    Navigator.pop(context); // Cerrar diálogo de PIN

    // Llamada al API
    final amount = double.parse(_montoCtrl.text);
    final targetId = int.tryParse(_destinatarioCtrl.text) ?? 0;

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Usuario no identificado")),
        );
      }
      setState(() => _isLoading = false);
      return;
    }

    final success = await _api.transfer(userId, targetId, amount);

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        // Mostrar éxito y salir
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (c) => _buildSuccessDialog(c),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error en la transferencia"),
            backgroundColor: NuvoGradients.redText,
          ),
        );
      }
    }
  }

  void _showPinDialog() {
    _pinCtrl.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NuvoGradients.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          "Confirmar con PIN",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Ingresa tu clave de 4 dígitos",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pinCtrl,
              autofocus: true,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 8,
              ),
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                fillColor: NuvoGradients.blackBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                hintText: "••••",
                hintStyle: TextStyle(color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: NuvoGradients.actionSend,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: _processTransfer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "CONFIRMAR",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessDialog(BuildContext c) {
    return AlertDialog(
      backgroundColor: NuvoGradients.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
              color: NuvoGradients.greenText,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "¡Envío Exitoso!",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Has enviado \$${_montoCtrl.text} a ${_destinatarioCtrl.text}",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(c); // Cerrar diálogo
                Navigator.pop(context); // Cerrar pantalla de transferencia
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: NuvoGradients.blackBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                "LISTO",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "Enviar Dinero",
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

              Padding(
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
                      // INPUT DESTINATARIO
                      _buildLabel("Destinatario"),
                      _buildInput(
                        _destinatarioCtrl,
                        "Nombre o número de celular",
                        Icons.person_outline,
                      ),

                      const SizedBox(height: 20),

                      // INPUT MONTO
                      _buildLabel("Monto"),
                      _buildInput(
                        _montoCtrl,
                        "0.00",
                        Icons.attach_money,
                        isNumber: true,
                      ),

                      const SizedBox(height: 20),

                      // INPUT CONCEPTO
                      _buildLabel("Concepto (Opcional)"),
                      _buildInput(
                        _conceptoCtrl,
                        "¿Por qué envías este dinero?",
                        Icons.chat_bubble_outline,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 40),

                      // BOTÓN
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: NuvoGradients.actionSend,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _startTransfer,
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
                                      Icons.send_outlined,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "ENVIAR DINERO",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: NuvoGradients.blackBackground,
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade700),
        prefixIcon: maxLines == 1
            ? Icon(icon, color: Colors.grey)
            : null, // Icon only for single line
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}
