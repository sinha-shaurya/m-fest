import 'dart:async';
import 'package:aash_india/bloc/sponsors/sponsors_bloc.dart';
import 'package:aash_india/bloc/sponsors/sponsors_event.dart';
import 'package:aash_india/bloc/sponsors/sponsors_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  BannerCarouselState createState() => BannerCarouselState();
}

class BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentIndex = 0;
  List sponsors = [];

  @override
  void initState() {
    super.initState();
    _loadSponsors();

    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        _currentIndex++;
        if (_currentIndex >= sponsors.length) {
          _currentIndex = 0;
        }
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _loadSponsors() {
    BlocProvider.of<SponsorBloc>(context).add(GetAllSponsors(isCarousel: true));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SponsorBloc, SponsorState>(
      builder: (context, state) {
        if (state is SponsorLoaded) {
          sponsors = state.sponsors;
          if (sponsors.isEmpty) {
            return const SizedBox();
          }
          return SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _pageController,
              itemCount: sponsors.length,
              itemBuilder: (context, index) {
                return _buildSponsorItem(
                  logoPath: sponsors[index]['img'],
                  title: sponsors[index]['title'],
                );
              },
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: AppColors.primaryColor,
          ),
        );
      },
    );
  }

  Widget _buildSponsorItem({required String logoPath, required String title}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            logoPath,
            fit: BoxFit.contain,
            height: 160,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 50,
                ),
              );
            },
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
