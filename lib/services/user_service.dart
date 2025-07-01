import 'dart:convert';
import 'dart:convert' show base64Encode, utf8;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../config/api_config.dart';

class UserService {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _apiKeyKey = 'api_key';
  static const String _baseUrl = 'https://thegoexpress.com';
  static const String _loginEndpoint = '/api/app_login';
  static const String _empCodeKey = 'emp_code';
  static const String _empNameKey = 'emp_name';
  static const String _stationNameKey = 'station_name';
  static const String _userInfoKey = 'user_info';
  
  // Hardcoded API key - in production, this should be stored securely
  // Replace this with your actual Go Express API key
  // You can get this from your Go Express account or contact their support
  // static const String _apiKey = 'go_express_api_key_2024';

  // Save user data to SharedPreferences
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Save API key to SharedPreferences
  static Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey);
  }

  // Get API key from SharedPreferences
  static Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey);
  }

  // Get user data from SharedPreferences
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  // Validate login credentials with API
  static Future<bool> validateLoginWithAPI(String email, String password) async {
    final url = Uri.parse('https://thegoexpress.com/api/app_login');
    try {
      // Debug print for the Authorization header
      print('Authorization Header: $email:$password');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APIConfig.apiKey,
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        
        // Check if the API returned an error response
        if (json['status'] == 0 || json['data'] == null) {
          print('Login failed: ${json['message'] ?? 'Invalid credentials'}');
          return false;
        }
        
        // Check if the response indicates successful authentication
        if (json['status'] == 1 &&
            json['data'] != null &&
            json['data']['response'] == 200 &&
            json['data']['body'] is List &&
            json['data']['body'].isNotEmpty) {
          
          final user = json['data']['body'][0];
          
          final empCode = user['emp_code'] ?? '';
          final empName = user['emp_name'] ?? '';
          final stationName = user['station_name'] ?? '';

          // Store in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('emp_code', empCode);
          await prefs.setString('emp_name', empName);
          await prefs.setString('station_name', stationName);
          await prefs.setString('user_info', jsonEncode(user));
          await prefs.setBool('is_logged_in', true);
          // Save logged in name and password
          await prefs.setString('logged_in_name', empName);
          await prefs.setString('logged_in_password', password);
          return true;
        } else {
          print('Login failed: ${json['data']?['message'] ?? 'Unknown error'}');
          return false;
        }
      } else {
        print('HTTP error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception during login: $e');
      return false;
    }
  }

  // Get user info from SharedPreferences
  static Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'emp_code': prefs.getString(_empCodeKey),
      'emp_name': prefs.getString(_empNameKey),
      'station_name': prefs.getString(_stationNameKey),
    };
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Logout user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Validate login credentials (legacy method)
  static Future<bool> validateLogin(String email, String password) async {
    final user = await getUser();
    if (user != null) {
      return user.email == email && user.password == password;
    }
    return false;
  }

  // Alternative method: Validate login with API key and credential validation
  static Future<bool> validateLoginWithAPIKey(String email, String password) async {
    final url = Uri.parse('https://thegoexpress.com/api/app_login');
    try {
      // Debug print for the Authorization header
      print('Authorization Header: $email:$password');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APIConfig.apiKey,
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'validate_credentials': true, // Flag to indicate credential validation is required
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        
        // Check for authentication failure
        if (json['status'] == 0 || json['data'] == null) {
          print('Login failed: ${json['message'] ?? 'Invalid credentials'}');
          return false;
        }
        
        // Check if the response indicates successful authentication
        if (json['status'] == 1 &&
            json['data'] != null &&
            json['data']['response'] == 200 &&
            json['data']['body'] is List &&
            json['data']['body'].isNotEmpty) {
          
          final user = json['data']['body'][0];
          
          // Validate that the returned user data is legitimate
          final empCode = user['emp_code'] ?? '';
          final empName = user['emp_name'] ?? '';
          final stationName = user['station_name'] ?? '';
          
          // Additional validation: ensure we have valid user data
          if (empCode.isEmpty || empName.isEmpty) {
            print('Invalid user data returned');
            return false;
          }

          // Store in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('emp_code', empCode);
          await prefs.setString('emp_name', empName);
          await prefs.setString('station_name', stationName);
          await prefs.setString('user_info', jsonEncode(user));
          await prefs.setBool('is_logged_in', true);
          // Save logged in name and password
          await prefs.setString('logged_in_name', empName);
          await prefs.setString('logged_in_password', password);
          return true;
        } else {
          print('Login failed: ${json['data']?['message'] ?? 'Unknown error'}');
          return false;
        }
      } else {
        print('HTTP error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception during login: $e');
      return false;
    }
  }
} 