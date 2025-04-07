import 'dart:async';

import 'package:beauty_client/data/api/beauty_client.dart';
import 'package:beauty_client/data/event/order_changed_event_bus.dart';
import 'package:beauty_client/data/event/order_created_event_bus.dart';
import 'package:beauty_client/data/models/requests/create_order_request.dart';
import 'package:beauty_client/data/models/requests/update_record_request.dart';
import 'package:beauty_client/data/util/string_util.dart';
import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final BeautyClient _client;
  final OrderChangedEventBus _orderChangedEventBus;
  final OrderCreatedEventBus _orderCreatedEventBus;

  @override
  OrderRepositoryImpl(this._client, this._orderChangedEventBus, this._orderCreatedEventBus);

  @override
  Future<void> createOrder({
    required Venue venue,
    required Service service,
    required Staff staff,
    required DateTime startDate,
    required String comment,
    DateTime? endDate,
  }) async {
    await _client.createOrder(
      CreateOrderRequest(
        serviceId: service.id,
        staffId: staff.id,
        startTimestamp: startDate,
        comment: comment.trimOrNull,
      ),
    );
    _orderCreatedEventBus.emit(null);
  }

  @override
  Future<Order> getOrder(String id) async {
    final order = await _client.getOrder(id);
    _orderChangedEventBus.emit(order);
    return order;
  }

  @override
  Future<List<Order>> getOrders({required int limit, required int offset}) async {
    return _client.getOrders(limit: limit, offset: offset);
  }

  @override
  Future<void> discardOrder(String id) async {
    await _client.updateOrder(UpdateRecordRequest(recordId: id, status: OrderStatus.discarded));
  }

  @override
  Stream<Order> watchOrderChanged() => _orderChangedEventBus.stream;

  @override
  Stream<void> watchOrderCreated() => _orderCreatedEventBus.stream;
}
