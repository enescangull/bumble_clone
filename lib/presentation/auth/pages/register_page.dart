import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/app_colors.dart';
import '../../../common/constants.dart';
import '../../../common/ui_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isVisible = false;
  bool _isVisibleConfirm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOnboardingRequired) {
            Navigator.pushReplacementNamed(
              context,
              '/onboarding',
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
                padding: const EdgeInsets.symmetric(
                  horizontal: UIConstants.paddingLarge,
                  vertical: UIConstants.paddingExtraLarge,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _logoAndSentence(),
                      Column(
                        children: [
                          _emailField(emailController),
                          const SizedBox(height: 10),
                          _passwordField(passwordController, () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          }, _isVisible),
                          const SizedBox(height: 5),
                          _passwordField(confirmPasswordController, () {
                            setState(() {
                              _isVisibleConfirm = !_isVisibleConfirm;
                            });
                          }, _isVisibleConfirm),
                          const SizedBox(height: 5),
                          _signUpLead(context),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<AuthBloc>(context).add(
                                    RegisterEvent(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        confirmPassword:
                                            confirmPasswordController.text));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkYellow,
                                foregroundColor: AppColors.background,
                                minimumSize: const Size(
                                    double.infinity, UIConstants.buttonHeight),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login),
                                  SizedBox(width: 2),
                                  Text("Register")
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

Widget _passwordField(
    TextEditingController controller, VoidCallback? onPressed, bool isVisible) {
  return TextField(
    obscureText: !isVisible,
    decoration: InputDecoration(
        hintText: "Password",
        suffixIcon: IconButton(
            onPressed: onPressed,
            icon: Icon(isVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined))),
    controller: controller,
  );
}

Widget _signUpLead(context) {
  return Row(
    children: [
      const Text("   Have you got a account?"),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/login');
        },
        child: const Text(
          " Sign In",
          style: TextStyle(color: AppColors.darkYellow),
        ),
      )
    ],
  );
}

// ignore: camel_case_types
class _logoAndSentence extends StatelessWidget {
  const _logoAndSentence();
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
