// lib/domain/usecases/get_navigation_items_usecase.dart
import '../entities/navigation_item.dart';
import 'package:flutter/material.dart';

class GetNavigationItemsUseCase {
  List<NavigationItem> call() {
    return [
      const NavigationItem(
        label: 'Home',
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home_rounded),
      ),

      const NavigationItem(
        label: 'Groups',
        icon: Icon(Icons.group_outlined),
        activeIcon: Icon(Icons.group),
      ),
      const NavigationItem(
        label: 'Bookmarks',
        icon: Icon(Icons.bookmark_border_outlined),
        activeIcon: Icon(Icons.bookmark_rounded),
      ),
    ];
  }
}
