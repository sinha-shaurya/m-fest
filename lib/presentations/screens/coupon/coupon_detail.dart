import 'package:aash_india/bloc/coupons/coupon_bloc.dart';
import 'package:aash_india/bloc/coupons/coupon_event.dart';
import 'package:aash_india/bloc/coupons/coupon_state.dart';
import 'package:aash_india/bloc/profile/profile_bloc.dart';
import 'package:aash_india/bloc/profile/profile_state.dart';
import 'package:aash_india/bloc/singleCoupon/single_coupon_bloc.dart';
import 'package:aash_india/bloc/singleCoupon/single_coupon_event.dart';
import 'package:aash_india/bloc/singleCoupon/single_coupon_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/utils/date_formatter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponDetail extends StatefulWidget {
  final String id;

  const CouponDetail({super.key, required this.id});

  @override
  State<CouponDetail> createState() => _CouponDetailState();
}

class _CouponDetailState extends State<CouponDetail> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SingleCouponBloc>(context).add(GetCouponData(widget.id));
  }

  @override
  void dispose() {
    Future.microtask(() async {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      String? city = pref.getString('selectedCity');
      if (mounted) {
        BlocProvider.of<CouponBloc>(context).add(GetAllCoupons(city: city));
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Coupon Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<SingleCouponBloc, SingleCouponState>(
        builder: (context, state) {
          if (state is SingleCouponLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SingleCouponFailed) {
            return Center(child: Text(state.error));
          } else if (state is SingleCouponLoaded) {
            final couponData = state.couponData;
            final ownerData = state.ownerData;

            final String title = couponData['title'];
            final String category = couponData['category'].join(', ');
            final int discountPercentage = couponData['discountPercentage'];
            final DateTime validTill = DateTime.parse(couponData['validTill']);

            final String ownerFirstName = ownerData['firstname'];
            final String ownerLastName = ownerData['lastname'];
            final String phoneNumber = ownerData['phonenumber'];
            final String shopName = ownerData['shop_name'];
            final String shopCategory = ownerData['shop_category'];
            final String shopCity = ownerData['shop_city'];
            final String shopState = ownerData['shop_state'];
            final String shopPincode = ownerData['shop_pincode'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: RefreshIndicator(
                onRefresh: () async =>
                    BlocProvider.of<SingleCouponBloc>(context)
                        .add(GetCouponData(widget.id)),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://img.freepik.com/premium-vector/professional-electronic-devices-graphic-design-vector-art_1138841-23139.jpg?w=360',
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 150,
                            color: Colors.grey.shade300,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 150,
                            color: Colors.grey.shade300,
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Category: $category',
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black54),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$discountPercentage% OFF',
                        style: TextStyle(
                          fontSize: 22,
                          // color: hexToColor(colorHex),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: Colors.black54),
                          const SizedBox(width: 5),
                          Text(
                            'Valid till: ${formatValidityDate(validTill)}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const Text(
                        'Shop Details',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        shopName,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        shopCategory,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$shopCity, $shopState, $shopPincode',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Contact Details',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.person,
                              size: 16, color: Colors.black54),
                          const SizedBox(width: 5),
                          Text(
                            '$ownerFirstName $ownerLastName',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.phone,
                              size: 16, color: Colors.black54),
                          const SizedBox(width: 5),
                          Text(phoneNumber,
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          if (state is ProfileFetched) {
                            if (state.type == 'customer') {
                              var couponState =
                                  BlocProvider.of<CouponBloc>(context).state;

                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (couponState is! CouponLoading) {
                                      BlocProvider.of<CouponBloc>(context).add(
                                          AvailCouponEvent(couponData['_id']));
                                      BlocProvider.of<SingleCouponBloc>(context)
                                          .add(GetCouponData(widget.id));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: couponData['redeemed']
                                        ? Colors.grey.shade400
                                        : AppColors.primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40.0, vertical: 15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  child: couponState is CouponLoading
                                      ? const CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        )
                                      : Text(
                                          couponData['redeemed']
                                              ? 'Already availed'
                                              : 'Redeem',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: couponData['redeemed']
                                                ? Colors.grey.shade800
                                                : Colors.white,
                                          ),
                                        ),
                                ),
                              );
                            }
                          }
                          return SizedBox();
                        },
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          if (state is ProfileFetched) {
                            if (state.type == 'customer') {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => showTransferDialog(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40.0, vertical: 15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Transfer Coupon',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Icon(Icons.send),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }
                          return SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const Center(child: Text('Something went wrong!'));
        },
      ),
    );
  }

  void showTransferDialog(BuildContext context) {
    TextEditingController mobileNumberController = TextEditingController();
    int count = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Transfer Coupon"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: mobileNumberController,
                decoration: InputDecoration(labelText: "Mobile Number"),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (count > 1) {
                        count--;
                        (context as Element).markNeedsBuild();
                      }
                    },
                  ),
                  Text(count.toString(), style: TextStyle(fontSize: 18)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      count++;
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            BlocBuilder<CouponBloc, CouponState>(
              builder: (context, state) {
                if (state is CouponLoading) {
                  return CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  );
                }
                return ElevatedButton(
                  onPressed: () {
                    final phoneRegex = RegExp(r'^[6-9][0-9]{9}$');
                    if (!phoneRegex
                            .hasMatch(mobileNumberController.text.trim()) ||
                        mobileNumberController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Invalid phone number'),
                        backgroundColor: AppColors.errorColor,
                      ));
                      return;
                    }
                    if (count < 1) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Invalid data'),
                        backgroundColor: AppColors.errorColor,
                      ));
                      return;
                    }
                    BlocProvider.of<CouponBloc>(context).add(
                        TransferCouponEvent(
                            mobileNumber: mobileNumberController.text,
                            count: count));
                    Navigator.of(context).pop();
                    return;
                  },
                  child: Text("Transfer"),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
