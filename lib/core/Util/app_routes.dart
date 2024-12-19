import 'package:folder_it/features/Groups/presentation/pages/invite_member_page.dart';
import 'package:folder_it/features/Groups/presentation/pages/invites_page.dart';
import 'package:folder_it/features/Groups/presentation/pages/group_details.dart';
import 'package:folder_it/features/Home/presentation/pages/navigation_rail_page.dart';
import 'package:folder_it/features/User/presentation/pages/login_page.dart';
import 'package:folder_it/features/User/presentation/pages/signup_page.dart';
import 'package:go_router/go_router.dart';

import '../../features/Group_Browser/presentation/pages/group_form.dart';
import '../../features/Groups/presentation/pages/GroupCreationPage.dart';
import '../../features/admin/admin_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/AdminScreen',
  routes: [
    GoRoute(
      path: '/GroupCreationPage',
      builder: (context, state) =>  const GroupCreationPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const NavigationRailPage(
        notificationCount: 3,
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
     GoRoute(
      path: '/groupDetails',
      builder: (context, state) => const GroupDetails(),
    ),
     GoRoute(
      path: '/invites',
      builder: (context, state) => const InvitesPage(),
    ),

    GoRoute(
      path: '/groupform',
      builder: (context, state) {
        // Access query parameters using state.uri.queryParameters
        final groupId = int.tryParse(state.uri.queryParameters['groupId'] ?? '0') ?? 0;
        final isOtherFilter = state.uri.queryParameters['isOtherFilter'] == 'true';

        return GroupForm( folderId: 0,//Todo:becarful here!!!
          groupId: groupId,
          isOtherFilter: isOtherFilter,
        );
      },
    ),


    GoRoute(
      path: '/inviteMemeber',
      builder: (context, state) =>  const InviteMemberPage(groupId: 0,),
    ),
    GoRoute(
      path: '/AdminScreen',
      builder: (context, state) =>   AdminScreen(),
    ),
  ],
);
//? للتنقل
/**
 *
    ElevatedButton(
    onPressed: () {
    context.go('/AdminScreen');
    },
    child: Text('Sign Up'),
    )

 */
