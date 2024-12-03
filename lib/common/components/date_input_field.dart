import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatelessWidget {
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final Function(DateTime) onDateSelected;
  const DateInputField({
    super.key,
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final FocusNode _monthFocusNode = FocusNode();
    final FocusNode _yearFocusNode = FocusNode();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildDateInputField(
          controller: dayController,
          hint: "DD",
          maxLenght: 2,
          onChanged: (text) {
            if (text.length == 2) {
              FocusScope.of(context).requestFocus(FocusNode());
              FocusScope.of(context).requestFocus(_monthFocusNode);
            }
          },
        ),
        const SizedBox(width: 5),
        _buildDateInputField(
          controller: monthController,
          focusNode: _monthFocusNode,
          hint: "MM",
          maxLenght: 2,
          onChanged: (text) {
            if (text.length == 2) {
              FocusScope.of(context).requestFocus(_yearFocusNode);
            }
          },
        ),
        const SizedBox(width: 5),
        _buildDateInputField(
          controller: yearController,
          focusNode: _yearFocusNode,
          hint: "YYYY",
          maxLenght: 4,
          onChanged: (text) {
            if (dayController.text.length == 2 &&
                monthController.text.length == 2 &&
                yearController.text.length == 4) {
              try {
                String formattedDate =
                    "${dayController.text}/${monthController.text}/${yearController.text}";
                DateFormat format = DateFormat("dd/MM/yyyy");
                DateTime parsedDate = format.parseStrict(formattedDate);

                onDateSelected(parsedDate);
              } catch (e) {
                // Geçersiz bir tarih formatı durumunda
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter a valid date.")),
                );
              }
            }
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
