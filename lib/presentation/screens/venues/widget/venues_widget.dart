import 'package:beauty_client/generated/l10n.dart';
import 'package:beauty_client/presentation/screens/venues/list/venue_list.dart';
import 'package:beauty_client/presentation/screens/venues/map/venue_map.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VenuesWidget extends StatefulWidget {
  const VenuesWidget({super.key});

  @override
  State<VenuesWidget> createState() => _VenuesWidgetState();
}

class VenuesSearchController extends TextEditingController {
  VenuesSearchController() : super(text: '');
}

class _VenuesWidgetState extends State<VenuesWidget> with TickerProviderStateMixin {
  final venuesSearchController = VenuesSearchController();

  final searchControllerFocusNode = FocusNode();
  bool _isSearching = false;

  set isSearching(bool value) {
    if (value == _isSearching) return;
    setState(() {
      _isSearching = value;
    });
    if (value) {
      searchFieldAnimationController.forward();
    } else {
      searchControllerFocusNode.unfocus();
      venuesSearchController.clear();
      searchFieldAnimationController.reverse();
    }
  }

  bool get isSearching => _isSearching;

  late final AnimationController searchFieldAnimationController;

  @override
  void initState() {
    searchFieldAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    super.initState();
  }

  @override
  void dispose() {
    searchFieldAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: () async {
        if (isSearching) {
          isSearching = false;
          return true;
        }
        return false;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SafeArea(
            bottom: false,
            child: ChangeNotifierProvider.value(
              value: venuesSearchController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: AnimatedBuilder(
                      animation: Listenable.merge([searchFieldAnimationController, venuesSearchController]),
                      builder: (context, _) {
                        final foregroundColor =
                            Color.lerp(
                              Theme.of(context).colorScheme.onSurface,
                              Theme.of(context).colorScheme.onPrimaryContainer,
                              1 - searchFieldAnimationController.value,
                            )!;

                        final backgroundColor = Color.lerp(
                          Theme.of(context).colorScheme.surfaceContainer,
                          Theme.of(context).colorScheme.primaryContainer,
                          1 - searchFieldAnimationController.value,
                        );

                        return TextField(
                          style: TextStyle(color: foregroundColor),
                          focusNode: searchControllerFocusNode,
                          controller: venuesSearchController,
                          cursorColor: foregroundColor,
                          textAlignVertical: TextAlignVertical.center,
                          onTap: () {
                            isSearching = true;
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              isSearching = true;
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(16),
                            filled: true,
                            fillColor: backgroundColor,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            hintStyle: TextStyle(color: foregroundColor.withValues(alpha: 0.5)),
                            hintText: 'Поиск',
                            prefixIcon:
                                !isSearching
                                    ? null
                                    : Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: BackButton(onPressed: () => isSearching = false),
                                    ),
                            suffixIcon:
                                isSearching && venuesSearchController.text.isEmpty
                                    ? null
                                    : Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child:
                                          isSearching
                                              ? IconButton(
                                                color: foregroundColor,
                                                onPressed: () => venuesSearchController.clear(),
                                                icon: Icon(Icons.close_rounded),
                                              )
                                              : IconButton(
                                                color: foregroundColor,
                                                onPressed: () => isSearching = true,
                                                icon: Icon(Icons.search_rounded),
                                              ),
                                    ),
                          ),
                        );
                      },
                    ),
                  ),
                  TabBar(
                    tabs: [Tab(text: S.of(context).dashboardListButton), Tab(text: S.of(context).dashboardMapButton)],
                  ),
                  Expanded(child: TabBarView(children: [VenueList(), VenueMap()])),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
