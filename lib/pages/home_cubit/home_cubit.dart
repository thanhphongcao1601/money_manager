import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneymanager/pages/home_cubit/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/record.dart';

class HomeCubit extends Cubit<HomeState> {
  List<Record> listRecord = [];
  int totalIncome = 0;
  int totalExpense = 0;

  HomeCubit(): super(HomeInitial());

  loadListRecord() async {
    listRecord = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listStringRecord = prefs.getStringList('listRecord') ?? [];
    for (var strRecord in listStringRecord){
      Record record = Record.fromJson(jsonDecode(strRecord));
      int money = record.money ?? 0;
      if (money >= 0) {
        totalIncome+=money;
      } else {
        totalExpense += money;
      }
      listRecord.add(record);
    }
    emit(HomeLoaded());
  }

  saveRecordToPrefs(Record record) async {
    String recordJson = jsonEncode(record.toJson());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listStringRecord = prefs.getStringList('listRecord') ?? [];
    listStringRecord.add(recordJson);

    await prefs.setStringList('listRecord', listStringRecord);
    print(recordJson);

    // for (var record in listStringRecord){
    //   Record t = Record.fromJson(jsonDecode(record));
    //   print(t.money);
    // }
    loadListRecord();
  }
}