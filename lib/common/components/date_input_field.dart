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
    final FocusNode monthFocusNode = FocusNode(); //Ay alanı için focus node
    final FocusNode yearFocusNode = FocusNode(); //yıl için oluşturulan node
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildDateInputField(
          //Doğum tarihinin gün kısmı için,oluşturulan alan
          controller: dayController,
          hint: "DD",
          maxLenght: 2,
          onChanged: (text) {
            if (text.length == 2) {
              FocusScope.of(context).requestFocus(FocusNode());
              FocusScope.of(context)
                  .requestFocus(monthFocusNode); //Ay kısmına geçiliyor
            }
          },
        ),
        const SizedBox(width: 5),
        _buildDateInputField(
          controller: monthController,
          focusNode:
              monthFocusNode, //Focus Node'da ay kısmı olduğunu `monthFocusNode` değişkeniyle belirtiyoruz
          hint: "MM",
          maxLenght: 2,
          onChanged: (text) {
            if (text.length == 2) {
              FocusScope.of(context)
                  .requestFocus(yearFocusNode); //Yıl kısmına geçiliyor
            }
          },
        ),
        const SizedBox(width: 5),
        _buildDateInputField(
          controller: yearController,
          focusNode:
              yearFocusNode, //Focus Node'da yıl kısmı olduğunu `yearFocusNode` değişkeniyle belirtiyoruz
          hint: "YYYY",
          maxLenght: 4,
          onChanged: (text) {
            if (dayController.text.length == 2 &&
                monthController.text.length == 2 &&
                yearController.text.length == 4) {
              try {
                DateTime parsedDate = parseDate(dayController.text,
                    monthController.text, yearController.text);

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

//dCT = dayController.text, mCT = monthController.text, yCT = yearController.text
DateTime parseDate(String dCT, String mCT, String yCT) {
  DateFormat format = DateFormat("dd/MM/yyyy");
  String formattedDate = "$dCT/$mCT/$yCT";
  return format.parseStrict(formattedDate);
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
