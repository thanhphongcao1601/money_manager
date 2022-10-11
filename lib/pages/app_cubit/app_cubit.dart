import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/record.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  List<Record> listRecord = [];

  Map<String, List<Record>> listRecordGroupByDate = {};
  Map<String, List<Record>> listRecordGroupByGenre = {};
  Map<String, List<Record>> listRecordGroupByType = {};

  int totalIncome = 0;
  int totalExpense = 0;
  int currentIndex = 0;

  dynamic changePage(int? newIndex, BuildContext context) {
    currentIndex = newIndex!;
    switch (newIndex) {
      case 0:
        emit(const HomePageLoaded());
        break;
      case 1:
        emit(const ChartPageLoaded());
        break;
      case 2:
        emit(const BackupPageLoaded());
        break;
      case 3:
        emit(const SettingPageLoaded());
        break;
      default: emit(AppLoaded());
    }
  }

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
      var genre = e.genre ??= "";
      return genre;
    });
    return groups;
  }

  Map<String, List<Record>> groupRecordByType(List<Record> record) {
    Map<String, List<Record>> groups = groupBy(record, (Record e) {
      return e.type == "" ? "Không tiêu đề" : e.type!;
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
    listRecordGroupByType = groupRecordByType(listRecord);

    emit(AppLoaded());
  }

  addRecordToPrefs(Record record) async {
    emit(AppLoading());
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

    listStringRecord.remove(stringRecord);
    await prefs.setStringList('listRecord', listStringRecord);
    loadListRecord();
  }
}
