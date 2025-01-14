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
import 'package:aash_india/utils/format_phone_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

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
        backgroundColor: Color(0xFF386641),
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
            return const Center(
                child: CircularProgressIndicator(
              color: Color(0xFF386641),
            ));
          } else if (state is SingleCouponFailed) {
            return Center(child: Text(state.error));
          } else if (state is SingleCouponLoaded) {
            final couponData = state.couponData;
            final ownerData = state.ownerData;

            final String title = couponData['title'];
            final String category = couponData['category'].join(', ');
            final int discountPercentage = couponData['discountPercentage'];
            final DateTime validTill = DateTime.parse(couponData['validTill']);
            final String desc = couponData['description'];

            final String ownerFirstName = ownerData['firstname'];
            final String ownerLastName = ownerData['lastname'];
            final String phoneNumber = ownerData['phonenumber'];
            final String shopName = ownerData['shop_name'] ?? '';
            final String shopCategory = ownerData['shop_category'] ?? '';
            final String shopCity = ownerData['shop_city'] ?? '';
            final String shopState = ownerData['shop_state'] ?? '';
            final String shopPincode = ownerData['shop_pincode'] ?? '';

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
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF2E7D32),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.store,
                                color: Color(0xFF386641),
                                size: 40,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shopName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    shopCategory,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$shopCity, $shopState, $shopPincode',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Category: $category',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$discountPercentage% OFF',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFd32f2f),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 16, color: Color(0xFF2E7D32)),
                          const SizedBox(width: 8),
                          Text(
                            'Valid till: ${formatValidityDate(validTill)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        desc,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Contact Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.person,
                              size: 20, color: Color(0xFF386641)),
                          const SizedBox(width: 8),
                          Text(
                            '$ownerFirstName $ownerLastName',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.phone,
                              size: 20, color: Color(0xFF386641)),
                          const SizedBox(width: 8),
                          Text(
                            phoneNumber,
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
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
                                    if (couponState is! CouponLoading &&
                                        !couponData['redeemed']) {
                                      BlocProvider.of<CouponBloc>(context).add(
                                          AvailCouponEvent(couponData['_id']));
                                      BlocProvider.of<SingleCouponBloc>(context)
                                          .add(GetCouponData(widget.id));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: couponData['redeemed']
                                        ? Colors.grey.shade500
                                        : Color(0xFF386641),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40.0, vertical: 15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  child: couponState is CouponLoading
                                      ? const CircularProgressIndicator(
                                          color: Color(0xFF386641),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              couponData['redeemed']
                                                  ? 'Already Added'
                                                  : 'Add to Cart',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Icon(
                                              Icons.shopping_bag,
                                              color: Colors.white,
                                            ),
                                          ],
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
                                      Icon(
                                        Icons.send,
                                        color: Color(0xFF386641),
                                      ),
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

    Future<void> pickContact() async {
      if (await FlutterContacts.requestPermission()) {
        try {
          final contact = await FlutterContacts.openExternalPick();
          if (contact != null && contact.phones.isNotEmpty) {
            mobileNumberController.text =
                formatPhoneNumber(contact.phones.first.number);
          } else {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('No phone number found for the selected contact'),
              backgroundColor: Colors.red,
            ));
          }
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to pick a contact'),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Contacts permission denied'),
          backgroundColor: Colors.red,
        ));
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Transfer Coupon"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: mobileNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: "Mobile Number"),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.contacts, color: Color(0xFF386641)),
                    onPressed: pickContact,
                  ),
                ],
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
                    color: Color(0xFF386641),
                  );
                }
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF386641),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
