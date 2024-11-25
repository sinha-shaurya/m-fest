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
          backgroundColor: Color(0xFFa7c957),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFa7c957),
                  Color(0xFF386641),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildCategoryIcons(),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Available Coupons'),
                      const SizedBox(height: 10),
                      _buildCouponGrid(),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Popular Shops'),
                      const SizedBox(height: 10),
                      _buildShopList(),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Popular Restaurants'),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 28,
                              ),
                              Icon(
                                Icons.restaurant_outlined,
                                size: 48,
                                color: Colors.grey.shade800,
                              ),
                              Text(
                                'No resturants available',
                                style: TextStyle(color: Colors.grey.shade800),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search...',
          filled: true,
          fillColor: Colors.white54,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF344e41)),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          prefixIcon: Icon(Icons.search, color: Color(0xFF344e41)),
        ),
        onSubmitted: (value) {
          _showLoginDialog();
        },
      ),
    );
  }

  Widget _buildCategoryIcons() {
    return GestureDetector(
      onTap: _showLoginDialog,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(8),
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
        Icon(icon, color: Color(0xFF344e41)),
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
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 28,
                  ),
                  Icon(
                    Icons.folder_outlined,
                    size: 48,
                    color: Colors.grey.shade800,
                  ),
                  Text(
                    'No coupons available',
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ],
              ),
            );
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
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${coupon['discountPercentage']}%",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            coupon['title'].toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF424242),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.store,
                                color: Colors.grey.shade600, size: 20),
                            const SizedBox(width: 6),
                            const Text(
                              'Shop',
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF757575)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const Center(
            child: CircularProgressIndicator(
          color: Color(0xFF344e41),
        ));
      },
    );
  }

  Widget _buildShopList() {
    return BlocBuilder<CouponBloc, CouponState>(
      builder: (context, state) {
        if (state is LandingLoaded) {
          if (state.shops.isEmpty) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 28,
                  ),
                  Icon(
                    Icons.shop_two_outlined,
                    size: 48,
                    color: Colors.grey.shade800,
                  ),
                  Text(
                    'No shops available',
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.shops.length,
            itemBuilder: (context, index) {
              final shop = state.shops[index];
              return Card(
                elevation: 2,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFa7c957),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.store,
                      size: 36,
                      color: Color(0xFF344e41),
                    ),
                  ),
                  title: Text(
                    shop['data']['shop_name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  subtitle: Text(
                    '${shop['data']['shop_city']}, ${shop['data']['shop_state']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                    ),
                  ),
                  onTap: _showLoginDialog,
                ),
              );
            },
          );
        }
        return const Center(
            child: CircularProgressIndicator(
          color: Color(0xFF344e41),
        ));
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: _showLoginDialog,
              icon: const Icon(Icons.arrow_forward, color: Color(0xFF757575))),
        ],
      ),
    );
  }
}
