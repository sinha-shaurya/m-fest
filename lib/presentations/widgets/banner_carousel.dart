import 'package:aash_india/bloc/sponsors/sponsors_bloc.dart';
import 'package:aash_india/bloc/sponsors/sponsors_event.dart';
import 'package:aash_india/bloc/sponsors/sponsors_state.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannerCarousel extends StatefulWidget {
  final String city;
  const BannerCarousel({this.city = "", super.key});

  @override
  BannerCarouselState createState() => BannerCarouselState();
}

class BannerCarouselState extends State<BannerCarousel> {
  List sponsors = [];

  @override
  void initState() {
    super.initState();
    _loadSponsors();
  }

  void _loadSponsors() {
    BlocProvider.of<SponsorBloc>(context)
        .add(GetAllSponsors(city: widget.city, isCarousel: true));
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
          return Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.fromBorderSide(
                      BorderSide(color: Colors.grey.shade100))),
              child: CarouselSlider.builder(
                itemCount: sponsors.length,
                itemBuilder: (context, index, realIndex) {
                  return Image.network(
                    sponsors[index]['img'],
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        double progress =
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : 0;

                        return Container(
                          height: 220,
                          width: 220,
                          color: Colors.grey.shade200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: progress,
                                backgroundColor:
                                    Colors.grey, // Full progress color
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey.shade800), // Progress color
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
                options: CarouselOptions(
                  height: 220,
                  aspectRatio: 3 / 4,
                  viewportFraction: 0.55,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.horizontal,
                ),
              ));
        }
        return const SizedBox();
      },
    );
  }
}
