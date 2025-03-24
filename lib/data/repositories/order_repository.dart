import 'dart:async';

import 'package:beauty_client/data/api/beauty_client.dart';
import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final BeautyClient _client;

  OrderRepositoryImpl(this._client);

  final _orders = <Order>[];

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
    // return _client.createOrder(CreateOrderRequest(serviceId: service.id, staffId: staff.id, startTimestamp: startDate));
    await Future.delayed(Duration(milliseconds: 500));
    final order = Order(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      venue: venue,
      service: service,
      staff: staff,
      startTimestamp: startDate,
      endTimestamp: endDate ?? startDate.add(service.duration ?? Duration(minutes: 30)),
      comment: comment,
    );
    _orders.add(order);
    _createdOrderStream.add(order);
  }

  @override
  Future<Order> getOrder(String id) async {
    await Future.delayed(Duration(milliseconds: 500));
    return _orders.firstWhere((order) => order.id == id);
  }

  @override
  Future<List<Order>> getOrders({required int limit, required int offset}) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (offset >= _orders.length) return [];
    if (offset + limit > _orders.length) return _orders.sublist(offset);
    return _orders.sublist(offset, offset + limit);
  }

  @override
  Stream<Order> watchCreatedOrderEvent() => _createdOrderStream.stream;
}
