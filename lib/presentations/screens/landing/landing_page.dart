import 'package:aash_india/presentations/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aash_india/bloc/coupons/coupon_bloc.dart';
import 'package:aash_india/bloc/coupons/coupon_event.dart';
import 'package:aash_india/bloc/coupons/coupon_state.dart';
import 'package:aash_india/core/constants/theme.dart';
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
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
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
          title: Image.asset(
            'assets/logo.png',
            height: 80,
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildCategoryIcons(),
                const SizedBox(height: 20),
                _buildSectionTitle('Available Coupons'),
                const SizedBox(height: 10),
                _buildCouponGrid(),
                const SizedBox(height: 20),
                _buildSectionTitle('Popular Shops'),
                const SizedBox(height: 10),
                _buildShopList(),
                const SizedBox(height: 20),
                _buildSectionTitle('Popular Restaurants'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('No restaurants available.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search...',
        filled: true,
        fillColor: Colors.grey[200],
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(Icons.search, color: AppColors.primaryColor),
      ),
      onSubmitted: (value) {
        _showLoginDialog();
      },
    );
  }

  Widget _buildCategoryIcons() {
    return GestureDetector(
      onTap: _showLoginDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIconWithLabel(Icons.topic_outlined, 'Coupons'),
            _buildIconWithLabel(Icons.image_outlined, 'Banners'),
            _buildIconWithLabel(Icons.login, 'Auth'),
          ],
        ),
      ),
    );
  }

  Widget _buildIconWithLabel(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryColor),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  Widget _buildCouponGrid() {
    return BlocBuilder<CouponBloc, CouponState>(
      builder: (context, state) {
        if (state is LandingLoaded) {
          if (state.coupons.isEmpty) {
            return const Center(child: Text("No coupons available"));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.coupons.length,
            itemBuilder: (context, index) {
              final coupon = state.coupons[index];
              return GestureDetector(
                onTap: () => _showLoginDialog(),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${coupon['discountPercentage']}%",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        coupon['title'].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.store, color: Colors.grey.shade700),
                          const SizedBox(width: 4),
                          const Text('Shop'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildShopList() {
    return BlocBuilder<CouponBloc, CouponState>(
      builder: (context, state) {
        if (state is LandingLoaded) {
          if (state.shops.isEmpty) {
            return const Center(child: Text("No shops available"));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.shops.length,
            itemBuilder: (context, index) {
              final shop = state.shops[index];
              return Card(
                elevation: 1,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 4),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      Icons.store,
                      size: 32,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  title: Text(shop['data']['shop_name']),
                  subtitle: Text(
                      '${shop['data']['shop_city']}, ${shop['data']['shop_state']}'),
                  onTap: _showLoginDialog,
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
