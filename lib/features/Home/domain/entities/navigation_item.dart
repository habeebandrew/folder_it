// lib/domain/entities/navigation_item.dart
import 'package:flutter/material.dart';

class NavigationItem {
  final String label;
  final Icon icon;
  final Icon activeIcon;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
