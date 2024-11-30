import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/common/components/custom_text_field.dart';
import 'package:bumble_clone/common/constants.dart';
import 'package:bumble_clone/presentation/onboard/bloc/onboarding_bloc.dart';
import 'package:bumble_clone/presentation/onboard/bloc/onboarding_event.dart';
import 'package:bumble_clone/presentation/onboard/bloc/onboarding_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final FocusNode _monthFocusNode = FocusNode();
  final FocusNode _yearFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  Genders gender = Genders.male;
  Genders preferredGender = Genders.female;
  DateTime? birthDate;
  int? age;

  int calculateAge(DateTime birthdate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthDate!.year;

    // Eğer henüz doğum günü gelmediyse, yaşı bir azaltırız
    if (currentDate.month < birthDate!.month ||
        (currentDate.month == birthDate?.month &&
            currentDate.day < birthDate!.day)) {
      age--;
    }

    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => OnboardingBloc(),
        child: BlocListener<OnboardingBloc, OnboardingState>(
          listener: (BuildContext context, state) {
            if (state is OnboardingSuccess) {
              print("Onboard SUCCESSSSSSSSSS");
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is OnboardingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
              print(state.error);
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
                  elevation: 0,
                  onPressed: () {
                    if (_nameController.text.trim().isEmpty ||
                        birthDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please fill the blank fields.")),
                      );
                      return;
                    }
                    try {
                      BlocProvider.of<OnboardingBloc>(context)
                          .add(SubmitOnboardingData(
                        birthDate: birthDate!,
                        name: _nameController.text,
                        gender: gender.value,
                        preferredGender: preferredGender.value,
                      ));
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios_rounded),
                ),
                appBar: AppBar(
                  title: const Text(
                    "Lets learn basics about you.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                backgroundColor: AppColors.primaryYellow,
                body: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, top: 48, right: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Whats your first name"),
                            const SizedBox(height: 10),
                            customTextField(_nameController, 12,
                                TextInputType.text, "Name"),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("How do you identify?"),
                            const SizedBox(height: 10),
                            _dropdownGenders(gender, true),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Who are you interested in?"),
                            const SizedBox(
                              height: 10,
                            ),
                            _dropdownGenders(preferredGender, false),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("When's your birthday?"),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildDateInputField(
                                  controller: _dayController,
                                  hint: "DD",
                                  maxLenght: 2,
                                  onChanged: (text) {
                                    if (text.length == 2) {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());

                                      FocusScope.of(context)
                                          .requestFocus(_monthFocusNode);
                                    }
                                  },
                                ),
                                const SizedBox(width: 5),
                                _buildDateInputField(
                                  controller: _monthController,
                                  hint: "MM",
                                  maxLenght: 2,
                                  focusNode: _monthFocusNode,
                                  onChanged: (text) {
                                    if (text.length == 2) {
                                      FocusScope.of(context)
                                          .requestFocus(_yearFocusNode);
                                    }
                                  },
                                ),
                                const SizedBox(width: 5),
                                _buildDateInputField(
                                  controller: _yearController,
                                  hint: "YYYY",
                                  maxLenght: 4,
                                  focusNode: _yearFocusNode,
                                  onChanged: (text) {
                                    if (_dayController.text.length == 2 &&
                                        _monthController.text.length == 2 &&
                                        _yearController.text.length == 4) {
                                      String day = _dayController.text;
                                      String month = _monthController.text;
                                      String year = _yearController.text;

                                      try {
                                        // Tarih formatını oluştur ve kontrol et
                                        String formattedDate =
                                            "$day/$month/$year";
                                        DateFormat format =
                                            DateFormat("dd/MM/yyyy");
                                        DateTime parsedDate =
                                            format.parseStrict(formattedDate);

                                        // Eğer geçerliyse doğum tarihini ata
                                        birthDate = parsedDate;

                                        // Yaşı hesapla
                                        age = calculateAge(birthDate!);

                                        // Kullanıcıya bilgi mesajı göster (isteğe bağlı)
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text("Yaşınız: $age")),
                                        );
                                      } catch (e) {
                                        // Geçersiz bir tarih formatı durumunda
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Lütfen geçerli bir tarih giriniz.")),
                                        );
                                      }
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  DropdownMenu<Genders> _dropdownGenders(Genders value, bool isGender) {
    return DropdownMenu<Genders>(
      expandedInsets: EdgeInsets.zero,
      inputDecorationTheme:
          const InputDecorationTheme(fillColor: AppColors.background),
      initialSelection: value,
      onSelected: (Genders? newValue) {
        if (isGender) {
          gender = newValue!;
        } else {
          preferredGender = newValue!;
        }
      },
      dropdownMenuEntries: [
        ...Genders.values.map(
          (gender) {
            return DropdownMenuEntry(value: gender, label: gender.value);
          },
        )
      ],
    );
  }
}

Widget _buildDateInputField({
  required TextEditingController controller,
  required String hint,
  required int maxLenght,
  FocusNode? focusNode,
  Function(String)? onChanged,
}) {
  return SizedBox(
    width: 90,
    child: TextField(
      controller: controller,
      maxLength: maxLenght,
      keyboardType: TextInputType.number,
      focusNode: focusNode,
      decoration: InputDecoration(
        counterText: "",
        hintText: hint,
      ),
      onChanged: onChanged,
    ),
  );
}
