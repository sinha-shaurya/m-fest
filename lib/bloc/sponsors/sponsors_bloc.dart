import 'dart:convert';
import 'package:aash_india/bloc/sponsors/sponsors_event.dart';
import 'package:aash_india/bloc/sponsors/sponsors_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SponsorBloc extends Bloc<SponsorEvent, SponsorState> {
  SponsorBloc() : super(SponsorInitial()) {
    on<GetAllSponsors>(_fetchAllSponsors);
  }

  final String baseUrl =
      dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:5000');

  Future<void> _fetchAllSponsors(
      GetAllSponsors event, Emitter<SponsorState> emit) async {
    emit(SponsorLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final selectedCity = prefs.getString('selectedCity');
      final uri = Uri.parse('$baseUrl/api/link').replace(
        queryParameters: {
          'city': event.city ?? selectedCity ?? '',
        },
      );
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        final List<Map<String, dynamic>> sponsors =
            responseData.cast<Map<String, dynamic>>();
        if (responseData.isEmpty) {
          emit(SponsorLoaded([]));
        } else {
          if (event.isCarousel) {
            var filteredSponsors = sponsors
                .where((sponsor) => sponsor['display'] == true)
                .toList();
            emit(SponsorLoaded(filteredSponsors.reversed.toList()));
          } else {
            emit(SponsorLoaded(sponsors.reversed.toList()));
          }
        }
      } else {
        emit(SponsorFailed('Something went wrong'));
      }
    } catch (error) {
      emit(SponsorFailed('Unknown error occurred.'));
    }
  }
}
