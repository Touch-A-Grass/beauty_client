import 'package:beauty_client/data/models/requests/send_code_request.dart';
import 'package:beauty_client/data/models/requests/send_phone_request.dart';
import 'package:beauty_client/domain/models/auth.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'beauty_client.g.dart';

@RestApi(baseUrl: 'http://213.183.53.46:8228/')
abstract class BeautyClient {
  factory BeautyClient(Dio dio, {String? baseUrl}) = _BeautyClient;

  @POST('/user/phone_challenge')
  Future<void> sendPhone(@Body() SendPhoneRequest request);

  @POST('/user/auth')
  Future<Auth> sendCode(@Body() SendCodeRequest request);

  @GET('/venue')
  Future<List<Venue>> venues({
    @Query('latitude') required double latitude,
    @Query('longitude') required double longitude,
    @Query('limit') required int limit,
    @Query('offset') required int offset,
  });

  @GET('/venue/services')
  Future<List<Service>> venueServices(@Query('id') String venueId);
}
