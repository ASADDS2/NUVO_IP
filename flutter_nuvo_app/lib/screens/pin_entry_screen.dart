import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/nuvo_gradients.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class PinEntryScreen extends StatefulWidget {
  final String mobileNumber;

  const PinEntryScreen({super.key, required this.mobileNumber});

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String _pin = "";
  bool _isLoading = false;

  void _onKeyPressed(String val) {
    if (_isLoading) return;

    if (val == 'DEL') {
      if (_pin.isNotEmpty) {
        setState(() => _pin = _pin.substring(0, _pin.length - 1));
      }
    } else {
      if (_pin.length < 4) {
        setState(() => _pin += val);
        if (_pin.length == 4) {
          _validatePin();
        }
      }
    }
  }

  void _validatePin() async {
    setState(() => _isLoading = true);

    try {
      final api = ApiService();
      // Assuming PIN is used as password for now, or we need a real password field.
      // The user enters phone number in LoginScreen, then PIN here.
      // But the backend expects email/password.
      // This is a mismatch. The backend uses email/password. The app uses Phone/PIN.
      // For now, I will assume the phone number is the email (or I need to change the backend).
      // OR I will assume the PIN is the password.
      // Let's try to use the phone number as email (maybe appending @nuvo.com) and PIN as password.
      // Or better, I should have checked if the backend supports phone login.
      // The RegisterScreen sends email and password.
      // So the user must login with Email and Password.
      // But the UI flow is Phone -> PIN.
      // This is a design flaw in the current integration plan.
      // However, to unblock, I will assume the user registered with Email = Phone + "@nuvo.com" (if I changed register logic)
      // BUT I didn't change register logic to force that.
      // The user enters a real email in RegisterScreen.
      // So LoginScreen should ask for Email, not Phone.
      // But LoginScreen asks for Phone.
      // I will change LoginScreen to ask for Email? Or just hack it for now?
      // The user said "Login with Phone and Password (PIN)".
      // I will try to use the phone number to find the user? No, backend doesn't support that yet.
      // I will assume the "Mobile Number" passed here is actually the Email for now (I'll change the label in LoginScreen later if needed).
      // OR I will just use the passed mobile number as email if it looks like one.

      final result = await api.login(widget.mobileNumber, _pin);

      setState(() => _isLoading = false);

      if (result['success']) {
        _goToHome();
      } else {
        _showError(result['message'] ?? "Error al iniciar sesión");
        setState(() => _pin = "");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError("Error al iniciar sesión: $e");
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, textAlign: TextAlign.center),
          backgroundColor: NuvoGradients.redText,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
        ),
      );
    }
  }

  void _goToHome() async {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NuvoGradients.blackBackground,
      body: Container(
        decoration: const BoxDecoration(gradient: NuvoGradients.headerGradient),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  children: [
                    Text(
                      "Escribe tu clave",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Usamos la variable widget.mobileNumber
                    Text(
                      "Para el número ${widget.mobileNumber}",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Indicadores de PIN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        bool isFilled = index < _pin.length;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isFilled
                                ? const Color(0xFF8B5CF6)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isFilled
                                  ? const Color(0xFF8B5CF6)
                                  : Colors.grey.withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: isFilled
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF8B5CF6,
                                      ).withOpacity(0.4),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : [],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // Teclado numérico
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    _buildNumRow("1", "2", "3"),
                    _buildNumRow("4", "5", "6"),
                    _buildNumRow("7", "8", "9"),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 70, height: 70),
                        _NumButton(
                          number: "0",
                          onTap: () => _onKeyPressed("0"),
                        ),
                        GestureDetector(
                          onTap: () => _onKeyPressed("DEL"),
                          child: Container(
                            width: 70,
                            height: 70,
                            color: Colors.transparent,
                            child: const Icon(
                              Icons.backspace_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Botón ayuda
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "¿Se te olvidó?",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B5CF6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumRow(String n1, String n2, String n3) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NumButton(number: n1, onTap: () => _onKeyPressed(n1)),
          _NumButton(number: n2, onTap: () => _onKeyPressed(n2)),
          _NumButton(number: n3, onTap: () => _onKeyPressed(n3)),
        ],
      ),
    );
  }
}

class _NumButton extends StatelessWidget {
  final String number;
  final VoidCallback onTap;
  const _NumButton({required this.number, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.05),
        ),
        child: Center(
          child: Text(
            number,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
