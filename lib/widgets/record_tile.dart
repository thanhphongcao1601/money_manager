// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import '../helper/constant.dart';
import '../model/record.dart';

Widget NoteTile(Record record) {
  return InkWell(
    child: Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                width: 12,
                padding: const EdgeInsets.all(10),
                color: const Color(AppColor.pink),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    record.content ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(record.genre ?? "",
                      style: const TextStyle(fontSize: 14))
                ],
              )),
              Text(
                record.money.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
        ],
      ),
    ),
  );
}
