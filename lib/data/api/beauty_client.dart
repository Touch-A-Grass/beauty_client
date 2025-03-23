import 'package:beauty_client/data/models/requests/create_order_request.dart';
import 'package:beauty_client/data/models/requests/send_code_request.dart';
import 'package:beauty_client/data/models/requests/send_phone_request.dart';
import 'package:beauty_client/domain/models/auth.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'beauty_client.g.dart';

@RestApi()
abstract class BeautyClient {
  factory BeautyClient(Dio dio, {String? baseUrl}) = _BeautyClient;

  @POST('/user/phone_challenge')
  Future<void> sendPhone(@Body() SendPhoneRequest request);

  @POST('/user/auth')
  Future<Auth> sendCode(@Body() SendCodeRequest request);

  @GET('/venue')
  Future<List<Venue>> venues({
    @Query('latitude') double? latitude,
    @Query('longitude') double? longitude,
    @Query('limit') required int limit,
    @Query('offset') required int offset,
  });

  @GET('/venue/{id}/services')
  Future<List<Service>> venueServices(@Path('id') String venueId);

  @GET('/venue/{id}')
  Future<Venue> getVenue(@Path('id') String id);

  @GET('/venue/{id}/staff')
  Future<List<Staff>> getStaff(@Path('id') String id);

  @GET('/venue/{id}/services')
  Future<List<Service>> getServices(@Path('id') String id);

  @POST('/record')
  Future<void> createOrder(@Body() CreateOrderRequest request);
}
