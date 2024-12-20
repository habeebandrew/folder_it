// lib/domain/usecases/get_navigation_items_usecase.dart
import '../entities/navigation_item.dart';
import 'package:flutter/material.dart';

class GetNavigationItemsUseCase {
  List<NavigationItem> call() {
    return [
      const NavigationItem(
        label: 'My Files',
        icon: Icon(Icons.folder_copy_outlined),
        activeIcon: Icon(Icons.folder_copy_rounded),
      ),

      const NavigationItem(
        label: 'Groups',
        icon: Icon(Icons.group_outlined),
        activeIcon: Icon(Icons.group),
      ),
      const NavigationItem(
        label: 'My Tasks',
        icon: Icon(Icons.task_alt_outlined),
        activeIcon: Icon(Icons.task_alt_outlined),
      ),
      const NavigationItem(
        label: 'Log Out',
        icon: Icon(Icons.logout_outlined),
        activeIcon: Icon(Icons.logout_rounded),
      ),
    ];
  }
}
