import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/app_overlay.dart';
import 'package:beauty_client/presentation/screens/profile/bloc/profile_bloc.dart';
import 'package:beauty_client/presentation/util/phone_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final phoneFormatter = AppFormatters.createPhoneFormatter();

  @override
  Widget build(BuildContext context) {
    return AppOverlay(
      child: Scaffold(
        appBar: AppBar(title: Text(S.of(context).profile)),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(top: 32, right: 16, left: 16),
              sliver: SliverToBoxAdapter(child: _ProfileBadge()),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 64, right: 16, left: 16),
              sliver: SliverToBoxAdapter(child: _Settings()),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
                  child: _Footer(
                    onLogoutPressed: () {
                      context.read<ProfileBloc>().add(const ProfileEvent.logoutRequested());
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileBadge extends StatefulWidget {
  const _ProfileBadge();

  @override
  State<_ProfileBadge> createState() => _ProfileBadgeState();
}

class _ProfileBadgeState extends State<_ProfileBadge> {
  final phoneFormatter = AppFormatters.createPhoneFormatter();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox.square(dimension: 80, child: CircleAvatar(child: Icon(Icons.person))),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text('Krushiler', style: Theme.of(context).textTheme.titleMedium),
              Text(phoneFormatter.maskText('+79140060868')),
            ],
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onLogoutPressed;

  const _Footer({required this.onLogoutPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 32,
      children: [
        SizedBox(
          height: 48,
          child: OutlinedButton(onPressed: onLogoutPressed, child: Text(S.of(context).logoutButton)),
        ),
        SizedBox(
          height: 48,
          child: TextButton(
            onPressed: onLogoutPressed,
            child: Text('Удалить аккаунт', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ),
      ],
    );
  }
}

class _Settings extends StatelessWidget {
  const _Settings();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Push-уведомления', style: Theme.of(context).textTheme.headlineSmall),
        _PushSettingsItem(title: 'Информация о заказах', enabled: true),
        _PushSettingsItem(title: 'Скидки и предложения', enabled: true),
      ],
    );
  }
}

class _PushSettingsItem extends StatelessWidget {
  final String title;
  final bool enabled;

  const _PushSettingsItem({required this.title, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 16,
      children: [Text(title), Switch(value: enabled, onChanged: (_) {})],
    );
  }
}
