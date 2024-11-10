import 'package:folder_it/features/Home/presentation/pages/navigation_rail_page.dart';
import 'package:folder_it/features/User/presentation/pages/login_page.dart';
import 'package:folder_it/features/User/presentation/pages/signup_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
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