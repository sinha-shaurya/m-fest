import 'dart:convert';
import 'package:aash_india/bloc/profile/profile_event.dart';
import 'package:aash_india/bloc/profile/profile_state.dart';
import 'package:aash_india/services/local_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileFetchInfo>(_onProfileFetch);
    on<ProfileUpdateInfo>(_onProfileUpdate);
  }
  final LocalStorageService _localStorageService = LocalStorageService();

  Future<void> _onProfileFetch(
      ProfileFetchInfo event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      if (_localStorageService.getToken != null) {
        final response = await http.get(
          Uri.parse('${_localStorageService.getBaseUrl}/api/auth/profile-data'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_localStorageService.getToken}'
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
            final response = await http.get(
              Uri.parse(
                  '${_localStorageService.getBaseUrl}/api/coupon/coupon-count'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ${_localStorageService.getToken}'
              },
            );
            int couponCount = 0;
            if (response.statusCode == 200) {
              couponCount = jsonDecode(response.body)['couponCount'];
            }
            emit(ProfileFetched(
              id: res['_id'] ?? "",
              fname: res['data']['firstname'] ?? "",
              lname: res['data']['lastname'] ?? "",
              phone: res['data']['phonenumber'] ?? "",
              gender: res['data']['gender'] ?? "",
              coupons: couponCount.toString(),
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
        emit(ProfileFailed(''));
      }
    } catch (error) {
      emit(ProfileFailed(''));
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
            Uri.parse(
                '${_localStorageService.getBaseUrl}/api/auth/update-profile'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${_localStorageService.getToken}'
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
