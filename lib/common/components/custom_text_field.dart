import 'package:bumble_clone/common/app_colors.dart';
import 'package:flutter/material.dart';

//genel olarak kullanılan text field
Widget customTextField(TextEditingController controller, double? radius,
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
