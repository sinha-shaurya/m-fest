import 'package:aash_india/presentations/widgets/coupon_card.dart';
import 'package:aash_india/utils/hex_to_color.dart';
import 'package:flutter/material.dart';

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
  }

  // Mock coupon data
  List<Map<String, dynamic>> coupons = [
    {
      'title': 'Electronics Discount',
      'discountPercentage': 20,
      'active': true,
      'description': 'Get 20% off on electronics',
      'validTill': '2024-12-31',
      'price': 100,
      'style': {
        'color': '#FF5733',
      },
    },
    {
      'title': 'Grocery Offer',
      'discountPercentage': 10,
      'active': false,
      'description': '10% off on your grocery shopping',
      'validTill': '2023-10-01',
      'price': 200,
      'style': {
        'color': '#33FF57',
      },
    },
    {
      'title': 'Clothing Sale',
      'discountPercentage': 50,
      'active': true,
      'description': 'Buy 1 get 1 free on clothing',
      'validTill': '2024-11-15',
      'price': 300,
      'style': {
        'color': '#3357FF',
      },
    },
    {
      'title': 'Expired Gadget Sale',
      'discountPercentage': 15,
      'active': false,
      'description': '15% off on gadgets',
      'validTill': '2023-08-10',
      'price': 150,
      'style': {
        'color': '#FF33A1',
      },
    },
  ];

  List<Map<String, dynamic>> getFilteredCoupons(bool isActive) {
    return coupons.where((coupon) => coupon['active'] == isActive).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupons'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Expired'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildCouponList(isActive: true),
          buildCouponList(isActive: false),
        ],
      ),
    );
  }

  Widget buildCouponList({required bool isActive}) {
    List<Map<String, dynamic>> filteredCoupons = getFilteredCoupons(isActive);

    return ListView.builder(
      itemCount: filteredCoupons.length,
      itemBuilder: (context, index) {
        var coupon = filteredCoupons[index];

        return CouponCard(
          id: coupon['_id'],
          color: hexToColor(coupon['style']['color']),
          title: coupon['title'],
          isOwned: true,
          discountPercent: coupon['discountPercentage'],
          active: coupon['active'],
          subtitle: coupon['description'],
          validity: DateTime.parse(coupon['validTill']),
          price: coupon['price'] ?? 100,
        );
      },
    );
  }
}
