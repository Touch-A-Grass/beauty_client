import 'package:beauty_client/domain/models/service.dart';
import 'package:beauty_client/domain/models/staff_time_slot.dart';
import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/components/app_draggable_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectTimeslotSheet extends StatelessWidget {
  final List<StaffTimeSlot> timeSlots;
  final Service service;

  const SelectTimeslotSheet({super.key, required this.timeSlots, required this.service});

  @override
  Widget build(BuildContext context) {
    final duration = service.duration ?? Duration(hours: 1);
    final modifiedTimeSlots =
        timeSlots
            .where(
              (timeSlot) => timeSlot.intervals.any((interval) => interval.end.difference(interval.start) >= duration),
            )
            .toList();

    return AppDraggableModalSheet(
      builder:
          (context, scrollController) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                        sliver: SliverToBoxAdapter(
                          child: Text(S.of(context).cartDateTitle, style: Theme.of(context).textTheme.headlineSmall),
                        ),
                      ),
                      for (final timeSlot in modifiedTimeSlots)
                        SliverPadding(
                          padding: const EdgeInsets.only(top: 16),
                          sliver: _TimeSlotSliver(timeSlot, duration),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class _TimeSlotSliver extends StatefulWidget {
  final StaffTimeSlot staffTimeSlot;
  final Duration serviceDuration;

  const _TimeSlotSliver(this.staffTimeSlot, this.serviceDuration);

  @override
  State<_TimeSlotSliver> createState() => _TimeSlotSliverState();
}

class _TimeSlotSliverState extends State<_TimeSlotSliver> {
  final dateFormat = DateFormat('d MMMM, EEEE');
  final timeFormat = DateFormat('HH:mm');

  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final slots = <DateTime>[];

    for (final interval in widget.staffTimeSlot.intervals) {
      var currentTime = interval.start;
      while (currentTime.add(widget.serviceDuration).isBefore(interval.end) ||
          currentTime.add(widget.serviceDuration).isAtSameMomentAs(interval.end)) {
        slots.add(currentTime);
        currentTime = currentTime.add(widget.serviceDuration);
      }
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AnimatedSize(
            alignment: Alignment.topCenter,
            duration: const Duration(milliseconds: 250),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => setState(() => expanded = !expanded),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          dateFormat.format(widget.staffTimeSlot.date),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                        onPressed: () => setState(() => expanded = !expanded),
                      ),
                    ],
                  ),
                ),
                if (expanded)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 24,
                      runSpacing: 24,
                      children:
                          slots
                              .map(
                                (e) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () => Navigator.pop(context, e),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        child: Text(
                                          timeFormat.format(e),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
