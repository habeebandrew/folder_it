import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/core/Util/app_bloc_observer.dart';
import 'package:folder_it/core/Util/app_routes.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/Groups/presentation/cubit/GroupCreationCubit.dart';
import 'package:folder_it/features/Groups/presentation/cubit/group_cubit.dart';
import 'package:folder_it/features/User/presentation/cubit/user_cubit.dart';

import 'features/Groups/presentation/cubit/GroupsCubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper().init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const int _primaryValue = 0Xff0b3153;

  static const MaterialColor customSwatch = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFE2E7EB),
      100: Color(0xFFB6C3CD),
      200: Color(0xFF86A0AE),
      300: Color(0xFF567C8E),
      400: Color(0xFF2E5F76),
      500: Color(_primaryValue),
      600: Color(0xFF09314E),
      700: Color(0xFF06283F),
      800: Color(0xFF041F31),
      900: Color(0xFF021520),
    },
  );
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => GroupCubit(),
        ),
        // BlocProvider(
        //   create: (context) => GroupCreationCubit(),
        // ),
        // BlocProvider(
        //   create: (context) => GroupCubitView(),
        // ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Folder it now',
        routerConfig: router,
        theme: ThemeData(
          primaryColor: const Color(0Xff0b3153),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: customSwatch).copyWith(
            primary: const Color(_primaryValue),
            secondary: const Color(_primaryValue),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:folder_it/Test_for_packages/LOADING_INDICATOR.dart';
// import 'package:universal_html/html.dart' as html;

// void main() {
//   html.DivElement div = html.DivElement();
//   div.text = "Hello from universal_html!";
//   html.document.body?.append(div);
//   // Bloc.observer = MyBlocObserver();
//   // WidgetsFlutterBinding.ensureInitialized();

//   // runApp(MyApp(appRouter: AppRouter()));
//   runApp(const MyApp());

// }
//
// class MyApp extends StatelessWidget {
//   MyApp({super.key, required this.appRouter});
//   AppRouter appRouter;
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [BlocProvider(create: (context) => UserBloc())],
//       child: MaterialApp(
//         navigatorKey: globalNavigatorKey,
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           useMaterial3: true,
//           iconTheme: const IconThemeData(color: Colors.white),
//           iconButtonTheme: IconButtonThemeData(
//               style: ButtonStyle(
//                   iconColor: MaterialStateProperty.all<Color>(Colors.white))),
//         ),
//         // home: SplashScreen(),
//         onGenerateRoute: appRouter.onGenerateRoute,
//       ),
//     );
//   }
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(debugShowCheckedModeBanner: false, home: LoadingExample()
//         // MyDataGridPage()

//         );
//   }
// }
