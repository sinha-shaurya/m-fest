import 'dart:convert';

import 'package:aash_india/bloc/coupons/coupon_event.dart';
import 'package:aash_india/bloc/coupons/coupon_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  CouponBloc() : super(CouponInitial()) {
    on<GetAllCoupons>(_fetchAllCoupons);
    on<CreateCouponEvent>(_onCreateCoupon);
  }

  final String baseUrl =
      dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:5000');

  Future<void> _fetchAllCoupons(
      GetAllCoupons event, Emitter<CouponState> emit) async {
    emit(CouponLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(CouponFailed('Unable to fetch coupons'));
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/coupon/getall'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        final List<Map<String, dynamic>> coupons =
            responseData.cast<Map<String, dynamic>>();
        if (responseData.isEmpty) {
          emit(CouponLoaded([]));
        } else {
          emit(CouponLoaded(coupons.reversed.toList()));
        }
      } else {
        emit(CouponFailed('Something went wrong'));
      }
    } catch (error) {
      emit(CouponFailed('Unknown error occurred.'));
    }
  }

  Future<void> _onCreateCoupon(
      CreateCouponEvent event, Emitter<CouponState> emit) async {
    emit(CouponLoading());

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(CouponFailed('Unable to create coupon'));
        return;
      }
      final validTillString = event.validTill.toIso8601String();
      final body = jsonEncode({
        'title': event.title,
        'category': event.category,
        'discountPercentage': event.discountPercentage,
        'validTill': validTillString,
        'style': {...event.style!},
        'active': event.active,
      });
      final response = await http.post(
        Uri.parse('$baseUrl/api/coupon/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: body,
      );
      if (response.statusCode == 201) {
        emit(CouponSuccess());
      } else {
        final errorData = jsonDecode(response.body);
        emit(CouponFailed(errorData['message'] ?? 'Failed to create coupon'));
      }
    } catch (error) {
      emit(CouponFailed('Unknown error occurred.'));
    }
  }
}
