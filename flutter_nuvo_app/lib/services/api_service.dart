import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // --- ENDPOINTS ---
  static final String _authUrl = 'http://localhost:8091/api/v1/auth';
  final String _accountUrl = 'http://localhost:8082/api/v1/accounts';
  final String _transactionUrl = 'http://localhost:8086/api/v1/transactions';
  final String _loanUrl = 'http://localhost:8084/api/v1/loans';
  final String _poolUrl = 'http://localhost:8085/api/v1/pool';

  // --- AUTH ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_authUrl/authenticate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        // Guardar Token y User ID si vienen en la respuesta
        if (data['token'] != null) {
          await prefs.setString('token', data['token']);
        }
        // Save User ID if available, otherwise fetch it
        if (data['id'] != null) {
          await prefs.setInt('userId', data['id']);
        }

        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Credenciales incorrectas'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<Map<String, dynamic>> register(
    String firstname,
    String lastname,
    String email,
    String password,
    String phone,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_authUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'phone': phone,
          'password': password,
          'role': 'USER',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['id'] != null) {
          // Create Account
          try {
            await http.post(
              Uri.parse(_accountUrl),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'userId': data['id']}),
            );
          } catch (e) {
            print("Error creating account: $e");
            // We might want to warn the user, but registration was successful.
          }
        }
        return {'success': true};
      } else {
        return {
          'success': false,
          'message': 'Error en registro: ${response.body}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<int?> getUserIdByPhone(String phone) async {
    try {
      final response = await http.get(Uri.parse('$_authUrl/phone/$phone'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['id'];
      }
    } catch (e) {
      print("Error fetching user by phone: $e");
    }
    return null;
  }

  // --- ACCOUNT & TRANSACTIONS ---
  Future<Map<String, dynamic>> getAccountData(int userId) async {
    try {
      final response = await http.get(Uri.parse('$_accountUrl/$userId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'balance': data['balance'],
          'accountNumber': data['accountNumber'],
        };
      }
    } catch (e) {
      print("Error fetching account: $e");
    }
    return {'balance': 0.00, 'accountNumber': '****'};
  }

  Future<List<dynamic>> getHistory(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_transactionUrl/history/$userId'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Error fetching history: $e");
    }
    return [];
  }

  // --- ACTIONS ---
  Future<bool> deposit(int userId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$_transactionUrl/deposit?userId=$userId&amount=$amount'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error depositing: $e");
      return false;
    }
  }

  Future<bool> transfer(
    int sourceUserId,
    int targetUserId,
    double amount,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_transactionUrl/transfer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sourceUserId': sourceUserId,
          'targetUserId': targetUserId,
          'amount': amount,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error transferring: $e");
      return false;
    }
  }

  // --- LOANS ---
  Future<bool> requestLoan(int userId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse(_loanUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'amount': amount,
          'termMonths': 12, // Default or passed as argument
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error requesting loan: $e");
      return false;
    }
  }

  Future<List<dynamic>> getMyLoans(int userId) async {
    try {
      final response = await http.get(Uri.parse('$_loanUrl/my-loans/$userId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Error fetching my loans: $e");
    }
    return [];
  }

  Future<bool> payLoan(int loanId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$_loanUrl/$loanId/pay?amount=$amount'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error paying loan: $e");
      return false;
    }
  }

  // --- POOL ---
  final String _poolsUrl = 'http://localhost:8085/api/v1/pools';

  // Get all active pools
  Future<List<dynamic>> getActivePools() async {
    try {
      final response = await http.get(Uri.parse('$_poolsUrl/active'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Error fetching active pools: $e");
    }
    return [];
  }

  // Get all pools with statistics
  Future<List<dynamic>> getAllPoolsWithStats() async {
    try {
      final response = await http.get(Uri.parse(_poolsUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Error fetching pools with stats: $e");
    }
    return [];
  }

  // Invest in a specific pool
  Future<bool> investInPool(int userId, int poolId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$_poolUrl/invest'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'poolId': poolId,
          'amount': amount,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error investing in pool: $e");
      return false;
    }
  }

  // Get user's investments
  Future<List<dynamic>> getMyInvestments(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_poolUrl/my-investments/$userId'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print("Error fetching my investments: $e");
    }
    return [];
  }

  // Withdraw from pool
  Future<bool> withdrawFromPool(int investmentId) async {
    try {
      final response = await http.post(
        Uri.parse('$_poolUrl/withdraw/$investmentId'),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error withdrawing from pool: $e");
      return false;
    }
  }

  // Legacy invest method - kept for backward compatibility
  Future<bool> invest(int userId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$_poolUrl/invest'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'amount': amount}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error investing: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> getPoolStats(int userId) async {
    try {
      final response = await http.get(Uri.parse('$_poolUrl/stats/$userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'totalInvested': (data['totalInvested'] is num)
              ? (data['totalInvested'] as num).toDouble()
              : 0.0,
          'currentProfit': (data['currentProfit'] is num)
              ? (data['currentProfit'] as num).toDouble()
              : 0.0,
          'totalProjected': (data['totalProjected'] is num)
              ? (data['totalProjected'] as num).toDouble()
              : 0.0,
        };
      }
    } catch (e) {
      print("Error fetching pool stats: $e");
    }
    return {'totalInvested': 0.0, 'currentProfit': 0.0, 'totalProjected': 0.0};
  }
}
