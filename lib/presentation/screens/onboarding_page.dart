import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/common/constants.dart';
import 'package:bumble_clone/presentation/bloc/onboarding/onboarding_bloc.dart';
import 'package:bumble_clone/presentation/bloc/onboarding/onboarding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _gender = Gender.male.gender;
  String _preferredGender = Gender.female.gender;
  DateTime? _birthDate;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(1990);

    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _birthDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (BuildContext context, state) {
          if (state is OnboardingSuccess) {
            Navigator.pushReplacementNamed(context, '/swipescreen');
          } else if (state is OnboardingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if (state is OnboardingLoading) {
              return const CircularProgressIndicator();
            }
            return Scaffold(
              backgroundColor: AppColors.primaryYellow,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 48, right: 12),
                  child: Column(
                    children: [
                      Text(
                        "Lets learn basics about you.",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 50),
                      _customTextField(
                          _nameController, 12, TextInputType.text, "Name"),
                      Row(
                        children: [
                          Text(_birthDate == null
                              ? 'Pick your birthday'
                              : DateFormat.yMd().format(_birthDate!)),
                          IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month_outlined))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _customTextField(TextEditingController controller, double? radius,
    TextInputType? keyboardLayout, String? label) {
  return TextField(
    keyboardType: keyboardLayout ?? TextInputType.none,
    decoration: InputDecoration(
        focusColor: AppColors.white,
        hoverColor: Colors.black,
        label: Text(label ?? ""),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 0))),
    controller: controller,
  );
}
