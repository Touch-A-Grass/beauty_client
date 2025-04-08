import 'package:auto_route/annotations.dart';
import 'package:beauty_client/presentation/screens/dashboard/bloc/dashboard_bloc.dart';
import 'package:beauty_client/presentation/screens/dashboard/widget/dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              DashboardBloc(context.read(), context.read(), context.read(), context.read())
                ..add(DashboardEvent.started()),
      child: const DashboardWidget(),
    );
  }
}
