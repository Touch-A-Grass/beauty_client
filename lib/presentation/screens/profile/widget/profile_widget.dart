import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:beauty_client/domain/models/user.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/app_image_picker.dart';
import 'package:beauty_client/presentation/navigation/app_router.gr.dart';
import 'package:beauty_client/presentation/screens/profile/bloc/profile_bloc.dart';
import 'package:beauty_client/presentation/util/phone_formatter.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder:
          (context, state) => Scaffold(
            appBar: AppBar(title: Text(S.of(context).profile)),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child:
                  state.user == null
                      ? const Center(child: CircularProgressIndicator())
                      : Stack(
                        children: [
                          CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: EdgeInsets.only(top: 16, right: 16, left: 16),
                                sliver: SliverToBoxAdapter(child: _ProfileBadge(state.user!)),
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
                          if (state.isUpdatingUser) const Center(child: CircularProgressIndicator()),
                        ],
                      ),
            ),
          ),
    );
  }
}

class _ProfileBadge extends StatefulWidget {
  final User user;

  const _ProfileBadge(this.user);

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
        GestureDetector(
          onTap: () async {
            Uint8List? image = await AppImagePicker.pickImage(context);
            if (!context.mounted || image == null) return;
            image = await context.pushRoute<Uint8List?>(ImageCropRoute(image: image));
            if (!context.mounted || image == null) return;
            context.read<ProfileBloc>().add(ProfileEvent.updatePhotoRequested(image));
          },
          child: Stack(
            children: [
              SizedBox.square(
                dimension: 80,
                child: CircleAvatar(
                  foregroundImage: widget.user.photo != null ? CachedNetworkImageProvider(widget.user.photo!) : null,
                  child: Text(widget.user.initials),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.camera_alt_rounded, size: 32, color: Theme.of(context).colorScheme.surface),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text(widget.user.name, style: Theme.of(context).textTheme.titleMedium),
              Text(phoneFormatter.maskText(widget.user.phoneNumber)),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            showAdaptiveDialog(
              context: context,
              builder:
                  (dialogContext) => _ChangeProfileDialog(widget.user, (name) {
                    context.read<ProfileBloc>().add(ProfileEvent.updateUserRequested(name));
                  }),
            );
          },
          icon: const Icon(Icons.edit),
        ),
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
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (state, previous) => state.user?.settings != previous.user?.settings,
      builder:
          (context, state) => Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Push-уведомления', style: Theme.of(context).textTheme.headlineSmall),
              _PushSettingsItem(
                title: 'Информация о заказах',
                enabled: state.user?.settings?.receiveOrderNotifications ?? false,
                onChanged: (value) {
                  context.read<ProfileBloc>().add(ProfileEvent.updateOrderNotificationsRequested(value));
                },
              ),
              _PushSettingsItem(
                title: 'Скидки и предложения',
                enabled: state.user?.settings?.receivePromoNotifications ?? false,
                onChanged: (value) {
                  context.read<ProfileBloc>().add(ProfileEvent.updatePromoNotificationsRequested(value));
                },
              ),
            ],
          ),
    );
  }
}

class _PushSettingsItem extends StatelessWidget {
  final String title;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _PushSettingsItem({required this.title, required this.enabled, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 16,
      children: [Text(title), Switch(value: enabled, onChanged: onChanged)],
    );
  }
}

class _ChangeProfileDialog extends StatefulWidget {
  final User user;
  final ValueChanged<String> onNameChanged;

  const _ChangeProfileDialog(this.user, this.onNameChanged);

  @override
  State<_ChangeProfileDialog> createState() => _ChangeProfileDialogState();
}

class _ChangeProfileDialogState extends State<_ChangeProfileDialog> {
  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.name);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 32,
              children: [
                Text('Изменить имя', style: Theme.of(context).textTheme.titleLarge),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Имя', border: OutlineInputBorder()),
                  onChanged: (_) => setState(() {}),
                ),
                Row(
                  spacing: 16,
                  children: [
                    Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: Text('Отменить'))),
                    Expanded(
                      child: FilledButton(
                        onPressed:
                            nameController.text.isEmpty || nameController.text.trim() == widget.user.name.trim()
                                ? null
                                : () {
                                  widget.onNameChanged(nameController.text.trim());
                                  Navigator.pop(context);
                                },
                        child: Text('Сохранить'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
