import 'package:aash_india/bloc/coupons/coupon_bloc.dart';
import 'package:aash_india/bloc/coupons/coupon_event.dart';
import 'package:aash_india/bloc/coupons/coupon_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageCoupons extends StatefulWidget {
  const ManageCoupons({super.key});

  @override
  State<ManageCoupons> createState() => _ManageCouponsState();
}

class _ManageCouponsState extends State<ManageCoupons>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    BlocProvider.of<CouponBloc>(context).add(GetPartnerActiveCoupons());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CouponBloc, CouponState>(
      listener: (context, state) {
        if (state is CouponFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            backgroundColor: AppColors.errorColor,
          ));
        } else if (state is CouponSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Added successfully"),
            backgroundColor: Colors.green,
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Coupons'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Live'),
              Tab(text: 'Unbilled'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            BlocBuilder<CouponBloc, CouponState>(
              builder: (context, state) {
                if (state is CouponLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ManageCouponLoaded) {
                  final activeCoupons = state.coupons
                      .where((coupon) =>
                          coupon['couponDetail'][0]['status'] == 'REDEEMED')
                      .toList();
                  return buildCouponList(coupons: activeCoupons);
                } else if (state is CouponFailed) {
                  return Center(child: Text(state.error));
                } else {
                  return const Center(child: Text('No coupons found.'));
                }
              },
            ),
            BlocBuilder<CouponBloc, CouponState>(
              builder: (context, state) {
                if (state is CouponLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ManageCouponLoaded) {
                  final unbilledCoupons = state.coupons
                      .where((coupon) =>
                          coupon['couponDetail'][0]['status'] == 'ACTIVE')
                      .toList();
                  return buildCouponList(coupons: unbilledCoupons);
                } else if (state is CouponFailed) {
                  return Center(child: Text(state.error));
                } else {
                  return const Center(child: Text('No coupons found.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCouponList({
    required List<Map<String, dynamic>> coupons,
  }) {
    if (coupons.isEmpty) {
      return const Center(child: Text('No coupons available.'));
    }

    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          var coupon = coupons[index];
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: ListTile(
              trailing: coupon['couponDetail'][0]['status'] == 'ACTIVE'
                  ? IconButton(
                      onPressed: () {
                        _showAddAmountDialog(
                            context,
                            coupon['couponDetail'][0]['_id'],
                            coupon['consumerData']['id']);
                      },
                      icon: const Icon(Icons.keyboard_double_arrow_right),
                    )
                  : const SizedBox(),
              title: Text(
                coupon['consumerData']['firstname'] +
                    " " +
                    (coupon['consumerData']['lastname'] ?? 'Unknown'),
              ),
              subtitle: Text(coupon['couponDetail'][0]['status'] == 'REDEEMED'
                  ? 'REDEEMED'
                  : "₹${coupon['couponDetail'][0]['totalPrice']}"),
            ),
          );
        },
      ),
    );
  }

  void _showAddAmountDialog(
      BuildContext context, String couponId, String consumerId) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Amount'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Amount"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String enteredAmount = amountController.text;

                // Dispatch UpdateCouponAmount event here
                context.read<CouponBloc>().add(
                      UpdateCouponAmount(
                        consumerId: consumerId,
                        couponId: couponId,
                        amount: double.parse(enteredAmount),
                      ),
                    );

                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
