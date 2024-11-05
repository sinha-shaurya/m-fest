import 'package:aash_india/presentations/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aash_india/bloc/coupons/coupon_bloc.dart';
import 'package:aash_india/bloc/coupons/coupon_event.dart';
import 'package:aash_india/bloc/coupons/coupon_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/presentations/widgets/banner_carousel.dart';
import 'package:aash_india/presentations/widgets/coupon_card.dart';
import 'package:aash_india/presentations/widgets/shop_card.dart';
import 'package:aash_india/presentations/widgets/login_dialog.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late TextEditingController searchController;

  @override
  void initState() {
    BlocProvider.of<CouponBloc>(context).add(GetLanding());
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => LoginDialog(
        onLogin: () {
          _navigateToLogin();
        },
      ),
    );
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
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Aash India'),
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: _navigateToLogin,
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BannerCarousel(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon:
                        Icon(Icons.search, color: AppColors.primaryColor),
                  ),
                  onSubmitted: (value) {
                    _showLoginDialog();
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Popular Coupons'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<CouponBloc, CouponState>(
                  builder: (context, state) {
                    if (state is LandingLoaded) {
                      if (state.coupons.isEmpty) {
                        return Text("No coupons available");
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.coupons.length,
                        itemBuilder: (context, index) {
                          return CouponCard(
                            id: state.coupons[index]['_id'],
                            onTap: _showLoginDialog,
                            title: state.coupons[index]['title'],
                            discountPercent: state.coupons[index]
                                ['discountPercentage'],
                            active: state.coupons[index]['active'],
                            validity: DateTime.parse(
                                state.coupons[index]['validTill']),
                            price: state.coupons[index]['price'] ?? 100,
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              _buildSectionTitle('Popular Shops'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<CouponBloc, CouponState>(
                  builder: (context, state) {
                    if (state is LandingLoaded) {
                      if (state.shops.isEmpty) {
                        return Text("No shops available");
                      }
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          mainAxisExtent: 250,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.shops.length,
                        itemBuilder: (context, index) {
                          final shop = state.shops[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ShopCard(
                              shopName: shop['data']['shop_name'],
                              city: shop['data']['shop_city'],
                              state: shop['data']['shop_state'],
                              onTap: _showLoginDialog,
                            ),
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
