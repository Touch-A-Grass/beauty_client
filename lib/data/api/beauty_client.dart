import 'package:beauty_client/data/models/dto/staff_time_slot_dto.dart';
import 'package:beauty_client/data/models/requests/create_order_request.dart';
import 'package:beauty_client/data/models/requests/send_code_request.dart';
import 'package:beauty_client/data/models/requests/send_phone_request.dart';
import 'package:beauty_client/data/models/requests/update_user_request.dart';
import 'package:beauty_client/domain/models/auth.dart';
import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/user.dart';
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

  @GET('/user')
  Future<User> getUser();

  @PATCH('/user')
  Future<void> updateUser(@Body() UpdateUserRequest user);

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

  @GET('/staff/{id}/schedule')
  Future<List<StaffTimeSlotDto>> getVenueStaffTimeSlots({
    @Path('id') required String staffId,
    @Query('venueId') required String venueId,
  });

  @GET('/record/{id}')
  Future<Order> getOrder(@Path('id') String id);

  @GET('/user/records')
  Future<List<Order>> getOrders({@Query('limit') required int limit, @Query('offset') required int offset});
}
