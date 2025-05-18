import 'package:beauty_client/domain/models/order.dart';
import 'package:beauty_client/features/chat/domain/models/chat_event.dart';
import 'package:beauty_client/features/chat/presentation/components/chat_view.dart';
import 'package:beauty_client/features/chat/presentation/screens/order_chat/bloc/order_chat_bloc.dart';
import 'package:beauty_client/presentation/components/app_back_button.dart';
import 'package:beauty_client/presentation/components/venue_theme_builder.dart';
import 'package:beauty_client/presentation/models/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderChatWidget extends StatelessWidget {
  const OrderChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderChatBloc, OrderChatState>(
      builder:
          (context, state) => VenueThemeBuilder(
            venueId:
                state.orderState is SuccessLoadingState<Order>
                    ? (state.orderState as SuccessLoadingState<Order>).data.venue.id
                    : '',
            builder:
                (context) => Scaffold(
                  appBar: AppBar(title: const Text('Чат'), leading: AppBackButton()),
                  body: switch (state.messagesState) {
                    ProgressLoadingState<List<ChatEvent>>() => Center(child: CircularProgressIndicator()),
                    SuccessLoadingState<List<ChatEvent>> messages => ChatView(
                      events: messages.data,
                      onSend:
                          state.sendingMessageState is! ProgressSendingState
                              ? (message) {
                                context.read<OrderChatBloc>().add(OrderChatEvent.sendMessageRequested(message));
                              }
                              : null,
                      onSendImage:
                          state.sendingMessageState is! ProgressSendingState
                              ? (image) {
                                context.read<OrderChatBloc>().add(OrderChatEvent.sendImageRequested(image));
                              }
                              : null,
                    ),
                    ErrorLoadingState<List<ChatEvent>> error => Center(child: Text(error.error.message)),
                  },
                ),
          ),
    );
  }
}
