import 'dart:convert';
import 'dart:developer';

import 'package:aash_india/bloc/coupons/coupon_event.dart';
import 'package:aash_india/bloc/coupons/coupon_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  CouponBloc() : super(CouponInitial()) {
    on<GetAllCoupons>(_fetchAllCoupons);
    on<FilterCoupons>(_onFilterCoupons);
    on<AvailCouponEvent>(_onAvailCoupon);
    on<GetAvailedCoupons>(_onGetAvailedCoupons);
    on<CheckRedeem>(_onCheckRedeem);
    on<GetPartnerActiveCoupons>(_onPartnerActiveCouponFetch);
    on<UpdateCouponAmount>(_onUpdateCouponAmount);
    on<TransferCouponEvent>(_onTransferCoupon);
  }

  final String baseUrl =
      dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:5000');

  Future<List<String>> fetchCities() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/coupon/get-cities'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['cities'] != null) {
          return List<String>.from(data['cities']);
        } else {
          return [];
        }
      } else {
        throw Exception(
            'Failed to load cities. Status code: ${response.statusCode}');
      }
    } catch (error) {
      return Future.error('Error fetching cities');
    }
  }

  Future<void> _fetchAllCoupons(
      GetAllCoupons event, Emitter<CouponState> emit) async {
    emit(CouponLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final selectedCity = prefs.getString('selectedCity');
      final token = prefs.getString('token');
      if (event.city != null) {
        if (selectedCity == null || selectedCity != event.city) {
          await prefs.setString('selectedState', event.city!);
        }
      }
      final uri = Uri.parse('$baseUrl/api/coupon/getall?city=${event.city}&search=${event.search}');
      final response = await http.get(
        uri,
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
        final List<dynamic> availedCoupons =
            await jsonDecode(responseAvailed.body);
        List<Map<String, dynamic>> couponsList = [];
        if (availedCoupons.isNotEmpty) {
          couponsList = availedCoupons.map((coupon) {
            return Map<String, dynamic>.from(coupon);
          }).toList();
        } else {
          couponsList = [];
        }

        final response = await http.get(
          Uri.parse('$baseUrl/api/coupon/coupon-count'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        int couponCount = 0;
        if (response.statusCode == 200) {
          couponCount = jsonDecode(response.body)['couponCount'];
        }

        emit(CouponLoaded(couponsList, couponCount: couponCount));
      } else {
        emit(CouponFailed('Failed to fetch availed coupons.'));
      }
    } catch (error) {
      emit(CouponFailed('Unknown error occurred.'));
    }
  }

  Future<void> _onPartnerActiveCouponFetch(
      GetPartnerActiveCoupons event, Emitter<CouponState> emit) async {
    emit(CouponLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(CouponFailed('Unable to fetch coupons'));
        return;
      }

      final responseAvailed = await http.get(
        Uri.parse('$baseUrl/api/coupon/store-used-coupon'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (responseAvailed.statusCode == 200) {
        final List<dynamic> coupons = await jsonDecode(responseAvailed.body);

        final List<Map<String, dynamic>> couponList = coupons.map((coupon) {
          return {
            "consumerData": {
              "id": coupon["consumerData"]["id"],
              "firstname": coupon["consumerData"]["firstname"],
              "lastname": coupon["consumerData"]["lastname"],
              "gender": coupon["consumerData"]["gender"],
              "phonenumber": coupon["consumerData"]["phonenumber"],
              "city": coupon["consumerData"]["city"],
              "state": coupon["consumerData"]["state"],
              "pincode": coupon["consumerData"]["pincode"]
            },
            "couponDetail": coupon["couponDetail"].map((detail) {
              return {
                "couponId": detail["couponId"],
                "status": detail["status"],
                "totalPrice": detail["totalPrice"],
                "_id": detail["_id"],
                "dateAdded": detail["dateAdded"]
              };
            }).toList()
          };
        }).toList();
        emit(ManageCouponLoaded(couponList));
      } else {
        emit(CouponFailed('Failed to fetch availed coupons.'));
      }
    } catch (error) {
      emit(CouponFailed('Unknown error occurred.'));
    }
  }

  Future<void> _onTransferCoupon(
      TransferCouponEvent event, Emitter<CouponState> emit) async {
    emit(CouponLoading());

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(CouponFailed('Unable to transfer coupon'));
        return;
      }

      final body = jsonEncode({
        'phoneNumber': event.mobileNumber,
        'transferCount': event.count,
      });

      final response = await http.put(
        Uri.parse('$baseUrl/api/coupon/transfer-coupon-by-number'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        emit(CouponSuccess("successfully transferred."));
      } else if (response.statusCode == 400) {
        emit(CouponFailed('Insufficient coupon to transfer'));
      } else if (response.statusCode == 404) {
        emit(CouponFailed('No user found with this mobile number'));
      } else {
        emit(CouponFailed('Failed to transfer coupon'));
      }
    } catch (error) {
      emit(CouponFailed('Unknown error occurred during coupon transfer.'));
    } finally {
      await _fetchAllCoupons(GetAllCoupons(), emit);
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

  Future<void> _onUpdateCouponAmount(
      UpdateCouponAmount event, Emitter<CouponState> emit) async {
    emit(CouponLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(CouponFailed('Unable to update coupon amount'));
        return;
      }

      final body = jsonEncode({
        'consumerId': event.consumerId,
        'amount': event.amount,
      });

      final responseAvailed = await http.put(
        Uri.parse('$baseUrl/api/coupon/update-amount/${event.couponId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: body,
      );

      if (responseAvailed.statusCode == 200) {
        add(GetPartnerActiveCoupons());
        emit(CouponSuccess("Coupon amount updated."));
      } else {
        emit(CouponFailed('Failed to update coupon amount.'));
      }
    } catch (error) {
      emit(CouponFailed('Unknown error occurred during update.'));
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
      dynamic res = await jsonDecode(response.body);
      if (response.statusCode == 200) {
        emit(CouponSuccess('Coupon availed successfully.'));
      } else {
        emit(CouponFailed(res['message']));
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

        final selectedCity = prefs.getString('selectedCity');
        final uri = Uri.parse('$baseUrl/api/coupon/getall').replace(
            queryParameters: {'city': selectedCity});
        final response = await http.get(
          uri,
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
          log(response.statusCode.toString());
          log(response.toString());
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
}
