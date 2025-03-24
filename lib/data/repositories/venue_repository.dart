import 'package:beauty_client/data/api/beauty_client.dart';
import 'package:beauty_client/data/storage/location_storage.dart';
import 'package:beauty_client/domain/models/location.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/venue_repository.dart';

class VenueRepositoryImpl implements VenueRepository {
  final BeautyClient _api;
  final LocationStorage locationStorage;

  VenueRepositoryImpl(this._api, this.locationStorage);

  Venue _mapMockedVenue(Venue e) {
    return e.copyWith(
      description: switch (e.id) {
        '6b7d3992-767b-4777-9504-b0ff2c889de2' => 'Профессиональные стрижки, маникюр и укладки.',
        'c5a08f17-d2cb-4509-b01f-8eeefe0b2af2' => 'Уход за волосами, ногтями и кожей.',
        String() => '',
      },
    );
  }

  @override
  Future<List<Venue>> getVenues({Location? location, required int limit, required int offset}) async {
    // await Future.delayed(Duration(milliseconds: 500));
    // return [await getVenue('abcsgbzxcvbnm')];

    final userLocation = location;

    return (await _api.venues(
      latitude: userLocation?.latitude,
      longitude: userLocation?.longitude,
      limit: limit,
      offset: offset,
    )).map((e) => _mapMockedVenue(e)).toList();
  }

  @override
  Future<List<Service>> getServices(String venueId) async {
    return await _api.venueServices(venueId);
    await Future.delayed(Duration(milliseconds: 500));
    return [
      Service(
        id: 'a',
        name: 'Стрижка',
        description: 'Любая причёска на любой тип волос',
        price: 500,
        duration: Duration(minutes: 30),
      ),
      Service(
        id: 'b',
        name: 'Маникюр',
        description: 'Авторский маникюр от лучших мастеров',
        price: 1000,
        duration: Duration(hours: 2),
      ),
    ];
    return _api.venueServices(venueId);
  }

  @override
  Future<List<Staff>> getStaff(String venueId) async {
    return _api.getStaff(venueId);

    return [
      Staff(
        id: 'a',
        name: 'Артём Денисов',
        phoneNumber: '+79140060868',
        services: [(await getServices(venueId)).first.id],
      ),
      Staff(
        id: 'b',
        name: 'Руслан Белый',
        phoneNumber: '+79140060868',
        services: [(await getServices(venueId)).last.id],
      ),
    ];
  }

  @override
  Future<Venue> getVenue(String venueId) async {
    return _mapMockedVenue(await _api.getVenue(venueId));
    return Venue(
      id: 'abcsgbzxcvbnm',
      description: 'Лучший салон в Иркутске на улице Бульвар Гагарина',
      name: 'Иркутск Beauty',
      location: locationStorage.value,
    );
    return _api.getVenue(venueId);
  }
}
