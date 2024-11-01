// lib/presentation/widgets/custom_navigation_rail.dart
import 'package:flutter/material.dart';
import '../../domain/entities/navigation_item.dart';

class CustomNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;
  final List<NavigationItem> items;

  const CustomNavigationRail({super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.extended = false,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      extended: extended,
      destinations: items
          .map((item) => NavigationRailDestination(
        icon: item.icon,
        selectedIcon: item.activeIcon,
        label: Text(item.label,
          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
        ),
      ))
          .toList(),
    );
  }
}
