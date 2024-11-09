// lib/data/models/navigation_item_model.dart
import '../../domain/entities/navigation_item.dart';


class NavigationItemModel extends NavigationItem {
  const NavigationItemModel({
    required super.label,
    required super.icon,
    required super.activeIcon,
  });

  factory NavigationItemModel.fromEntity(NavigationItem entity) {
    return NavigationItemModel(
      label: entity.label,
      icon: entity.icon,
      activeIcon: entity.activeIcon,
    );
  }
}
