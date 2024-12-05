import 'package:bumble_clone/common/app_colors.dart';
import 'package:bumble_clone/common/constants.dart';
import 'package:flutter/material.dart';

// Genders enum'a göre dropdown oluşturan widget.
class DropdownGenders extends StatelessWidget {
  final Genders value;
  final Function(Genders) onSelected;
  const DropdownGenders(
      {super.key, required this.value, required this.onSelected});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(152, 255, 255, 255),
          borderRadius: BorderRadius.circular(12)),
      child: DropdownMenu<Genders>(
        expandedInsets: EdgeInsets.zero, //tam genişliği kullanabilmesi için
        inputDecorationTheme:
            const InputDecorationTheme(fillColor: AppColors.background),
        initialSelection: value,
        onSelected: (Genders? newValue) {
          if (newValue != null) onSelected(newValue);
        },
        dropdownMenuEntries: [
          ...Genders.values.map(
            (gender) {
              return DropdownMenuEntry(value: gender, label: gender.value);
            },
          )
        ],
      ),
    );
  }
}
