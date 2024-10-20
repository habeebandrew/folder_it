import 'package:flutter/material.dart';
import 'package:folder_it/Test_for_packages/LOADING_INDICATOR.dart';
import 'package:universal_html/html.dart' as html;

void main() {
  html.DivElement div = html.DivElement();
  div.text = "Hello from universal_html!";
  html.document.body?.append(div);
  // Bloc.observer = MyBlocObserver();
  // WidgetsFlutterBinding.ensureInitialized();

  // runApp(MyApp(appRouter: AppRouter()));
  runApp(const MyApp());

}
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
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:LoadingExample()
        // MyDataGridPage()

    );
  }
}
