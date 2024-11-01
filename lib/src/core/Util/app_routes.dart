import 'package:folder_it/src/Home/presentation/pages/navigation_rail_page.dart';
import 'package:folder_it/src/User/Presentation/pages/login_page.dart';
import 'package:folder_it/src/User/Presentation/pages/signup_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const NavigationRailPage(notificationCount: 3,),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
  ],
);
//? للتنقل
/**
 * 
  ElevatedButton(
  onPressed: () {
    context.go('/signup');
  },
  child: Text('Sign Up'),
)

 */