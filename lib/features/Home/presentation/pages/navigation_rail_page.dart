// lib/presentation/pages/navigation_rail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/features/Groups/presentation/pages/invites_page.dart';
import 'package:folder_it/features/Home/domain/usecases/get_navigation_items_usecase.dart';
import 'package:folder_it/features/Home/presentation/cubit/theme_cubit.dart';
import '../cubit/navigation_cubit.dart';
import 'my_files_page.dart';
import 'report_page.dart';
import '../../../Groups/presentation/pages/View_Groups.dart';
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

    return BlocProvider(
      create: (context) => NavigationCubit(GetNavigationItemsUseCase()),
      child: Scaffold(
        appBar: AppBar(
          //backgroundColor: Theme.of(context).primaryColor,
          title: Row(
            children: [
              const Icon(Icons.folder, color: Colors.yellow, size: 30),
              const SizedBox(width: 10),
              Text(
                "FOLDERIT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                ),
              ),
            ],
          ),
          actions: [
            BlocBuilder<ThemeCubit, bool>(
              builder: (context, state) {
                return Tooltip(message: "dark mode",//todo:هون تكون متحول حسب وضع الثيم اذا دارك او لايت
                  child: IconButton(
                      onPressed: () {
                        ThemeCubit.get(context).toggleTheme();
                      },
                      icon: const Icon(Icons.dark_mode,color: Colors.yellow,)),
                );
              },
            ),
            Stack(
              children: [
                badges.Badge(
                  badgeContent: const Text(
                    '3',
                    style: TextStyle(color: Colors.white),
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
                            builder: (context) {
                              //GroupCubit.get(context).viewMyInvites();
                              return const InvitesPage();
                            });
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
            const VerticalDivider(thickness: 1, width: 1,color: Colors.grey,),
            Expanded(
              child: BlocBuilder<NavigationCubit, NavigationState>(
                builder: (context, state) {
                  switch (state) {
                    case NavigationState.home:
                      return const MyFilePage();
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
