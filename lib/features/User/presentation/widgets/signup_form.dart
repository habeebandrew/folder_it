import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:folder_it/core/Util/responsive_view.dart';
import 'package:folder_it/features/User/presentation/cubit/user_cubit.dart';
import 'package:folder_it/features/User/presentation/widgets/custom_form_field.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.black.withOpacity(0.9), 
        elevation: 4, 
        shadowColor: Colors.black54, 
        title: const Row(
          children: [
            Icon(Icons.folder,
                color: Colors.yellow, size: 30),
            SizedBox(width: 10),
            Text(
              "FOLDERIT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22, 
                fontWeight: FontWeight.bold,
                letterSpacing:
                    1.2, 
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              UserCubit.get(context).clearControllers();
              context.go('/signup');
            },
            child: const Text(
              "Sign up",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16, 
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              UserCubit.get(context).clearControllers();
              context.go('/login');
            },
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16, 
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: ResponsiveView(
        mobile: (height, width) => SignUpForm(width: width * 0.8),
        tablet: (height, width) => SignUpForm(width: width * 0.6),
        desktop: (height, width) => SignUpForm(width: width * 0.4),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  final double width;

  const SignUpForm({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserAuthFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = UserCubit.get(context);
        return Center(
          child: Container(
            width: width,
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Form(
                key: cubit.signUpformKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: SvgPicture.asset(
                          'assets/images/web_login_svg.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Center(
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    customFormFiled(
                      controller: cubit.userNameController,
                      label: 'Username',
                      validator: (value) {
                        return cubit.validateUserName(value);
                      },
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 15),
                    customFormFiled(
                      controller: cubit.emailController,
                      label: 'email',
                      validator: (value) {
                        return cubit.validateEmail(value);
                      },
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 15),
                    customFormFiled(
                      controller: cubit.passwordController,
                      label: 'Password',
                      obscureText: true,
                      validator: (value) {
                        return cubit.validatePassword(value);
                      },
                      prefixIcon: Icons.lock,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            StatefulBuilder(
                              builder: (context, setState) => Checkbox(
                                value: cubit.rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    cubit.rememberMe = value ?? false;
                                  });
                                },
                              ),
                            ),
                            const Text("Remember me"),
                          ],
                        ),

                      ],
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: state is UserAuthLoadingState
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 5,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 16),
                              ),
                              onPressed: () async {
                                await cubit.signUp(
                                  context,
                                  cubit.userNameController.text,
                                  cubit.emailController.text,
                                  cubit.passwordController.text,
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
