import 'package:aash_india/bloc/coupons/coupon_bloc.dart';
import 'package:aash_india/bloc/coupons/coupon_event.dart';
import 'package:aash_india/bloc/coupons/coupon_state.dart';
import 'package:aash_india/presentations/screens/coupon/qr_scanner.dart';
import 'package:aash_india/presentations/widgets/coupon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Coupons extends StatefulWidget {
  const Coupons({super.key});

  @override
  State<Coupons> createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    BlocProvider.of<CouponBloc>(context).add(GetAvailedCoupons());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupons'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Availed'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(
            onRefresh: () async =>
                BlocProvider.of<CouponBloc>(context).add(GetAvailedCoupons()),
            child: BlocBuilder<CouponBloc, CouponState>(
              builder: (context, state) {
                if (state is CouponLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CouponLoaded) {
                  final activeCoupons = state.coupons
                      .where((coupon) => coupon['status'] != 'EXPIRED')
                      .toList();
                  return buildCouponList(coupons: activeCoupons);
                } else if (state is CouponFailed) {
                  return Center(child: Text(state.error));
                } else {
                  return const Center(child: Text('No availed coupons found.'));
                }
              },
            ),
          ),
          RefreshIndicator(
            onRefresh: () async =>
                BlocProvider.of<CouponBloc>(context).add(GetAvailedCoupons()),
            child: BlocBuilder<CouponBloc, CouponState>(
              builder: (context, state) {
                if (state is CouponLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CouponLoaded) {
                  final expiredCoupons = state.coupons
                      .where((coupon) => coupon['status'] == 'EXPIRED')
                      .toList();
                  return buildCouponList(
                      coupons: expiredCoupons, expired: true);
                } else if (state is CouponFailed) {
                  return Center(child: Text(state.error));
                } else {
                  return const Center(child: Text('No coupons found.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCouponList(
      {required List<Map<String, dynamic>> coupons, bool expired = false}) {
    if (coupons.isEmpty) {
      return const Center(child: Text('No coupons available.'));
    }

    return ListView.builder(
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        var coupon = coupons[index];

        return CouponCard(
          onTap: () async {
            if (!expired && coupon['status'] == 'REDEEMED') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRScannerScreen(
                    couponId: coupon['couponId'],
                  ),
                ),
              );
            } else if (!expired && coupon['status'] == 'ACTIVE') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRScannerScreen(
                    couponId: coupon['couponId'],
                    end: coupon['totalPrice'] > 0,
                  ),
                ),
              );
            }
          },
          color: expired ? Colors.grey.shade600 : null,
          id: coupon['_id'],
          buttonTitle: coupon["status"] == "REDEEMED"
              ? "Scan"
              : "₹${coupon['totalPrice']}",
          title: coupon['title'],
          discountPercent: coupon['discountPercentage'],
          active: coupon['active'],
          validity: DateTime.parse(coupon['validTill']),
          price: coupon['price'] ?? 100,
        );
      },
    );
  }
}
