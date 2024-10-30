import 'package:aash_india/bloc/coupons/coupon_bloc.dart';
import 'package:aash_india/bloc/coupons/coupon_event.dart';
import 'package:aash_india/bloc/coupons/coupon_state.dart';
import 'package:aash_india/bloc/navigation/navigation_bloc.dart';
import 'package:aash_india/bloc/navigation/navigation_event.dart';
import 'package:aash_india/bloc/navigation/navigation_state.dart';
import 'package:aash_india/bloc/profile/profile_bloc.dart';
import 'package:aash_india/bloc/profile/profile_event.dart';
import 'package:aash_india/bloc/profile/profile_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/presentations/screens/coupon/coupon_detail.dart';
import 'package:aash_india/presentations/screens/coupon/coupons.dart';
import 'package:aash_india/presentations/screens/coupon/manage_coupons.dart';
import 'package:aash_india/presentations/screens/profile/profile_page.dart';
import 'package:aash_india/presentations/screens/sponsors/sponsor_page.dart';
import 'package:aash_india/presentations/widgets/category_item.dart';
import 'package:aash_india/presentations/widgets/coupon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activeCategory = 'All';
  bool isPartner = false;
  @override
  void initState() {
    BlocProvider.of<CouponBloc>(context).add(GetAllCoupons());
    BlocProvider.of<ProfileBloc>(context).add(ProfileFetchInfo());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileFetched) {
          setState(() {
            isPartner = true;
          });
        }
      },
      child: BlocListener<CouponBloc, CouponState>(
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
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: Builder(
              builder: (context) => IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.menu),
              ),
            ),
          ),
          drawer: Drawer(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aash India',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Address: 123 Main Street\nCity, Jharkhand\nPIN: 123456',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Contact: +91 9876543210\nEmail: info@aashindia.com',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text('Home'),
                        onTap: () {
                          BlocProvider.of<NavigationBloc>(context)
                              .add(PageTapped(0));
                          Navigator.pop(context);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.pages),
                        title: Text('Sponsors'),
                        onTap: () {
                          BlocProvider.of<NavigationBloc>(context)
                              .add(PageTapped(1));
                          Navigator.pop(context);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.topic),
                        title: Text('Coupons'),
                        onTap: () {
                          BlocProvider.of<NavigationBloc>(context)
                              .add(PageTapped(2));
                          Navigator.pop(context);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                        onTap: () {
                          BlocProvider.of<NavigationBloc>(context)
                              .add(PageTapped(3));
                          Navigator.pop(context);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.star),
                        title: Text('Rate us'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.share),
                        title: Text('Share with Friends'),
                        onTap: () async {
                          final message =
                              'Check out Aash India! Discover exclusive coupons and discounts at nearby shops!';
                          Navigator.pop(context);
                          await Share.share(
                            message,
                            subject: 'Get Exciting Discounts with Aash India!',
                          );
                        },
                      ),
                      Divider(),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Developed by Sonu & Ayush',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              if (state is NavigationHome) {
                BlocProvider.of<CouponBloc>(context)
                    .add(FilterCoupons(activeCategory));

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        '\tCategories',
                        style: TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 60,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            CategoryItem(
                              onTap: () {
                                if (activeCategory != 'All') {
                                  BlocProvider.of<CouponBloc>(context)
                                      .add(FilterCoupons('All'));
                                  setState(() {
                                    activeCategory = 'All';
                                  });
                                }
                              },
                              name: 'All',
                              icon: Icons.shopping_bag,
                              isActive: activeCategory == 'All',
                            ),
                            CategoryItem(
                              name: 'Fashion',
                              icon: Icons.woman,
                              isActive: activeCategory == 'Fashion',
                              onTap: () {
                                if (activeCategory != 'Fashion') {
                                  BlocProvider.of<CouponBloc>(context)
                                      .add(FilterCoupons('Fashion'));
                                  setState(() {
                                    activeCategory = 'Fashion';
                                  });
                                }
                              },
                            ),
                            CategoryItem(
                              name: 'Appliances',
                              icon: Icons.cookie_rounded,
                              isActive: activeCategory == 'Appliances',
                              onTap: () {
                                if (activeCategory != 'Appliances') {
                                  BlocProvider.of<CouponBloc>(context)
                                      .add(FilterCoupons('Appliances'));
                                  setState(() {
                                    activeCategory = 'Appliances';
                                  });
                                }
                              },
                            ),
                            CategoryItem(
                              name: 'Electronics',
                              icon: Icons.devices,
                              isActive: activeCategory == 'Electronics',
                              onTap: () {
                                if (activeCategory != 'Electronics') {
                                  BlocProvider.of<CouponBloc>(context)
                                      .add(FilterCoupons('Electronics'));
                                  setState(() {
                                    activeCategory = 'Electronics';
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: BlocBuilder<CouponBloc, CouponState>(
                          builder: (context, state) {
                            if (state is CouponLoaded) {
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
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CouponDetail(
                                          id: state.coupons[index]['_id'],
                                        ),
                                      ),
                                    ),
                                    title: state.coupons[index]['title'],
                                    discountPercent: state.coupons[index]
                                        ['discountPercentage'],
                                    active: state.coupons[index]['active'],
                                    subtitle: state.coupons[index]
                                        ['description'],
                                    validity: DateTime.parse(
                                        state.coupons[index]['validTill']),
                                    price: state.coupons[index]['price'] ?? 100,
                                  );
                                },
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: AppColors.primaryColor,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is NavigationCategories) {
                return SponsorPage();
              } else if (state is NavigationCoupon) {
                return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileFetched) {
                      if (state.type == 'customer') return Coupons();
                      return ManageCoupons();
                    }
                    return const Center(
                      child: Text('Error Fetching'),
                    );
                  },
                );
              } else if (state is NavigationProfile) {
                return ProfilePage();
              }
              return Container();
            },
          ),
          bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              return BottomNavigationBar(
                currentIndex: _getSelectedIndex(state),
                onTap: (index) {
                  if (index == 0 && !isPartner) {
                    BlocProvider.of<CouponBloc>(context).add(GetAllCoupons());
                  }
                  BlocProvider.of<NavigationBloc>(context)
                      .add(PageTapped(index));
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.pages),
                    label: 'Sponsors',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.topic),
                    label: 'Coupons',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
                selectedItemColor: appTheme(context).primaryColor,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
              );
            },
          ),
        ),
      ),
    );
  }

  int _getSelectedIndex(NavigationState state) {
    if (state is NavigationHome) return 0;
    if (state is NavigationCategories) return 1;
    if (state is NavigationCoupon) return 2;
    if (state is NavigationProfile) return 3;
    return 0;
  }
}
