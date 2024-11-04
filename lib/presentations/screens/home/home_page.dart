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
  String? selectedState;
  @override
  void initState() {
    _initializeState();
    BlocProvider.of<CouponBloc>(context).add(GetAllCoupons());
    BlocProvider.of<ProfileBloc>(context).add(ProfileFetchInfo());
    BlocProvider.of<AppDataBloc>(context).add(AppDataFetch());
    super.initState();
  }

  Future<void> _initializeState() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? state = pref.getString('selectedState');
    setState(() {
      selectedState = state;
    });
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
          ),
          drawer: AppDrawer(),
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
                      !isPartner
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Select State',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                value: selectedState != 'all'
                                    ? selectedState
                                    : null,
                                items: [
                                  'Andhra Pradesh',
                                  'Arunachal Pradesh',
                                  'Assam',
                                  'Bihar',
                                  'Chhattisgarh',
                                  'Goa',
                                  'Gujarat',
                                  'Haryana',
                                  'Himachal Pradesh',
                                  'Jharkhand',
                                  'Karnataka',
                                  'Kerala',
                                  'Madhya Pradesh',
                                  'Maharashtra',
                                  'Manipur',
                                  'Meghalaya',
                                  'Mizoram',
                                  'Nagaland',
                                  'Odisha',
                                  'Punjab',
                                  'Rajasthan',
                                  'Sikkim',
                                  'Tamil Nadu',
                                  'Telangana',
                                  'Tripura',
                                  'Uttar Pradesh',
                                  'Uttarakhand',
                                  'West Bengal',
                                  'Andaman and Nicobar Islands',
                                  'Chandigarh',
                                  'Dadra and Nagar Haveli and Daman and Diu',
                                  'Lakshadweep',
                                  'Delhi',
                                  'Puducherry',
                                  'Ladakh',
                                  'Jammu and Kashmir'
                                ].map((String state) {
                                  return DropdownMenuItem<String>(
                                    value: state,
                                    child: Text(state),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  BlocProvider.of<CouponBloc>(context)
                                      .add(GetAllCoupons(state: value));
                                  setState(() {
                                    selectedState = value;
                                  });
                                },
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
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
                                onChanged: (query) {},
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
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
