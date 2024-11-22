import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/core/Util/app_bloc_observer.dart';
import 'package:folder_it/core/Util/app_routes.dart';
import 'package:folder_it/core/Util/colors.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/Groups/presentation/cubit/group_cubit.dart';
import 'package:folder_it/features/Home/domain/usecases/get_navigation_items_usecase.dart';
import 'package:folder_it/features/Home/presentation/cubit/navigation_cubit.dart';
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
            create: (_) => NavigationCubit(GetNavigationItemsUseCase())),
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => GroupCubit(),
        ),
      ],
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Folder it now',
            routerConfig: router,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: const Color(primaryValue),
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: customSwatch,
                brightness: Brightness.light,
              ).copyWith(
                secondary: const Color(0xFF64B5F6),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(primaryValue),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                iconTheme: IconThemeData(color: Colors.white),
              ),
              textTheme: const TextTheme(
                  displayLarge: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(primaryValue)),
                  displayMedium: TextStyle(fontSize: 17, color: Colors.black87),
                  bodyLarge: TextStyle(fontSize: 20, color: Colors.black87),
                  bodyMedium: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  bodySmall: TextStyle(fontSize: 15, color: Colors.white)),
              buttonTheme: ButtonThemeData(
                buttonColor: const Color(primaryValue),
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              cardColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black54),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(primaryValue),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                ),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Color(primaryValue)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.black26),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Color(primaryValue)),
                ),
                labelStyle: TextStyle(color: Colors.black87),
                hintStyle: TextStyle(color: Colors.black54),
              ),
              checkboxTheme: CheckboxThemeData(
                checkColor: WidgetStateProperty.all(Colors.white),
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(primaryValue);
                  }
                  return Colors.white;
                }),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            //! dark teme
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                primaryColor: const Color(primaryValue),
                scaffoldBackgroundColor: const Color(0xFF121212),
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: customSwatch,
                  brightness: Brightness.dark,
                ).copyWith(
                  secondary: const Color(0xFF64B5F6),
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF1E1E1E),
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                textTheme: const TextTheme(
                        displayLarge: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        displayMedium:
                            TextStyle(fontSize: 17, color: Colors.black87),
                        bodyLarge:
                            TextStyle(fontSize: 20, color: Colors.black87),
                        bodyMedium: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        bodySmall: TextStyle(fontSize: 15, color: Colors.white))
                    .apply(
                  bodyColor: Colors.white,
                ),
                buttonTheme: ButtonThemeData(
                  buttonColor: const Color(primaryValue),
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                cardColor: const Color(0xFF1E1E1E),
                iconTheme: const IconThemeData(color: Colors.white70),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(primaryValue),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                  ),
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: Color(0xFF2C2C2C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(primaryValue)),
                  ),
                  labelStyle: TextStyle(color: Colors.white60),
                  hintStyle: TextStyle(color: Colors.white54),
                ),
                checkboxTheme: CheckboxThemeData(
                  checkColor: WidgetStateProperty.all(Colors.white),
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Color(primaryValue);
                    }
                    return Colors.black38;
                  }),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                snackBarTheme: const SnackBarThemeData(
                    contentTextStyle: TextStyle(color: Colors.white))),
            themeMode: NavigationCubit.get(context).toggle
                ? ThemeMode.dark
                : ThemeMode.light,
          );
        },
      ),
    );
  }
}
