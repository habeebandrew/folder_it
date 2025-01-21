import 'dart:convert';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/core/Util/app_bloc_observer.dart';
import 'package:folder_it/core/Util/app_routes.dart';
import 'package:folder_it/core/Util/theme.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/Groups/presentation/cubit/group_cubit.dart';
import 'package:folder_it/features/Home/presentation/cubit/theme_cubit.dart';
import 'package:folder_it/features/User/presentation/cubit/user_cubit.dart';

import 'localization/localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper().init();
  Bloc.observer = MyBlocObserver();
  runApp(  MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // اللغة الافتراضية

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

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
            localizationsDelegates: const [
              AppLocalizationDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            locale: _locale, // تعيين اللغة الحالية
            debugShowCheckedModeBanner: false,
            title: 'Folder it now',
            routerConfig: router,
            theme: ThemeColors.ligthTheme,
            darkTheme: ThemeColors.darkTheme,
            themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}

class TokenHandler {
  /// تحديث التوكن بعد مرور 10 ثوانٍ
  Future<void> startTokenProcess(BuildContext context) async {
    await Future.delayed(Duration(minutes: 100), () async {
      print('fist refresh token');
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          await CacheHelper().saveData(key: 'token', value: newToken);
          print("updating token: $newToken");
          //TODO:بدي حط التوككن الجديدة مكان القديمة ***********************
          // إضافة أي عملية عند نجاح التحديث (مثلاً، حفظ التوكن)
        } else {
          print("update token failed");
        }
      } catch (error) {
        print("error loading token: $error");
      }

      // بعد 10 ثوانٍ إضافية، عرض رسالة تسجيل الدخول
      Future.delayed(Duration(minutes: 200), (


          ) {

        _showLogoutMessage(context);
      });
    });
  }

  /// طلب تحديث التوكن
  Future<String?> _refreshToken() async {
    String mytoken = CacheHelper().getData(key: 'token');
    String refreshToken = CacheHelper().getData(key: 'refreshToken');
    String username = CacheHelper().getData(key: 'username');
    String password = CacheHelper().getData(key: 'password');
    // print(mytoken);
    // print(refreshToken);
    // print(username);
    // print(password);

    const url = 'http://localhost:8091/auth/refresh-token';

    final headers = {
      'Authorization': 'Bearer $mytoken',
      'Content-Type': 'application/json',
      'Accept-Type': 'application/json',
    };

    final body = jsonEncode({
      'userName': username,
      'password': password,
      'refreshToken': refreshToken,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print("error loading token: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      print("error: $error");
      return null;
    }
  }

  /// عرض رسالة انتهاء الجلسة
  /// TODO:بدي خلي يرح لل تسجيل الدخول +حذف القيم
  void _showLogoutMessage(BuildContext context) {
    final validContext = Navigator.of(context).overlay!.context;
    showDialog(
      barrierDismissible: false,
      context: validContext,
      builder: (context) {
        return AlertDialog(
          title: Text("انتهاء الجلسة"),
          content: Text("يجب تسجيل الدخول مرة أخرى."),
          actions: [
            TextButton(
              onPressed: () {


                Navigator.of(context).pop();
                context.go('/login',extra: null);

              },
              child: Text("موافق"),
            ),
          ],
        );
      },
    );
  }
}
