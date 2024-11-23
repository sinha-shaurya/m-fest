import 'package:aash_india/bloc/appdata/app_data_bloc.dart';
import 'package:aash_india/bloc/appdata/app_data_state.dart';
import 'package:aash_india/bloc/auth/auth_bloc.dart';
import 'package:aash_india/bloc/auth/auth_event.dart';
import 'package:aash_india/bloc/auth/auth_state.dart';
import 'package:aash_india/bloc/navigation/navigation_bloc.dart';
import 'package:aash_india/bloc/navigation/navigation_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFa7c957),
                    Color(0xFF386641),
                  ],
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aash India',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    BlocBuilder<AppDataBloc, AppDataState>(
                      builder: (context, state) {
                        if (state is AppDataLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: state.address.split('.').map((line) {
                              return Text(
                                line,
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              );
                            }).toList(),
                          );
                        }
                        return SizedBox();
                      },
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
                  leading: Icon(
                    Icons.home,
                    color: Color(0xFF386641),
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(color: Color(0xFF386641)),
                  ),
                  onTap: () {
                    BlocProvider.of<NavigationBloc>(context).add(PageTapped(0));
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.pages,
                    color: Color(0xFF386641),
                  ),
                  title: Text(
                    'Banners',
                    style: TextStyle(color: Color(0xFF386641)),
                  ),
                  onTap: () {
                    BlocProvider.of<NavigationBloc>(context).add(PageTapped(1));
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.topic,
                    color: Color(0xFF386641),
                  ),
                  title: Text(
                    'Coupons',
                    style: TextStyle(color: Color(0xFF386641)),
                  ),
                  onTap: () {
                    BlocProvider.of<NavigationBloc>(context).add(PageTapped(2));
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Color(0xFF386641),
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(color: Color(0xFF386641)),
                  ),
                  onTap: () {
                    BlocProvider.of<NavigationBloc>(context).add(PageTapped(3));
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.star,
                    color: Color(0xFF386641),
                  ),
                  title: Text(
                    'Rate us',
                    style: TextStyle(color: Color(0xFF386641)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.share,
                    color: Color(0xFF386641),
                  ),
                  title: Text(
                    'Share with friends',
                    style: TextStyle(color: Color(0xFF386641)),
                  ),
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
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Color(0xFF386641),
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Color(0xFF386641)),
                  ),
                  trailing: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return CircularProgressIndicator(
                          color: Colors.grey.shade600,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  onTap: () {
                    BlocProvider.of<AuthBloc>(context).add(AuthLogoutEvent());
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
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
