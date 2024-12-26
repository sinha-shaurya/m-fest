import 'package:aash_india/bloc/coupons/coupon_bloc.dart';
import 'package:aash_india/bloc/coupons/coupon_event.dart';
import 'package:aash_india/bloc/coupons/coupon_state.dart';
import 'package:aash_india/bloc/singleCoupon/single_coupon_bloc.dart';
import 'package:aash_india/bloc/singleCoupon/single_coupon_event.dart';
import 'package:aash_india/bloc/singleCoupon/single_coupon_state.dart';
import 'package:aash_india/core/constants/theme.dart';
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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey2 =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    BlocProvider.of<CouponBloc>(context).add(GetAvailedCoupons());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SingleCouponBloc, SingleCouponState>(
      listener: (context, state) {
        if (state is ScanSuccess) {
          BlocProvider.of<CouponBloc>(context).add(GetAvailedCoupons());
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: Colors.green,
          ));
        }
        if (state is SingleCouponFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: AppColors.errorColor,
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Coupons'),
          bottom: TabBar(
            labelColor: Color(0xFF344e41),
            indicatorColor: Color(0xFF344e41),
            controller: _tabController,
            tabs: const [
              Tab(text: 'Available'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            RefreshIndicator(
              key: _refreshIndicatorKey1,
              onRefresh: () async =>
                  BlocProvider.of<CouponBloc>(context).add(GetAvailedCoupons()),
              child: BlocBuilder<CouponBloc, CouponState>(
                builder: (context, state) {
                  if (state is CouponLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Color(0xFF344e41),
                    ));
                  } else if (state is CouponLoaded) {
                    final activeCoupons = state.coupons
                        .where((coupon) => coupon['status'] != 'EXPIRED')
                        .toList();
                    return Column(
                      children: [
                        SizedBox(height: 6),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 0.25, color: Colors.transparent),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.card_giftcard,
                                color: Color(0xFF344e41)),
                            title: Text(
                              'Available Coupons',
                              style: TextStyle(fontSize: 14),
                            ),
                            trailing: Text(
                              state.couponCount.toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        buildCouponList(coupons: activeCoupons),
                      ],
                    );
                  } else if (state is CouponFailed) {
                    return Center(child: Text(state.error));
                  } else {
                    return const Center(
                        child: Text('No availed coupons found.'));
                  }
                },
              ),
            ),
            RefreshIndicator(
              key: _refreshIndicatorKey2,
              onRefresh: () async =>
                  BlocProvider.of<CouponBloc>(context).add(GetAvailedCoupons()),
              child: BlocBuilder<CouponBloc, CouponState>(
                builder: (context, state) {
                  if (state is CouponLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Color(0xFF344e41),
                    ));
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
      ),
    );
  }

  Widget buildCouponList(
      {required List<Map<String, dynamic>> coupons, bool expired = false}) {
    if (coupons.isEmpty) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            const Text('No coupons available.'),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        var coupon = coupons[index];

        return CouponCard(
          onCancel: () async {
            BlocProvider.of<SingleCouponBloc>(context)
                .add(CouponRemoveEvent(coupon['_id'], coupon['ownerId']));
            await Future.delayed(Duration(seconds: 2));
            if (expired) {
              _refreshIndicatorKey2.currentState?.show();
            } else {
              _refreshIndicatorKey1.currentState?.show();
            }
          },
          onTap: () async {
            if (!expired && coupon['status'] == 'REDEEMED') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRScannerScreen(
                    couponId: coupon['_id'],
                  ),
                ),
              );
            } else if (!expired && coupon['status'] == 'ACTIVE') {
              if (coupon['totalPrice'] <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'waiting for shop owner to update amount.',
                    style: TextStyle(color: Colors.black87),
                  ),
                  backgroundColor: AppColors.accentColor,
                ));
                return;
              }
              BlocProvider.of<SingleCouponBloc>(context).add(CouponScanEvent(
                  coupon['_id'], coupon['ownerId'], coupon['totalPrice'] > 0));
            }
          },
          color: expired ? Colors.grey.shade600 : null,
          id: coupon['_id'],
          buttonTitle: coupon["status"] == "REDEEMED"
              ? "Scan"
              : coupon["status"] == "EXPIRED"
                  ? "Paid ₹${coupon['totalPrice']}"
                  : "Pay ₹${coupon['totalPrice']}",
          title: coupon['title'],
          category: coupon['category'][0],
          address: coupon['ownerAddress'],
          discountPercent: coupon['discountPercentage'],
          active: coupon['active'],
          validity: DateTime.parse(coupon['validTill']),
          price: coupon['price'] ?? 100,
        );
      },
    );
  }
}
