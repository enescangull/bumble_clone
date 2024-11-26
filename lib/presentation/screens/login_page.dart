import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/app_colors.dart';
import '../../common/constants.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import 'register.dart';
import 'swipe_screen.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthBloc(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is Authenticated) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Welcome ${state.email}'),
              ));

              await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SwipeScreen(),
                ),
                (Route<dynamic> route) => false,
              );

              // Navigate to home page
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Error: ${state.message}'),
              ));
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Scaffold(
                body: SafeArea(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _logoAndSentence(),
                        Column(
                          children: [
                            _emailField(emailController),
                            const SizedBox(height: 10),
                            _passwordField(passwordController),
                            const SizedBox(height: 5),
                            _signUpLead(context),
                            const SizedBox(height: 20),
                            OutlinedButton(
                                onPressed: () {
                                  BlocProvider.of<AuthBloc>(context).add(
                                      LoginEvent(
                                          email: emailController.text,
                                          password: passwordController.text));
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login),
                                    SizedBox(width: 2),
                                    Text("Login")
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                )),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _emailField(TextEditingController controller) {
  return TextField(
    keyboardType: TextInputType.emailAddress,
    decoration: const InputDecoration(hintText: "Email"),
    controller: controller,
  );
}

Widget _passwordField(TextEditingController controller) {
  return TextField(
    decoration: const InputDecoration(hintText: "Password"),
    controller: controller,
  );
}

Widget _signUpLead(context) {
  return Row(
    children: [
      const Text("   Don't you have an account?"),
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ));
        },
        child: const Text(
          " Sign Up",
          style: TextStyle(color: AppColors.darkYellow),
        ),
      )
    ],
  );
}

// ignore: camel_case_types
class _logoAndSentence extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //logo
        SizedBox(
          height: 100,
          child: Image.asset(
            Constants.bumbleLogo,
            fit: BoxFit.cover,
          ),
        ),
        //sentence
        Text(
          "MAKE THE\nFIRST MOVE",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.primaryYellow,
              fontWeight: FontWeight.bold,
              shadows: [
                const Shadow(color: AppColors.black, offset: Offset(-2, 1)),
                const Shadow(color: AppColors.black, offset: Offset(-2.5, 2)),
              ]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
