import 'package:aash_india/bloc/coupons/coupon_bloc.dart';
import 'package:aash_india/bloc/coupons/coupon_event.dart';
import 'package:aash_india/bloc/coupons/coupon_state.dart';
import 'package:aash_india/bloc/navigation/navigation_bloc.dart';
import 'package:aash_india/bloc/navigation/navigation_event.dart';
import 'package:aash_india/bloc/navigation/navigation_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/presentations/screens/profile/profile_page.dart';
import 'package:aash_india/presentations/screens/sponsors/sponsor_page.dart';
import 'package:aash_india/presentations/widgets/category_item.dart';
import 'package:aash_india/presentations/widgets/coupon_card.dart';
import 'package:aash_india/presentations/widgets/image_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<CouponBloc>(context).add(GetAllCoupons());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text("Aash India App"),
        backgroundColor: appTheme(context).primaryColor,
      ),
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          if (state is NavigationHome) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageCarousel(),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        CategoryItem(name: 'Fashion', icon: Icons.shopping_bag),
                        CategoryItem(name: 'Clothes', icon: Icons.woman),
                        CategoryItem(
                            name: 'Footwear', icon: Icons.snowshoeing_sharp),
                        CategoryItem(name: 'Electronics', icon: Icons.devices),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: BlocBuilder<CouponBloc, CouponState>(
                      builder: (context, state) {
                        if (state is CouponLoaded) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.coupons.length,
                            itemBuilder: (context, index) {
                              return CouponCard(
                                title: state.coupons[index]['title'],
                                active: state.coupons[index]['active'],
                                discountPercent: state.coupons[index]
                                    ['discountPercentage'],
                              );
                            },
                          );
                        }
                        return CircularProgressIndicator(
                          backgroundColor: AppColors.primaryColor,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is NavigationCategories) {
            return SponsorPage();
          } else if (state is NavigationFavorites) {
            return const Center(
                child: Text('You have not added any coupon yet !'));
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
              BlocProvider.of<NavigationBloc>(context).add(PageTapped(index));
            },
            items: const [
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
    );
  }

  int _getSelectedIndex(NavigationState state) {
    if (state is NavigationHome) return 0;
    if (state is NavigationCategories) return 1;
    if (state is NavigationFavorites) return 2;
    if (state is NavigationProfile) return 3;
    return 0;
  }
}
