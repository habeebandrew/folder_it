import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/features/User/presentation/cubit/user_cubit.dart';
import 'package:folder_it/features/User/presentation/widgets/signup_form.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return const Scaffold(
          body: SignupScreen(),
        );
      },
    );
  }
}
