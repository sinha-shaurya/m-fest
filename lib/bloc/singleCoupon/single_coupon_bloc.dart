import 'dart:convert';
import 'dart:developer';

import 'package:aash_india/bloc/singleCoupon/single_coupon_event.dart';
import 'package:aash_india/bloc/singleCoupon/single_coupon_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SingleCouponBloc extends Bloc<SingleCouponEvent, SingleCouponState> {
  SingleCouponBloc() : super(SingleCouponInitial()) {
    on<GetCouponData>(_getSingleCoupon);
    on<CouponScanEvent>(_onCouponScan);
  }

  final String baseUrl =
      dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:5000');

  Future<void> _onCouponScan(
      CouponScanEvent event, Emitter<SingleCouponState> emit) async {
    emit(SingleCouponLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(SingleCouponFailed('Unable to fetch coupon'));
        return;
      }
      final couponResponse = await http.put(
        Uri.parse('$baseUrl/api/coupon/update-state/${event.couponId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'partnerId': event.ownerId,
          'status': event.end ? 2 : 1,
        }),
      );
      log('coupon id: ${event.couponId}');
      log('owner id: ${event.ownerId}');
      if (couponResponse.statusCode == 200) {
        emit(ScanSuccess(
            event.end ? "Transaction completed" : "Coupon activated"));
      } else {
        emit(SingleCouponFailed('Invalid Partner'));
      }
    } catch (err) {
      emit(SingleCouponFailed('Something went wrong'));
    }
  }

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
        final Map<String, dynamic> couponData =
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
          final Map<String, dynamic> ownerData =
              jsonDecode(ownerResponse.body)['data'] as Map<String, dynamic>;

          final availedResponse = await http.get(
            Uri.parse('$baseUrl/api/coupon/availed'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );

          bool isRedeemed = false;

          if (availedResponse.statusCode == 200) {
            final List<dynamic> availedCoupons =
                jsonDecode(availedResponse.body);
            isRedeemed =
                availedCoupons.any((coupon) => coupon['couponId'] == event.id);
          }
          couponData['redeemed'] = isRedeemed;
          log(isRedeemed.toString());

          emit(SingleCouponLoaded(
            couponData: couponData,
            ownerData: ownerData,
          ));
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
