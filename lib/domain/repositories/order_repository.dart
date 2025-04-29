import 'package:beauty_client/features/chat/domain/models/chat_event.dart';
import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/domain/models/order_review.dart';
import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/domain/models/venue.dart';
import 'package:beauty_client/features/chat/domain/models/chat_live_event.dart';

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

  Future<Order> getOrder(String id);

  Future<void> rateOrder(String orderId, OrderReview review);

  Future<void> discardOrder(String id);

  Stream<void> watchOrderCreated();

  Future<List<ChatEventInfo>> getChatEvents(String orderId);

  Future<void> sendChatMessage({required String orderId, required String message, required String messageId});

  Stream<Order> watchOrderChanged();

  Stream<ChatLiveEvent> watchOrderChatEvents(String orderId);

  Future<void> markAsRead({required String orderId, required List<String> messageIds});
}
