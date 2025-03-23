import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/venue.dart';

abstract interface class OrderRepository {
  Future<void> createOrder({
    required Venue venue,
    required Service service,
    required Staff staff,
    required DateTime startDate,
    required String comment,
    DateTime? endDate,
  });

  Future<List<Order>> getOrders({required int limit, required int offset});

  Stream<Order> watchCreatedOrderEvent();
}
