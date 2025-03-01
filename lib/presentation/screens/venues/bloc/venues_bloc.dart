import 'package:beauty_client/domain/models/paging.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'venues_bloc.freezed.dart';
part 'venues_event.dart';
part 'venues_state.dart';

class VenuesBloc extends Bloc<VenuesEvent, VenuesState> {
  final VenueRepository _venueRepository;

  VenuesBloc(this._venueRepository) : super(const VenuesState()) {
    on<_Started>((event, emit) async {

    });
  }
}
