import 'package:beauty_client/data/models/dto/chat_log_dto.dart';
import 'package:beauty_client/data/models/dto/staff_time_slot_dto.dart';
import 'package:beauty_client/data/models/requests/create_order_request.dart';
import 'package:beauty_client/data/models/requests/mark_as_read_request.dart';
import 'package:beauty_client/data/models/requests/send_code_request.dart';
import 'package:beauty_client/data/models/requests/send_firebase_token_request.dart';
import 'package:beauty_client/data/models/requests/send_message_request.dart';
import 'package:beauty_client/data/models/requests/send_phone_request.dart';
import 'package:beauty_client/data/models/requests/update_record_request.dart';
import 'package:beauty_client/data/models/requests/update_user_request.dart';
import 'package:beauty_client/domain/models/auth.dart';
import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/user.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/models/venue_map_clusters.dart';
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

  @POST('/user/firebase_token')
  Future<Auth> sendFirebaseToken(@Body() SendFirebaseTokenRequest request);

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
    @Query('search') String? searchQuery,
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

  @GET('/record/{recordId}/messages')
  Future<List<ChatLogDto>> getOrderMessages(@Path('recordId') String orderId);

  @POST('/record/{recordId}/message')
  Future<List<ChatLogDto>> sendOrderMessage(@Path('recordId') String orderId, @Body() SendMessageRequest request);

  @PATCH('/record/{recordId}/messages')
  Future<void> markAsRead(@Path('recordId') String orderId, @Body() MarkAsReadRequest request);

  @PATCH('/user/record')
  Future<void> updateOrder(@Body() UpdateRecordRequest request);

  @GET('/venue/clusters')
  Future<VenueMapClusters> getVenueMapClusters({
    @Query('minLatitude') required double minLatitude,
    @Query('maxLatitude') required double maxLatitude,
    @Query('minLongitude') required double minLongitude,
    @Query('maxLongitude') required double maxLongitude,
    @Query('zoom') required int zoom,
    @Query('searchQuery') String? searchQuery,
  });
}
