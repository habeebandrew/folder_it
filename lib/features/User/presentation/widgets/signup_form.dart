import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/core/Util/responsive_view.dart';
import 'package:folder_it/features/User/presentation/cubit/user_cubit.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Row(
          children: [
            Icon(Icons.folder, color: Colors.yellow),
            SizedBox(width: 8),
            Text("FOLDERIT", style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.go('/signup');
            },
            child: const Text("Sign up", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              context.go('/login');
            },
            child: const Text("Login", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: ResponsiveView(
        mobile: (height, width) => SignupForm(width: width * 0.8),
        tablet: (height, width) => SignupForm(width: width * 0.6),
        desktop: (height, width) => SignupForm(width: width * 0.4),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  final double width;

  const SignupForm({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if(state is UserAuthFailureState){
          ScaffoldMessenger.of(context)
           .showSnackBar(
            SnackBar(
              content: Text(
                state.message
                ),
              backgroundColor: Colors.red,  
              behavior: SnackBarBehavior.floating,  
            )
          );
        }
      },
      builder: (context, state) {

        var cubit = UserCubit.get(context);
        return Center(
          child: Container(
            width: width,
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerRight, // جعل التمرير على الطرف
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: Image.asset(
                            'assets/images/basic.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Text(
                        'Sign up',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: cubit.userNameController,
                        decoration: const InputDecoration(labelText: 'user name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: cubit.emailController,
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: cubit.passwordController,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              StatefulBuilder(
                                builder: (context, setState) => Checkbox(
                                  value:cubit.rememberMe,
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
                      const SizedBox(height: 20),
                      Center(
                        child: state is UserAuthLoadingState?const CircularProgressIndicator()
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          onPressed: ()async {
                              await cubit.signUp(
                                context,
                                cubit.userNameController.text, 
                                cubit.emailController.text, 
                                cubit.passwordController.text
                              );
                            },
  
                          child: const Text(
                            'SIGN UP',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
