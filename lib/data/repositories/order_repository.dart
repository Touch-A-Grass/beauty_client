import 'dart:async';

import 'package:beauty_client/data/api/beauty_client.dart';
import 'package:beauty_client/data/event/order_changed_event_bus.dart';
import 'package:beauty_client/data/event/order_created_event_bus.dart';
import 'package:beauty_client/data/models/requests/create_order_request.dart';
import 'package:beauty_client/data/models/requests/mark_as_read_request.dart';
import 'package:beauty_client/data/models/requests/send_message_request.dart';
import 'package:beauty_client/data/models/requests/update_record_request.dart';
import 'package:beauty_client/data/util/string_util.dart';
import 'package:beauty_client/data/websocket_api/websocket_api.dart';
import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/domain/models/order_review.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/domain/repositories/order_repository.dart';
import 'package:beauty_client/features/chat/data/mappers/chat_event_mapper.dart';
import 'package:beauty_client/features/chat/data/models/messages/order_chat_socket_message.dart';
import 'package:beauty_client/features/chat/domain/models/chat_event.dart';
import 'package:beauty_client/features/chat/domain/models/chat_live_event.dart';
import 'package:beauty_client/features/chat/domain/models/chat_message_info.dart';

class OrderRepositoryImpl implements OrderRepository {
  final BeautyClient _client;
  final OrderChangedEventBus _orderChangedEventBus;
  final OrderCreatedEventBus _orderCreatedEventBus;
  final WebsocketApi _websocketApi;

  @override
  OrderRepositoryImpl(this._client, this._orderChangedEventBus, this._orderCreatedEventBus, this._websocketApi);

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

  @override
  Future<void> rateOrder(String orderId, OrderReview review) async {
    await _client.updateOrder(
      UpdateRecordRequest(
        recordId: orderId,
        review: RecordReviewDto(rating: review.rating, comment: review.comment.trimOrNull),
      ),
    );
  }

  @override
  Future<List<ChatEventInfo>> getChatEvents(String orderId) async {
    final eventsDto = await _client.getOrderMessages(orderId);
    return eventsDto.map((e) => ChatEventInfoMapper.fromDto(e)).nonNulls.toList();
  }

  @override
  Future<void> sendChatMessage({required String orderId, required String message, required String messageId}) {
    return _client.sendOrderMessage(orderId, SendMessageRequest(text: message, messageId: messageId));
  }

  @override
  Future<void> markAsRead({required String orderId, required List<String> messageIds}) {
    return _client.markAsRead(orderId, MarkAsReadRequest(messageIds: messageIds));
  }

  @override
  Stream<ChatLiveEvent> watchOrderChatEvents(String orderId) {
    return _websocketApi
        .connectToOrderChat(orderId)
        .map(
          (e) => switch (e) {
            MessageReceivedOrderChatSocketMessage message => ChatLiveEvent.eventReceived(
              ChatEventInfo.message(
                ChatMessageInfo(
                  senderId: message.senderId,
                  createdAt: message.createdAt.toLocal(),
                  readAt: null,
                  isRead: false,
                  text: message.message,
                  id: message.messageId,
                ),
              ),
            ),
            MessageReadOrderChatSocketMessage e => ChatLiveEvent.messageRead(e.messageId),
          },
        );
  }
}
