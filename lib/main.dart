import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/src/User/domain/usecases/sign_in_usecase.dart';
import 'package:folder_it/src/User/domain/repositories/auth_repository.dart';
import 'package:folder_it/src/User/Data/repositories/auth_repository_impl.dart';
import 'package:folder_it/src/User/Presentation/cubit/auth_cubit.dart';
import 'package:folder_it/src/Util/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl() as AuthRepository,
        ),
        RepositoryProvider<SignInUseCase>(
          create: (context) => SignInUseCase(
            context.read<AuthRepository>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              context.read<SignInUseCase>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Folder it now',
          routerConfig: router,
          theme: ThemeData(primaryColor: Colors.blue,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: Colors.grey[200]).copyWith(secondary: Colors.amber),
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(fontSize: 20),
            ),
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
