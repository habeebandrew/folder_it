import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/src/core/Util/responsive_view.dart';
import 'package:go_router/go_router.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

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
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go('/home'); // التنقل بعد نجاح التسجيل
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: ResponsiveView(
          mobile: (height, width) => SignupForm(width: width * 0.8),
          tablet: (height, width) => SignupForm(width: width * 0.6),
          desktop: (height, width) => SignupForm(width: width * 0.4),
        ),
      ),
    );
  }
}


class SignupForm extends StatelessWidget {
  final double width;

  const SignupForm({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool rememberMe = false;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Center(
      child: Container(
        width: width,
        padding: const EdgeInsets.all(20.0),
        child: Align(
          alignment: Alignment.centerRight, // جعل التمرير على الطرف
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
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
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
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
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value ?? false;
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          context.read<AuthCubit>().signup(email, password);
                        }
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
  }
}
