// lib/presentation/pages/navigation_rail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/features/Group_Browser/presentation/group_pages/my_task_on_group.dart';
import 'package:folder_it/features/Groups/presentation/pages/invites_page.dart';
import 'package:folder_it/features/Home/domain/usecases/get_navigation_items_usecase.dart';
import 'package:folder_it/features/Home/presentation/cubit/theme_cubit.dart';
import 'package:folder_it/features/Home/presentation/pages/mytasks.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/databases/cache/cache_helper.dart';
import '../../../../localization/localization.dart';
import '../../../../main.dart';
import '../cubit/navigation_cubit.dart';
import 'my_files_page.dart';
import 'package:http/http.dart' as http;
import '../../../Groups/presentation/pages/View_Groups.dart';
import '../widgets/custom_navigation_rail.dart';
import 'package:badges/badges.dart' as badges;

class NavigationRailPage extends StatefulWidget {
  const NavigationRailPage({super.key, required this.notificationCount});
  final int notificationCount;

  @override
  State<NavigationRailPage> createState() => _NavigationRailPageState();
}

class _NavigationRailPageState extends State<NavigationRailPage> {
  bool _hasRun = false;

  @override
  void initState() {
    super.initState();
    if (!_hasRun) {
      _hasRun = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TokenHandler().startTokenProcess(context);
      });
    }
  }

  void _toggleLanguage() {
    final currentLocale = Localizations.localeOf(context);
    final newLocale = currentLocale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
    MyApp.setLocale(context, newLocale);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 800;

    return BlocProvider(
      create: (context) => NavigationCubit(GetNavigationItemsUseCase()),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Icon(Icons.folder, color: Colors.yellow, size: 30),
              // const SizedBox(width: 10),
              Text(
                AppLocalization.of(context)?.translate("app_title") ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme
                      .of(context)
                      .textTheme
                      .bodyLarge!
                      .fontSize,
                ),
              ),
            ],
          ),
          actions: [
            BlocBuilder<ThemeCubit, bool>(
              builder: (context, isDarkTheme) {
                return Tooltip(
                  message: AppLocalization.of(context)?.translate(
                    isDarkTheme ? "dark_mode" : "light_mode",
                  ) ??
                      "",
                  child: IconButton(
                    onPressed: () {
                      ThemeCubit.get(context).toggleTheme();
                    },
                    icon: Icon(
                      isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                      color: Colors.yellow,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.language, color: Colors.yellow),
              onPressed: _toggleLanguage,
              tooltip: AppLocalization.of(context)?.translate("tranlate"),
            ),
            badges.Badge(
              badgeContent: Text(
                '${widget.notificationCount}',
                style: const TextStyle(color: Colors.white),
              ),
              showBadge: widget.notificationCount > 0,
              position: badges.BadgePosition.topEnd(top: 0, end: 0),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.red,
              ),
              child: PopupMenuButton<int>(
                icon: const Icon(Icons.notifications, color: Colors.yellow),
                itemBuilder: (context) =>
                [
                  PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      leading: const Icon(Icons.message, color: Colors.blue),
                      title: Text(AppLocalization.of(context)?.translate(
                          "view_invites") ?? ""),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: ListTile(
                      leading: const Icon(Icons.update, color: Colors.green),
                      title: Text(AppLocalization.of(context)?.translate(
                          "new_update") ?? ""),
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: ListTile(
                      leading: const Icon(Icons.warning, color: Colors.red),
                      title: Text(AppLocalization.of(context)?.translate(
                          "warning") ?? ""),
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 1) {
                    showDialog(
                      context: context,
                      builder: (context) => const InvitesPage(),
                    );
                  }
                },
              ),
            ),
            // Tooltip(
            //   message: AppLocalization.of(context)?.translate("instructions") ??
            //       "",
            //   child: TextButton(
            //     onPressed: () {},
            //     child: const Icon(
            //         Icons.question_mark_sharp, color: Colors.yellow),
            //   ),
            // ),
            // const SizedBox(width: 20),
          ],
        ),
        drawer: isSmallScreen
            ? Drawer(
          child: BlocBuilder<NavigationCubit, NavigationState>(
            builder: (context, state) {
              final cubit = context.read<NavigationCubit>();
              return CustomNavigationRail(
                selectedIndex: NavigationState.values.indexOf(state),
                onDestinationSelected: (index) =>
                    cubit.navigateTo(NavigationState.values[index]),
                extended: true,
                items: cubit.items,
              );
            },
          ),
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
            if (!isSmallScreen)
              const VerticalDivider(thickness: 1, width: 1, color: Colors.grey),
            Expanded(
              child: BlocBuilder<NavigationCubit, NavigationState>(
                builder: (context, state) {
                  switch (state) {
                    case NavigationState.home:
                      return const MyFilePage();
                    case NavigationState.group:
                      return const Groups();
                    case NavigationState.myTasks:
                      return const MyTasks();
                    case NavigationState.Report:
                      return AlertDialog(
                        title: Text(AppLocalization.of(context)?.translate(
                            "warning") ?? ""),
                        content: Text(AppLocalization.of(context)?.translate(
                            "confirm_logout") ?? ""),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              _logout(context);
                            },
                            child: Text(AppLocalization.of(context)?.translate(
                                "confirm") ?? ""),
                          ),
                        ],
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    const url = 'http://localhost:8091/auth/logout';

    String mytoken = CacheHelper().getData(key: 'token');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $mytoken',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            AppLocalization.of(context)?.translate("logout_success") ?? "")),
      );
      context.go("/login");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            AppLocalization.of(context)?.translate("logout_failure") ?? "")),
      );
    }
  }
}
