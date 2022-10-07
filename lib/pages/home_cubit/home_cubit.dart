import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneymanager/pages/home_cubit/home_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/record.dart';

class HomeCubit extends Cubit<HomeState> {
  List<Record> listRecord = [];
  Map<String, List<Record>> listRecordGroupByDate = {};
  Map<String, List<Record>> listRecordGroupByGenre = {};
  int totalIncome = 0;
  int totalExpense = 0;

  HomeCubit() : super(HomeInitial());

  Map<String, List<Record>> groupRecordByDate(List<Record> record) {
    Map<String, List<Record>> groups = groupBy(record, (Record e) {
      DateTime tsDate = DateTime.fromMillisecondsSinceEpoch(e.datetime!);
      String datetime = "${tsDate.year}/${tsDate.month}/${tsDate.day}";
      return datetime;
    });
    return groups;
  }

  Map<String, List<Record>> groupRecordByGenre(List<Record> record) {
    Map<String, List<Record>> groups = groupBy(record, (Record e) {
      return e.genre == "" ? "Khác" : e.genre!;
    });
    return groups;
  }

  loadListRecord() async {
    listRecord = [];
    totalExpense = 0;
    totalIncome = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listStringRecord = prefs.getStringList('listRecord') ?? [];

    for (var strRecord in listStringRecord) {
      Record record = Record.fromJson(jsonDecode(strRecord));
      int money = record.money ?? 0;
      if (money >= 0) {
        totalIncome += money;
      } else {
        totalExpense += money;
      }
      listRecord.add(record);
    }

    listRecord.sortReversed();
    listRecordGroupByDate = groupRecordByDate(listRecord);
    listRecordGroupByGenre = groupRecordByGenre(listRecord);

    print(jsonEncode(listRecordGroupByGenre));

    emit(HomeLoaded());
  }

  addRecordToPrefs(Record record) async {
    emit(HomeLoading());
    String recordJson = jsonEncode(record.toJson());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listStringRecord = prefs.getStringList('listRecord') ?? [];
    listStringRecord.add(recordJson);

    await prefs.setStringList('listRecord', listStringRecord);
    loadListRecord();
  }

  deleteRecordById(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listStringRecord = prefs.getStringList('listRecord') ?? [];
    String stringRecord = listStringRecord
        .firstWhere((element) => Record.fromJson(jsonDecode(element)).id == id);
    print(stringRecord);
    listStringRecord.remove(stringRecord);
    await prefs.setStringList('listRecord', listStringRecord);
    loadListRecord();
  }
}
