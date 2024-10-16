import 'package:aash_india/bloc/singleCoupon/single_coupon_bloc.dart';
import 'package:aash_india/bloc/singleCoupon/single_coupon_event.dart';
import 'package:aash_india/bloc/singleCoupon/single_coupon_state.dart';
import 'package:aash_india/utils/date_formatter.dart';
import 'package:aash_india/utils/hex_to_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CouponDetail extends StatefulWidget {
  final String id;

  const CouponDetail({super.key, required this.id});

  @override
  State<CouponDetail> createState() => _CouponDetailState();
}

class _CouponDetailState extends State<CouponDetail> {
  @override
  void initState() {
    BlocProvider.of<SingleCouponBloc>(context).add(GetCouponData(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupon Details'),
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
            final String colorHex = couponData['style']['color'];
            final bool isActive = couponData['active'];

            final String ownerFirstName = ownerData['firstname'];
            final String ownerLastName = ownerData['lastname'];
            final String phoneNumber = ownerData['phonenumber'];
            final String shopName = ownerData['shop_name'];
            final String shopCategory = ownerData['shop_category'];
            final String shopCity = ownerData['shop_city'];
            final String shopState = ownerData['shop_state'];
            final String shopPincode = ownerData['shop_pincode'];
            final String ownerGender = ownerData['gender'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        'https://img.freepik.com/premium-vector/professional-electronic-devices-graphic-design-vector-art_1138841-23139.jpg?w=360',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$discountPercentage% OFF',
                      style: TextStyle(
                        fontSize: 22,
                        color: hexToColor(colorHex),
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '$shopCity, $shopState, $shopPincode',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Contact Details',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.person,
                            size: 16, color: Colors.black54),
                        const SizedBox(width: 5),
                        Text(
                          '$ownerFirstName $ownerLastName ($ownerGender)',
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
                        Text(phoneNumber, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: isActive ? () {} : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hexToColor(colorHex),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text(
                          'Redeem Coupon',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(child: Text('Something went wrong!'));
        },
      ),
    );
  }
}
