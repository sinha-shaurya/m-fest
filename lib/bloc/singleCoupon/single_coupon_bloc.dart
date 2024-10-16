import 'dart:convert';

import 'package:aash_india/bloc/singleCoupon/single_coupon_event.dart';
import 'package:aash_india/bloc/singleCoupon/single_coupon_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SingleCouponBloc extends Bloc<SingleCouponEvent, SingleCouponState> {
  SingleCouponBloc() : super(SingleCouponInitial()) {
    on<GetCouponData>(_getSingleCoupon);
  }

  final String baseUrl =
      dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:5000');

  Future<void> _getSingleCoupon(
      GetCouponData event, Emitter<SingleCouponState> emit) async {
    emit(SingleCouponLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(SingleCouponFailed('Unable to fetch coupon'));
        return;
      }

      final couponResponse = await http.get(
        Uri.parse('$baseUrl/api/coupon/get/${event.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (couponResponse.statusCode == 200) {
        final couponData =
            jsonDecode(couponResponse.body) as Map<String, dynamic>;

        final String ownerId = couponData['ownerId'];

        final ownerResponse = await http.get(
          Uri.parse('$baseUrl/api/auth/getOwner/$ownerId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (ownerResponse.statusCode == 200) {
          final ownerData =
              jsonDecode(ownerResponse.body)['data'] as Map<String, dynamic>;
          emit(
              SingleCouponLoaded(couponData: couponData, ownerData: ownerData));
        } else {
          emit(SingleCouponFailed('Failed to fetch owner data'));
        }
      } else {
        emit(SingleCouponFailed('Failed to fetch coupon data'));
      }
    } catch (error) {
      emit(SingleCouponFailed('An unknown error occurred.'));
    }
  }
}
