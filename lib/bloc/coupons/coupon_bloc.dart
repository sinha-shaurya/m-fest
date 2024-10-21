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
    on<FilterCoupons>(_onFilterCoupons);
    on<AvailCouponEvent>(_onAvailCoupon);
    on<GetAvailedCoupons>(_onGetAvailedCoupons);
    on<CheckRedeem>(_onCheckRedeem);
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

  Future<void> _onGetAvailedCoupons(
      GetAvailedCoupons event, Emitter<CouponState> emit) async {
    emit(CouponLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(CouponFailed('Unable to fetch coupons'));
        return;
      }

      final responseAvailed = await http.get(
        Uri.parse('$baseUrl/api/coupon/availed'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (responseAvailed.statusCode == 200) {
        final List<dynamic> availedCouponIds =
            await jsonDecode(responseAvailed.body);
        final availableIds =
            availedCouponIds.map((coupon) => coupon['consumerId']);
        if (availedCouponIds.isEmpty) {
          emit(CouponLoaded([]));
          return;
        }

        if (state is CouponLoaded) {
          final allCoupons = (state as CouponLoaded).coupons;
          final availedCoupons = allCoupons
              .where((coupon) => availableIds.contains(coupon['_id']))
              .toList();
          emit(CouponLoaded(availedCoupons));
        } else {
          final responseAll = await http.get(
            Uri.parse('$baseUrl/api/coupon/getall'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
          );

          if (responseAll.statusCode == 200) {
            final List<dynamic> responseData = jsonDecode(responseAll.body);
            final List<Map<String, dynamic>> allCoupons =
                responseData.cast<Map<String, dynamic>>();
            final availedCoupons = allCoupons
                .where((coupon) => availableIds.contains(coupon['_id']))
                .toList();
            emit(CouponLoaded(availedCoupons));
          } else {
            emit(CouponFailed('Failed to fetch all coupons.'));
          }
        }
      } else {
        emit(CouponFailed('Failed to fetch availed coupons.'));
      }
    } catch (error) {
      emit(CouponFailed('Unknown error occurred.'));
    }
  }

  Future<void> _onCheckRedeem(
      CheckRedeem event, Emitter<CouponState> emit) async {
    emit(CouponLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(CouponFailed('Unable to fetch coupons'));
        return;
      }

      final responseAvailed = await http.get(
        Uri.parse('$baseUrl/api/coupon/availed'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (responseAvailed.statusCode == 200) {
        final List<dynamic> availedCouponIds = jsonDecode(responseAvailed.body);

        if (availedCouponIds.contains(event.id)) {
          emit(CouponRedeemed());
          return;
        }
      } else {
        emit(CouponFailed('Failed to fetch availed coupons.'));
        return;
      }
    } catch (error) {
      emit(CouponFailed('Unknown error occurred.'));
    }
  }

  Future<void> _onAvailCoupon(
      AvailCouponEvent event, Emitter<CouponState> emit) async {
    emit(CouponLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(CouponFailed('Unable to fetch coupons'));
        return;
      }
      final response = await http.put(
        Uri.parse('$baseUrl/api/coupon/avail/${event.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        emit(CouponSuccess());
      } else {
        emit(CouponFailed('Something went wrong'));
      }
    } catch (error) {
      emit(CouponFailed('Unknown error occurred.'));
    }
  }

  Future<void> _onFilterCoupons(
      FilterCoupons event, Emitter<CouponState> emit) async {
    emit(CouponLoading());

    try {
      List<Map<String, dynamic>> coupons = [];

      if (state is CouponLoaded && event.category != 'All') {
        coupons = (state as CouponLoaded).coupons;
      } else {
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
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> responseData = jsonDecode(response.body);
          coupons = responseData.cast<Map<String, dynamic>>();

          if (coupons.isEmpty) {
            emit(CouponLoaded([]));
            return;
          }
        } else {
          emit(CouponFailed('Something went wrong'));
          return;
        }
      }

      final filteredCoupons = coupons.where((coupon) {
        return coupon['category'][0] == event.category;
      }).toList();

      emit(CouponLoaded(event.category == 'All' ? coupons : filteredCoupons));
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
