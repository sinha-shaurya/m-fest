import 'dart:convert';
import 'package:aash_india/bloc/appdata/app_data_event.dart';
import 'package:aash_india/bloc/appdata/app_data_state.dart';
import 'package:aash_india/services/local_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class AppDataBloc extends Bloc<AppDataEvent, AppDataState> {
  AppDataBloc() : super(AppDataInitial()) {
    on<AppDataFetch>(_onDataFetch);
  }

  final LocalStorageService _localStorageService = LocalStorageService();

  Future<void> _onDataFetch(
      AppDataEvent event, Emitter<AppDataState> emit) async {
    emit(AppDataLoading());
    try {
      final response = await http.get(
        Uri.parse('${_localStorageService.getBaseUrl}/api/info'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final addressInfo = res['address'];
        emit(AppDataLoaded(addressInfo));
      } else {
        emit(AppDataError('Failed to fetch app data'));
      }
    } catch (error) {
      emit(AppDataError('Unknown error occurred.'));
    }
  }
}
