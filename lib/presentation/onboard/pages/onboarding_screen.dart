import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/common/components/custom_text_field.dart';
import 'package:bumble_clone/common/components/date_input_field.dart';
import 'package:bumble_clone/common/components/dropdown_genders.dart';
import 'package:bumble_clone/common/constants.dart';
import 'package:bumble_clone/common/ui_constants.dart';
import 'package:bumble_clone/core/di/service_locator.dart';
import 'package:bumble_clone/core/services/user_service.dart';
import 'package:bumble_clone/presentation/onboard/bloc/onboarding_bloc.dart';
import 'package:bumble_clone/presentation/onboard/bloc/onboarding_event.dart';
import 'package:bumble_clone/presentation/onboard/bloc/onboarding_state.dart';

import '../../../common/components/onboarding_components/image_onboarding_component.dart';

/// Kullanıcı onboarding ekranı.
///
/// Bu ekran, kullanıcının ilk kayıt sonrası profil bilgilerini doldurmasını ve
/// tercihlerini belirlemesini sağlar.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final UserService _service = getIt<UserService>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  Genders gender = Genders.male;
  Genders preferredGender = Genders.female;
  DateTime? birthDate;
  int? age;
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OnboardingBloc, OnboardingState>(
        listener: (BuildContext context, state) {
          if (state is OnboardingLoading) {
            showDialog(
              context: context,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state is OnboardingSuccess) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            Navigator.pushReplacementNamed(context, '/nav');
          } else if (state is OnboardingFailure) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if (state is OnboardingLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Scaffold(
              floatingActionButton: FloatingActionButton(
                heroTag: null,
                elevation: 0,
                onPressed: () async {
                  if (_nameController.text.trim().isEmpty ||
                      birthDate == null ||
                      _imagePath == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please fill the blank fields.")),
                    );
                    return;
                  }
                  try {
                    final String? profilePicture =
                        await _service.uploadProfilePicture(_imagePath!);
                    if (profilePicture == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Failed to upload profile picture")),
                      );
                      return;
                    }

                    context.read<OnboardingBloc>().add(SubmitOnboardingData(
                          birthDate: birthDate!,
                          name: _nameController.text,
                          gender: gender.value,
                          preferredGender: preferredGender.value,
                          profilePicture: profilePicture,
                        ));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to create user")));
                  }
                },
                child: const Icon(Icons.arrow_forward_ios_rounded,
                    size: UIConstants.iconSize),
              ),
              appBar: AppBar(
                title: const Text(
                  "Lets learn basics about you.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              backgroundColor: AppColors.primaryYellow,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: UIConstants.paddingSmall,
                      top: UIConstants.paddingExtraLarge,
                      right: UIConstants.paddingSmall,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: ImageOnboardingComponent(
                            imagePath: _imagePath,
                            onImageSelected: (selectedImagePath) {
                              setState(() {
                                _imagePath = selectedImagePath;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: UIConstants.paddingLarge),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Whats your first name"),
                            SizedBox(height: UIConstants.paddingSmall),
                            customTextField(_nameController, 12,
                                TextInputType.text, "Name"),
                          ],
                        ),
                        SizedBox(height: UIConstants.paddingLarge),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("How do you identify?"),
                            SizedBox(height: UIConstants.paddingSmall),
                            DropdownGenders(
                              value: gender,
                              onSelected: (newValue) {
                                setState(() {
                                  gender = newValue;
                                });
                              },
                            )
                          ],
                        ),
                        SizedBox(height: UIConstants.paddingLarge),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Who are you interested in?"),
                            SizedBox(height: UIConstants.paddingSmall),
                            DropdownGenders(
                              value: preferredGender,
                              onSelected: (newValue) {
                                setState(() {
                                  preferredGender = newValue;
                                });
                              },
                            )
                          ],
                        ),
                        SizedBox(height: UIConstants.paddingLarge),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("When's your birthday?"),
                            SizedBox(height: UIConstants.paddingSmall),
                            DateInputField(
                              dayController: _dayController,
                              monthController: _monthController,
                              yearController: _yearController,
                              onDateSelected: (selectedDate) {
                                setState(() {
                                  birthDate = selectedDate;
                                  age = _service.calculateAge(birthDate!);
                                });
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("You are $age years old",
                                          textAlign: TextAlign.center),
                                      content: const Text(
                                          "Make sure this is your correct age as you can't change this later. ",
                                          textAlign: TextAlign.center),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Approve"))
                                      ],
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
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
