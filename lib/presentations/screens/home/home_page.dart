import 'package:aash_india/bloc/appdata/app_data_bloc.dart';
import 'package:aash_india/bloc/appdata/app_data_event.dart';
import 'package:aash_india/bloc/auth/auth_bloc.dart';
import 'package:aash_india/bloc/auth/auth_state.dart';
import 'package:aash_india/bloc/coupons/coupon_bloc.dart';
import 'package:aash_india/bloc/coupons/coupon_event.dart';
import 'package:aash_india/bloc/coupons/coupon_state.dart';
import 'package:aash_india/bloc/navigation/navigation_bloc.dart';
import 'package:aash_india/bloc/navigation/navigation_event.dart';
import 'package:aash_india/bloc/navigation/navigation_state.dart';
import 'package:aash_india/bloc/profile/profile_bloc.dart';
import 'package:aash_india/bloc/profile/profile_event.dart';
import 'package:aash_india/bloc/profile/profile_state.dart';
import 'package:aash_india/bloc/sponsors/sponsors_bloc.dart';
import 'package:aash_india/bloc/sponsors/sponsors_event.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/presentations/screens/auth/login.dart';
import 'package:aash_india/presentations/screens/auth/splash_screen.dart';
import 'package:aash_india/presentations/screens/coupon/coupon_detail.dart';
import 'package:aash_india/presentations/screens/coupon/coupons.dart';
import 'package:aash_india/presentations/screens/coupon/manage_coupons.dart';
import 'package:aash_india/presentations/screens/profile/profile_page.dart';
import 'package:aash_india/presentations/screens/sponsors/sponsor_page.dart';
import 'package:aash_india/presentations/widgets/app_drawer.dart';
import 'package:aash_india/presentations/widgets/banner_carousel.dart';
import 'package:aash_india/presentations/widgets/category_item.dart';
import 'package:aash_india/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalStorageService _localStorageService = LocalStorageService();
  String activeCategory = 'All';
  bool isPartner = false;
  late TextEditingController searchController;
  late String? selectedCity;

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(ProfileFetchInfo());
    BlocProvider.of<AppDataBloc>(context).add(AppDataFetch());
    searchController = TextEditingController();
    selectedCity = _localStorageService.getSelectedCity;
    _initializeState();
    super.initState();
  }

  Future<void> _initializeState() async {
    if (mounted) {
      BlocProvider.of<CouponBloc>(context)
          .add(GetAllCoupons(city: _localStorageService.getSelectedCity));
      BlocProvider.of<SponsorBloc>(context).add(GetAllSponsors(
          isCarousel: true, city: _localStorageService.getSelectedCity));
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFetched) {
              setState(() {
                isPartner = state.type != 'customer';
              });
            }
          },
        ),
        BlocListener<CouponBloc, CouponState>(
          listener: (context, state) async {
            if (state is CouponFailed) {
              if (state.error == 'No user found with this mobile number') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('User is not on this platform'),
                  backgroundColor: AppColors.errorColor,
                ));
                await Share.share(
                    'Hey, Download this app to get exclusive coupons and discounts at nearby shops');
                return;
              }
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
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLogout) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SplashScreen()),
                (Route<dynamic> route) => false,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Image.asset(
            'assets/logo.png',
            height: 80,
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFa7c957),
          foregroundColor: Color(0xFF344e41),
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            ),
          ),
          actions: [
            Text(
              selectedCity ?? "N/A",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF344e41),
              ),
            ),
            _localStorageService.getCities != null &&
                    _localStorageService.getCities!.isNotEmpty
                ? PopupMenuButton<String>(
                    icon: Icon(Icons.pin_drop, color: Color(0xFF344e41)),
                    onSelected: (String city) async {
                      setState(() {
                        selectedCity = city;
                      });

                      BlocProvider.of<CouponBloc>(context)
                          .add(GetAllCoupons(city: city));
                      BlocProvider.of<SponsorBloc>(context)
                          .add(GetAllSponsors(city: city));

                      await _localStorageService.setSelectedCity(city);
                    },
                    itemBuilder: (BuildContext context) {
                      return _localStorageService.getCities!
                          .map((String city) => city)
                          .toList()
                          .map<PopupMenuItem<String>>((String city) {
                        return PopupMenuItem<String>(
                          value: city,
                          child: Text(
                            city,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList();
                    },
                  )
                : Icon(
                    Icons.pin_drop,
                    color: Color(0xFF344e41),
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
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildSearch(context),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (BlocProvider.of<AuthBloc>(context).state
                                      is AuthSuccess) {
                                    BlocProvider.of<NavigationBloc>(context)
                                        .add(PageTapped(2));
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                    );
                                  }
                                },
                                child: Column(
                                  children: [
                                    Icon(Icons.shopping_bag,
                                        color: Color(0xFF344e41)),
                                    const SizedBox(height: 4),
                                    Text('Coupons'),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  BlocProvider.of<NavigationBloc>(context)
                                      .add(PageTapped(1));
                                },
                                child: Column(
                                  children: [
                                    Icon(Icons.pages, color: Color(0xFF344e41)),
                                    const SizedBox(height: 4),
                                    Text('Banners'),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (BlocProvider.of<AuthBloc>(context).state
                                      is AuthSuccess) {
                                    BlocProvider.of<NavigationBloc>(context)
                                        .add(PageTapped(3));
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                    );
                                  }
                                },
                                child: BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) {
                                    if (state is AuthSuccess) {
                                      return Column(
                                        children: [
                                          Icon(Icons.person,
                                              color: Color(0xFF344e41)),
                                          const SizedBox(height: 4),
                                          Text('Profile'),
                                        ],
                                      );
                                    }
                                    return Column(
                                      children: [
                                        Icon(Icons.login,
                                            color: Color(0xFF344e41)),
                                        const SizedBox(height: 4),
                                        Text('Login'),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        BannerCarousel(
                          city: _localStorageService.getSelectedCity ?? "",
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(4, 24, 4, 0),
                          decoration: BoxDecoration(
                            border: Border.fromBorderSide(
                                BorderSide(color: Colors.grey.shade100)),
                            color: Colors.grey.shade100,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlocBuilder<ProfileBloc, ProfileState>(
                                builder: (context, state) {
                                  if (state is ProfileFetched) {
                                    return Text(
                                      state.type == 'customer'
                                          ? '\t\tPopular coupons'
                                          : '\t\tYour coupons',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    );
                                  }
                                  return Text(
                                    '\t\tPopular coupons',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              _buildCategories(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: BlocBuilder<CouponBloc, CouponState>(
                                  builder: (context, state) {
                                    if (state is CouponLoaded) {
                                      if (state.coupons.isEmpty) {
                                        return SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 28,
                                              ),
                                              Icon(
                                                Icons.folder_outlined,
                                                size: 48,
                                                color: Colors.grey.shade700,
                                              ),
                                              Text(
                                                'No Coupons Available',
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade700),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return GridView.builder(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                        ),
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: state.coupons.length,
                                        itemBuilder: (context, index) {
                                          final coupon = state.coupons[index];
                                          return GestureDetector(
                                            onTap: () {
                                              if (BlocProvider.of<AuthBloc>(
                                                      context)
                                                  .state is AuthSuccess) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CouponDetail(
                                                            id: coupon['_id']),
                                                  ),
                                                );
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage(),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFF344e41),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: Offset(0, 1),
                                                    blurRadius: 2,
                                                    spreadRadius: 2,
                                                    color: Colors.black38,
                                                  )
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${coupon['discountPercentage']}",
                                                        style: TextStyle(
                                                          fontSize: 28,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.percent,
                                                        size: 24,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Flexible(
                                                    child: Container(
                                                      width: double.infinity,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                      ),
                                                      child: Text(
                                                        coupon['title']
                                                            .toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Color(0xFF344e41),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    coupon['ownerAddress'] ??
                                                        '',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Color(0xFF344e41),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is NavigationCategories) {
              return PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  BlocProvider.of<NavigationBloc>(context).add(PageTapped(0));
                },
                child: SponsorPage(),
              );
            } else if (state is NavigationCoupon) {
              return PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  BlocProvider.of<NavigationBloc>(context).add(PageTapped(0));
                },
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileFetched) {
                      if (state.type == 'customer') return Coupons();
                      return ManageCoupons();
                    }
                    return const Center(
                      child: Text('Error Fetching'),
                    );
                  },
                ),
              );
            } else if (state is NavigationProfile) {
              return PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, result) {
                    BlocProvider.of<NavigationBloc>(context).add(PageTapped(0));
                  },
                  child: ProfilePage());
            }
            return Container();
          },
        ),
      ),
    );
  }

  BlocBuilder<ProfileBloc, ProfileState> _buildCategories() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileFetched) {
          if (state.type == 'customer') {
            return SizedBox(
              height: 48,
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
            );
          }
        }
        return SizedBox();
      },
    );
  }

  Padding _buildSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.white70,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF344e41)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100))),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100))),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                BlocProvider.of<CouponBloc>(context).add(
                  GetAllCoupons(
                      city: _localStorageService.getSelectedCity,
                      search: searchController.text),
                );
              } else if (searchController.text.isEmpty) {
                BlocProvider.of<CouponBloc>(context).add(
                  GetAllCoupons(city: _localStorageService.getSelectedCity),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF344e41),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                    bottomRight: Radius.circular(100)),
              ),
            ),
            child: Icon(
              Icons.search,
              size: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
