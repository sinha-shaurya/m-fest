import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  SharedPreferences? _prefs;
  String? _token;
  String? _selectedCity;
  List<String>? _cities;
  String? _baseUrl;

  // initialization
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _token = _prefs?.getString('token');
    _selectedCity = _prefs?.getString('selectedCity');
    _baseUrl = dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:5000');
    await loadCities();
  }

  // Getters
  String? get getToken => _token;
  String? get getSelectedCity => _selectedCity;
  String? get getBaseUrl => _baseUrl;
  List<String>? get getCities => _cities;

  // Setters
  Future<void> setToken(String value) async {
    _token = value;
    await _prefs?.setString('token', value);
  }

  Future<void> setSelectedCity(String value) async {
    _selectedCity = value;
    await _prefs?.setString('selectedCity', value);
  }

  Future<void> removeToken() async {
    _token = null;
    await _prefs?.remove('token');
  }

  // static functions
  Future<void> loadCities() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/coupon/get-cities'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['cities'] != null) {
          _cities = List<String>.from(data['cities']);
        } else {
          _cities = [];
        }
      }
    } catch (error) {
      _cities = [];
    }
  }
}
