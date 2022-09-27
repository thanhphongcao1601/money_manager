// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:moneymanager/helper/constant.dart';

Widget ItemSelect(String genreName, TextEditingController controller, Function function) {
  return InkWell(
    child: InkWell(
      onTap: () {
        function();
        controller.text = genreName;
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(AppColor.pink), width: 2),
          borderRadius: BorderRadius.circular(5),
          color: const Color(AppColor.yellow),
        ),
        alignment: Alignment.center,
        child: Text(genreName),
      ),
    ),
  );
}
