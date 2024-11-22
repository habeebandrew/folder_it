import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/core/Util/responsive_view.dart';
import 'package:folder_it/features/User/presentation/cubit/user_cubit.dart';
import 'package:folder_it/features/User/presentation/widgets/custom_form_field.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).primaryColor,
        title:  Row(
          children: [
            const Icon(Icons.folder, color: Colors.yellow, size: 30),
            const SizedBox(width: 10),
            Text(
              "FOLDERIT",
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                
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
            child: Text(
              "Sign up",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall!.color,
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              UserCubit.get(context).clearControllers();
              context.go('/login');
            },
            child:Text(
              "Login",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall!.color,
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: ResponsiveView(
        mobile: (height, width) => LoginForm(width: width * 0.8),
        tablet: (height, width) => LoginForm(width: width * 0.6),
        desktop: (height, width) => LoginForm(width: width * 0.4),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final double width;

  const LoginForm({super.key, required this.width});

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
                key: cubit.logInformKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            width: constraints.maxWidth *
                                0.5, // عرض الصورة 80% من مساحة الحاوية
                            child: Image.asset(
                              'assets/images/auth/LOGIN_copy.png',
                              fit: BoxFit.contain,
                            ),
                          );
                        },
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
                            Text(
                              "Remember me",
                              style: Theme.of(context).textTheme.displayMedium
                            ),
                          ],
                        ),

                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: state is UserAuthLoadingState
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: Theme.of(context).elevatedButtonTheme.style,
                              onPressed: () async {
                                await cubit.login(
                                  context,
                                  cubit.userNameController.text,
                                  cubit.passwordController.text,
                                );
                              },
                              child: Text(
                                'Sign In',
                                style: Theme.of(context).textTheme.bodyMedium
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
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
