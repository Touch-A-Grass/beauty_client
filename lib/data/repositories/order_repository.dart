import 'dart:async';

import 'package:beauty_client/data/api/beauty_client.dart';
import 'package:beauty_client/data/models/requests/create_order_request.dart';
import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final BeautyClient _client;

  OrderRepositoryImpl(this._client);

  final _createdOrderStream = StreamController<Order>.broadcast();

  @override
  Future<void> createOrder({
    required Venue venue,
    required Service service,
    required Staff staff,
    required DateTime startDate,
    required String comment,
    DateTime? endDate,
  }) async {
    return _client.createOrder(CreateOrderRequest(serviceId: service.id, staffId: staff.id, startTimestamp: startDate));
  }

  @override
  Future<Order> getOrder(String id) async {
    return _client.getOrder(id);
  }

  @override
  Future<List<Order>> getOrders({required int limit, required int offset}) async {
    return _client.getOrders(limit: limit, offset: offset);
  }

  @override
  Stream<Order> watchCreatedOrderEvent() => _createdOrderStream.stream;
}
