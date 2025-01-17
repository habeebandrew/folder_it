// lib/domain/usecases/get_navigation_items_usecase.dart
import '../../../../localization/localization.dart';
import '../entities/navigation_item.dart';
import 'package:flutter/material.dart';

class GetNavigationItemsUseCase {
  List<NavigationItem> call(BuildContext context) {
    return [
       NavigationItem(
        label: "${AppLocalization.of(context)?.translate("My_Files")}" ,
        icon: const Icon(Icons.folder_copy_outlined),
        activeIcon: const Icon(Icons.folder_copy_rounded),
      ),

       NavigationItem(
        label: "${AppLocalization.of(context)?.translate("Groups")}" ,
        icon: const Icon(Icons.group_outlined),
        activeIcon: const Icon(Icons.group),
      ),
       NavigationItem(
        label: "${AppLocalization.of(context)?.translate("My_Tasks")}",
        icon: const Icon(Icons.task_alt_outlined),
        activeIcon: const Icon(Icons.task_alt_outlined),
      ),
       NavigationItem(
        label:  "${AppLocalization.of(context)?.translate("logout")}",
        icon: const Icon(Icons.logout_outlined),
        activeIcon: const Icon(Icons.logout_rounded),
      ),
    ];
  }
}
