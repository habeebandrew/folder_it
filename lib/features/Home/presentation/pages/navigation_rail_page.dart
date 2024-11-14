// lib/presentation/pages/navigation_rail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/Groups/presentation/cubit/group_cubit.dart';
import 'package:folder_it/features/Groups/presentation/pages/invites_page.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecases/get_navigation_items_usecase.dart';
import '../cubit/navigation_cubit.dart';
import 'home_page.dart';
import 'report_page.dart';
import '../../../Groups/presentation/pages/Groups.dart';
import '../widgets/custom_navigation_rail.dart';
import 'package:badges/badges.dart' as badges;

class NavigationRailPage extends StatelessWidget {
  const NavigationRailPage({super.key, required this.notificationCount});
  //!طبعا هاي بتجي من ال api
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 800;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NavigationCubit(GetNavigationItemsUseCase()),
        ),
        BlocProvider(
          create: (context) => GroupCubit(),
        ),
        
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Row(
            children: [
              Icon(Icons.folder, color: Colors.yellow),
              SizedBox(width: 8),
              Text("FOLDERIT", style: TextStyle(color: Colors.white)),
            ],
          ),
          actions: [
            Stack(
              children: [
                badges.Badge(
                  badgeContent: Text(
                    '3',
                    style: const TextStyle(color: Colors.white),
                  ),
                  showBadge: notificationCount > 0,
                  position: badges.BadgePosition.topEnd(top: 0, end: 0),
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.red,
                  ),
                  child: PopupMenuButton<int>(
                    icon: const Icon(Icons.notifications, color: Colors.yellow),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,
                        child: ListTile(
                          leading: Icon(Icons.message, color: Colors.blue),
                          title: Text('view invites'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: ListTile(
                          leading: Icon(Icons.update, color: Colors.green),
                          title: Text('new Update '),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 3,
                        child: ListTile(
                          leading: Icon(Icons.warning, color: Colors.red),
                          title: Text('Warning'),
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 1) {
                        showDialog(
                          context: context,
                          builder: (context) => const InvitesPage(),
                        );
                        GroupCubit.get(context).viewMyInvites();
                      } else if (value == 2) {
                        // context.go('/update');
                      } else if (value == 3) {
                        // context.go('/warnings');
                      }
                    },
                  ),
                ),
              ],
            ),
            Tooltip(
              message: 'Instructions',
              child: TextButton(
                onPressed: () {},
                child:
                    const Icon(Icons.question_mark_sharp, color: Colors.yellow),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        bottomNavigationBar: isSmallScreen
            ? BlocBuilder<NavigationCubit, NavigationState>(
                builder: (context, state) {
                  final cubit = context.read<NavigationCubit>();
                  return BottomNavigationBar(
                    currentIndex: NavigationState.values.indexOf(state),
                    onTap: (index) =>
                        cubit.navigateTo(NavigationState.values[index]),
                    items: cubit.items
                        .map((item) => BottomNavigationBarItem(
                              icon: item.icon,
                              activeIcon: item.activeIcon,
                              label: item.label,
                            ))
                        .toList(),
                  );
                },
              )
            : null,
        body: Row(
          children: <Widget>[
            if (!isSmallScreen)
              BlocBuilder<NavigationCubit, NavigationState>(
                builder: (context, state) {
                  final cubit = context.read<NavigationCubit>();
                  return CustomNavigationRail(
                    selectedIndex: NavigationState.values.indexOf(state),
                    onDestinationSelected: (index) =>
                        cubit.navigateTo(NavigationState.values[index]),
                    extended: isLargeScreen,
                    items: cubit.items,
                  );
                },
              ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: BlocBuilder<NavigationCubit, NavigationState>(
                builder: (context, state) {
                  switch (state) {
                    case NavigationState.home:
                      return const HomePage();
                    case NavigationState.group:
                      return const Groups();
                    case NavigationState.Report:
                      return const ReportPage();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
