import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/app_colors.dart';
import '../../../common/constants.dart';
import '../../../common/ui_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Kullanıcı giriş ekranı.
///
/// Bu ekran, kullanıcıların e-posta ve şifre ile giriş yapmalarını sağlar.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  bool _isVisible = false;
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/nav');
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
                      _logoAndSentence(),
                      Column(
                        children: [
                          _emailField(emailController),
                          const SizedBox(height: UIConstants.paddingSmall),
                          _passwordField(passwordController, () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          }, _isVisible),
                          const SizedBox(height: UIConstants.paddingSmall / 2),
                          _signUpLead(context),
                          const SizedBox(height: UIConstants.paddingMedium),
                          ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<AuthBloc>(context).add(
                                    LoginEvent(
                                        email: emailController.text,
                                        password: passwordController.text));
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
    );
  }
}

/// E-posta giriş alanı.
///
/// [controller] parametresi, metin alanının kontrolcüsünü alır.
Widget _emailField(TextEditingController controller) {
  return TextField(
    keyboardType: TextInputType.emailAddress,
    decoration: const InputDecoration(hintText: "Email"),
    controller: controller,
  );
}

/// Şifre giriş alanı.
///
/// [controller] parametresi, metin alanının kontrolcüsünü alır.
/// [onPressed] parametresi, şifre görünürlüğü düğmesinin tıklama işlevini alır.
/// [isVisible] parametresi, şifrenin görünür olup olmadığını belirtir.
Widget _passwordField(
    TextEditingController controller, VoidCallback? onPressed, bool isVisible) {
  return TextField(
    obscureText: !isVisible,
    decoration: InputDecoration(
        hintText: "Password",
        suffixIcon: IconButton(
            onPressed: onPressed,
            icon: Icon(
                isVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: UIConstants.iconSize))),
    controller: controller,
  );
}

/// Kayıt olma yönlendirme satırı.
///
/// [context] parametresi, geçerli yapı bağlamını alır.
Widget _signUpLead(context) {
  return Row(
    children: [
      const Text("   Don't you have an account?"),
      GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/register');
        },
        child: const Text(
          " Sign Up",
          style: TextStyle(color: AppColors.darkYellow),
        ),
      )
    ],
  );
}

/// Logo ve slogan bileşeni.
class _logoAndSentence extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //logo
        const SizedBox(
          height: UIConstants.appBarHeight * 1.5,
          child: Image(image: AssetImage(Constants.bumbleLogo)),
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
