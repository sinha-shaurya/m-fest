import 'dart:convert';
import 'package:aash_india/bloc/sponsors/sponsors_event.dart';
import 'package:aash_india/bloc/sponsors/sponsors_state.dart';
import 'package:aash_india/services/local_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class SponsorBloc extends Bloc<SponsorEvent, SponsorState> {
  SponsorBloc() : super(SponsorInitial()) {
    on<GetAllSponsors>(_fetchAllSponsors);
  }
  final LocalStorageService _localStorageService = LocalStorageService();

  Future<void> _fetchAllSponsors(
      GetAllSponsors event, Emitter<SponsorState> emit) async {
    emit(SponsorLoading());
    try {
      final uri =
          Uri.parse('${_localStorageService.getBaseUrl}/api/link').replace(
        queryParameters: {
          'city': event.city ?? _localStorageService.getSelectedCity ?? '',
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
