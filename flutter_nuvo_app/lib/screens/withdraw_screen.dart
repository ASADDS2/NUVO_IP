import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../theme/nuvo_gradients.dart';
import 'dart:math';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  // Controladores
  final _amountCtrl = TextEditingController();
  final _confirmCodeCtrl = TextEditingController();

  // Estado
  int _step = 1; // 1: Monto, 2: Confirmación, 3: Código Cajero
  bool _isLoading = false;

  // Datos
  String _selectedAccount = "Cuenta Principal (**** 3210)";
  String? _securityToken; // El código que se muestra para confirmar
  String? _finalAtmCode; // El código final para el cajero

  final ApiService _api = ApiService();

  // Colores del Diseño
  final Color _inputColor = const Color(0xFF0A0C0D);
  final Color _accentOrange = const Color(
    0xFFD35400,
  ); // Naranja oscuro del botón
  final Color _textOrange = const Color(
    0xFFFF8C42,
  ); // Naranja brillante del texto

  // PASO 1 -> PASO 2
  void _goToConfirmation() {
    if (_amountCtrl.text.isEmpty) return;
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Monto inválido"),
          backgroundColor: NuvoGradients.redText,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simular generación de token de seguridad
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _securityToken = (100000 + Random().nextInt(900000)).toString();
        _isLoading = false;
        _step = 2; // Ir a la pantalla de confirmación
      });
    });
  }

  // PASO 2 -> PASO 3
  void _finalizeWithdraw() async {
    if (_confirmCodeCtrl.text != _securityToken) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Código incorrecto"),
          backgroundColor: NuvoGradients.redText,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Llamada real al API (si estuviera conectada para retiros)
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

    await _api.deposit(userId, -double.parse(_amountCtrl.text));

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _finalAtmCode = (100000 + Random().nextInt(900000))
          .toString(); // Código final
      _step = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          "Retirar Dinero",
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
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildCurrentStep(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    if (_step == 1) return _buildAmountForm();
    if (_step == 2) return _buildConfirmationStep();
    return _buildFinalCode();
  }

  // --- PASO 1: INGRESAR MONTO ---
  Widget _buildAmountForm() {
    return Container(
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
            "Monto a Retirar",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: NuvoGradients.blackBackground,
              prefixIcon: const Icon(Icons.attach_money, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              hintText: "0.00",
              hintStyle: TextStyle(color: Colors.grey.shade700),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Cuenta Origen",
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
              child: DropdownButton<String>(
                value: _selectedAccount,
                dropdownColor: NuvoGradients.cardBackground,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                isExpanded: true,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                items:
                    <String>[
                          'Cuenta Principal (**** 3210)',
                          'Ahorros (**** 5501)',
                        ]
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                onChanged: (newValue) =>
                    setState(() => _selectedAccount = newValue!),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Gradient Button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: NuvoGradients.actionWithdraw,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF97316).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _goToConfirmation,
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
                  : Text(
                      "CONTINUAR",
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
    );
  }

  // --- PASO 2: CONFIRMACIÓN DE SEGURIDAD ---
  Widget _buildConfirmationStep() {
    return Column(
      children: [
        Text(
          "Se ha generado un código de confirmación",
          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 24),

        // Caja del Código Generado
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _accentOrange, width: 1),
            boxShadow: [
              BoxShadow(
                color: _accentOrange.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                "Código de Confirmación",
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Text(
                _securityToken ?? "Error",
                style: GoogleFonts.robotoMono(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Monto en Naranja
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Monto a retirar: ",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
            ),
            Text(
              "\$${_amountCtrl.text}",
              style: GoogleFonts.poppins(
                color: _textOrange,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        // Input para confirmar
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Ingresa el código para confirmar",
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _confirmCodeCtrl,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 6,
          style: GoogleFonts.robotoMono(
            fontSize: 28,
            color: Colors.white,
            letterSpacing: 8,
          ),
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: _inputColor,
            hintText: "000000",
            hintStyle: TextStyle(color: Colors.grey.shade800, letterSpacing: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: _accentOrange),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
        ),

        const SizedBox(height: 40),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _finalizeWithdraw,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9A4618), // Naranja quemado
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "CONFIRMAR RETIRO",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // --- PASO 3: ÉXITO / CÓDIGO CAJERO ---
  Widget _buildFinalCode() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        const Icon(
          Icons.check_circle,
          color: NuvoGradients.greenText,
          size: 80,
        ),
        const SizedBox(height: 24),
        Text(
          "¡Retiro Autorizado!",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Usa este código en el cajero:",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
        ),

        const SizedBox(height: 40),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
          ),
          child: Text(
            _finalAtmCode ?? "----",
            style: GoogleFonts.robotoMono(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: NuvoGradients.greenText,
              letterSpacing: 6,
            ),
          ),
        ),

        const SizedBox(height: 60),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, true), // Cierra y retorna true
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "LISTO",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
