import 'package:beauty_client/domain/models/staff.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:flutter/material.dart';

class StaffListItem extends StatelessWidget {
  final Staff staff;
  final VoidCallback? onTap;
  final bool isError;

  const StaffListItem({super.key, required this.staff, this.onTap, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border.all(
          color: isError ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Text(staff.name, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ),
    );
  }
}

class StaffListItemPlaceholder extends StatelessWidget {
  final VoidCallback? onTap;

  const StaffListItemPlaceholder({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border.all(color: Theme.of(context).colorScheme.error),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Text(S.of(context).cartSelectMasterButton, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ),
    );
  }
}
