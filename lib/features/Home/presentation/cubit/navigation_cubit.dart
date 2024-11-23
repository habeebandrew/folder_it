// lib/presentation/cubit/navigation_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/navigation_item.dart';
import '../../domain/usecases/get_navigation_items_usecase.dart';

enum NavigationState { home, group, Report }

class NavigationCubit extends Cubit<NavigationState> {
  final GetNavigationItemsUseCase getNavigationItemsUseCase;

  NavigationCubit(this.getNavigationItemsUseCase) : super(NavigationState.home);


  void navigateTo(NavigationState state) => emit(state);

  List<NavigationItem> get items => getNavigationItemsUseCase();
  
}
