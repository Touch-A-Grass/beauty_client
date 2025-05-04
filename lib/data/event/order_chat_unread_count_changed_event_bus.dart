import 'package:beauty_client/data/event/base/event_bus.dart';

class OrderChatUnreadCountChangedEvent {
  final String orderId;
  final int count;

  const OrderChatUnreadCountChangedEvent({required this.orderId, required this.count});
}

class OrderChatUnreadCountChangedEventBus extends EventBus<OrderChatUnreadCountChangedEvent> {}
