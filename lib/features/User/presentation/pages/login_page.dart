import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/features/User/presentation/cubit/user_cubit.dart';

import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserAuthSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login successful')));
          } else if (state is UserAuthFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: const LoginScreen(),
      ),
    );
  }
}
