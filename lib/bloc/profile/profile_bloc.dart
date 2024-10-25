import 'dart:convert';
import 'package:aash_india/bloc/profile/profile_event.dart';
import 'package:aash_india/bloc/profile/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileFetchInfo>(_onProfileFetch);
    on<ProfileUpdateInfo>(_onProfileUpdate);
  }
  final String baseUrl =
      dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:5000');

  Future<void> _onProfileFetch(
      ProfileFetchInfo event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/api/auth/profile-data'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        if (response.statusCode == 200) {
          final res = jsonDecode(response.body);
          final userType = res['type'];
          if (userType == 'partner') {
            emit(ProfileFetched(
              id: res['_id'] ?? "",
              fname: res['data']['firstname'] ?? "",
              lname: res['data']['lastname'] ?? "",
              phone: res['data']['phonenumber'] ?? "",
              gender: res['data']['gender'] ?? "",
              city: res['data']['shop_city'] ?? "",
              state: res['data']['shop_state'] ?? "",
              pincode: res['data']['shop_pincode'] ?? "",
              shopName: res['data']['shop_name'] ?? "",
              shopCategory: res['data']['shop_category'] ?? "",
              type: 'partner',
            ));
          } else if (userType == 'customer') {
            emit(ProfileFetched(
              id: res['_id'] ?? "",
              fname: res['data']['firstname'] ?? "",
              lname: res['data']['lastname'] ?? "",
              phone: res['data']['phonenumber'] ?? "",
              gender: res['data']['gender'] ?? "",
              city: res['data']['city'] ?? "",
              state: res['data']['state'] ?? "",
              pincode: res['data']['pincode'] ?? "",
              type: 'customer',
            ));
          } else {
            emit(ProfileFailed('User type not recognized'));
          }
        } else {
          emit(ProfileFailed('Failed to fetch profile data'));
        }
      } else {
        emit(ProfileFailed('Not authenticated'));
      }
    } catch (error) {
      emit(ProfileFailed('Unknown error occurred.'));
    }
  }

  Future<void> _onProfileUpdate(
      ProfileUpdateInfo event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        final response = await http.put(
            Uri.parse('$baseUrl/api/auth/update-profile'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode({...event.data}));
        if (response.statusCode == 200) {
          final res = jsonDecode(response.body);
          final userType = res['type'];
          if (userType == 'partner') {
            emit(ProfileFetched(
              id: res['_id'] ?? "",
              fname: res['data']['firstname'] ?? "",
              lname: res['data']['lastname'] ?? "",
              phone: res['data']['phonenumber'] ?? "",
              gender: res['data']['gender'] ?? "",
              city: res['data']['shop_city'] ?? "",
              state: res['data']['shop_state'] ?? "",
              pincode: res['data']['shop_pincode'] ?? "",
              shopName: res['data']['shop_name'] ?? "",
              shopCategory: res['data']['shop_category'] ?? "",
              type: 'partner',
            ));
          } else if (userType == 'customer') {
            emit(ProfileFetched(
              id: res['_id'] ?? "",
              fname: res['data']['firstname'] ?? "",
              lname: res['data']['lastname'] ?? "",
              phone: res['data']['phonenumber'] ?? "",
              gender: res['data']['gender'] ?? "",
              city: res['data']['city'] ?? "",
              state: res['data']['state'] ?? "",
              pincode: res['data']['pincode'] ?? "",
              type: 'customer',
            ));
          } else {
            emit(ProfileFailed('User type not recognized'));
          }
        } else {
          emit(ProfileFailed('Failed to fetch profile data'));
        }
      } else {
        emit(ProfileFailed('Not authenticated'));
      }
    } catch (error) {
      emit(ProfileFailed('Unknown error occurred.'));
    }
  }
}
