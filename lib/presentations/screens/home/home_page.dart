import 'dart:developer';

import 'package:aash_india/bloc/appdata/app_data_bloc.dart';
import 'package:aash_india/bloc/appdata/app_data_event.dart';
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
import 'package:aash_india/presentations/widgets/app_drawer.dart';
import 'package:aash_india/presentations/widgets/banner_carousel.dart';
import 'package:aash_india/presentations/widgets/category_item.dart';
import 'package:aash_india/presentations/widgets/coupon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activeCategory = 'All';
  bool isPartner = false;
  String? selectedCity;
  List<String> cities = [];
  late TextEditingController searchController;

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(ProfileFetchInfo());
    BlocProvider.of<AppDataBloc>(context).add(AppDataFetch());
    searchController = TextEditingController();
    loadCities();
    _initializeState();
    super.initState();
  }

  Future<void> _initializeState() async {
    if (mounted) {
      BlocProvider.of<CouponBloc>(context)
          .add(GetAllCoupons(city: selectedCity));
    }
    setState(() {
      selectedCity = null;
    });
  }

  Future<void> loadCities() async {
    try {
      cities = await CouponBloc().fetchCities();
      final SharedPreferences pref = await SharedPreferences.getInstance();
      String? city = pref.getString('selectedCity');
      setState(() {
        selectedCity = city ?? (cities.isNotEmpty ? cities[0] : null);
      });
    } catch (error) {
      log(error.toString());
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileFetched) {
          setState(() {
            isPartner = state.type != 'customer';
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
          } else if (state is CouponSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message ?? "success"),
              backgroundColor: Colors.green,
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
            actions: [
              cities.isNotEmpty
                  ? DropdownButton<String>(
                      value: selectedCity,
                      icon: Icon(Icons.pin_drop, color: Colors.white),
                      dropdownColor: AppColors.primaryColor,
                      underline: SizedBox.shrink(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCity = newValue;
                        });
                        BlocProvider.of<CouponBloc>(context)
                            .add(GetAllCoupons(city: newValue));
                      },
                      items:
                          cities.map<DropdownMenuItem<String>>((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(
                            city,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('N/A'),
                        Icon(Icons.pin_drop),
                      ],
                    ),
            ],
          ),
          drawer: AppDrawer(),
          body: BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              if (state is NavigationHome) {
                BlocProvider.of<CouponBloc>(context)
                    .add(FilterCoupons(activeCategory));

                return RefreshIndicator.adaptive(
                  onRefresh: _initializeState,
                  color: AppColors.accentColor,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BannerCarousel(),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search...',
                                    filled: true,
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade400),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12))),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12))),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (searchController.text.isNotEmpty) {
                                    BlocProvider.of<CouponBloc>(context).add(
                                      GetAllCoupons(
                                          city: selectedCity,
                                          search: searchController.text),
                                    );
                                  } else if (searchController.text.isEmpty) {
                                    BlocProvider.of<CouponBloc>(context).add(
                                      GetAllCoupons(city: selectedCity),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(12),
                                        bottomRight: Radius.circular(12)),
                                  ),
                                ),
                                child: Icon(Icons.search),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            if (state is ProfileFetched) {
                              return Text(
                                state.type == 'customer'
                                    ? '\t\tPopular coupons'
                                    : '\t\tYour coupons',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey.shade800),
                              );
                            }
                            return Text(
                              '\t\tPopular coupons',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.grey.shade800),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            if (state is ProfileFetched) {
                              if (state.type == 'customer') {
                                return SizedBox(
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
                                        isActive:
                                            activeCategory == 'Appliances',
                                        onTap: () {
                                          if (activeCategory != 'Appliances') {
                                            BlocProvider.of<CouponBloc>(context)
                                                .add(FilterCoupons(
                                                    'Appliances'));
                                            setState(() {
                                              activeCategory = 'Appliances';
                                            });
                                          }
                                        },
                                      ),
                                      CategoryItem(
                                        name: 'Electronics',
                                        icon: Icons.devices,
                                        isActive:
                                            activeCategory == 'Electronics',
                                        onTap: () {
                                          if (activeCategory != 'Electronics') {
                                            BlocProvider.of<CouponBloc>(context)
                                                .add(FilterCoupons(
                                                    'Electronics'));
                                            setState(() {
                                              activeCategory = 'Electronics';
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                            return SizedBox();
                          },
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
                                      category: state.coupons[index]['category']
                                          [0],
                                      discountPercent: state.coupons[index]
                                          ['discountPercentage'],
                                      active: state.coupons[index]['active'],
                                      validity: DateTime.parse(
                                          state.coupons[index]['validTill']),
                                      price:
                                          state.coupons[index]['price'] ?? 100,
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
                    label: 'Banners',
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
