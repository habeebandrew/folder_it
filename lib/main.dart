import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/core/Util/app_bloc_observer.dart';
import 'package:folder_it/core/Util/app_routes.dart';
import 'package:folder_it/core/Util/theme.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/Groups/presentation/cubit/group_cubit.dart';
import 'package:folder_it/features/Home/presentation/cubit/theme_cubit.dart';
import 'package:folder_it/features/User/presentation/cubit/user_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper().init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => GroupCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkTheme) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Folder it now',
            routerConfig: router,
            theme: ThemeColors.ligthTheme,
            darkTheme: ThemeColors.darkTheme,
            themeMode: isDarkTheme
                ? ThemeMode.dark
                : ThemeMode.light,
          );
        },
      ),
    );
  }
}
