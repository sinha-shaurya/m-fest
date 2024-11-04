import 'dart:convert';
import 'package:aash_india/bloc/appdata/app_data_event.dart';
import 'package:aash_india/bloc/appdata/app_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AppDataBloc extends Bloc<AppDataEvent, AppDataState> {
  AppDataBloc() : super(AppDataInitial()) {
    on<AppDataFetch>(_onDataFetch);
  }

  final String baseUrl =
      dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:5000');

  Future<void> _onDataFetch(
      AppDataEvent event, Emitter<AppDataState> emit) async {
    emit(AppDataLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/api/info'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        if (response.statusCode == 200) {
          final res = jsonDecode(response.body);
          final addressInfo = res['address'];
          emit(AppDataLoaded(addressInfo));
        } else {
          emit(AppDataError('Failed to fetch app data'));
        }
      } else {
        emit(AppDataError('Something went wrong'));
      }
    } catch (error) {
      emit(AppDataError('Unknown error occurred.'));
    }
  }
}
