// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import '../helper/constant.dart';
import '../model/record.dart';
import '../pages/app_cubit/app_cubit.dart';
import '../pages/detail_record/detail_record_page.dart';

Widget NoteTile(
    {required Record record,
    required AppCubit appCubit,
    required BuildContext context}) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailRecordPage(
              appCubit: appCubit,
              record: record,
            ),
          ));
    },
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
                color: record.money! >= 0
                    ? const Color(AppColor.pink)
                    : const Color(AppColor.yellow),
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
                  Text(record.genre ?? "", style: const TextStyle(fontSize: 14))
                ],
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(record.type ?? "", style: const TextStyle(fontSize: 14)),
                  const SizedBox(
                    height: 5,
                  ),
                  record.money! >=0 ?
                  Text(
                    "+${record.money!.toVND()}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:Colors.green),
                  ):Text(
                    "-${record.money!.abs().toVND()}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:Colors.redAccent),
                  ),
                ],
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
