import 'dart:convert';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:d_chart/d_chart.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/helper/constant.dart';
import 'package:moneymanager/pages/home_cubit/home_cubit.dart';

import '../widgets/bottom_nav_bar.dart';
import 'home_cubit/home_state.dart';

// ignore: must_be_immutable
class ChartPage extends StatefulWidget {
  const ChartPage({Key? key, required this.homeCubit}) : super(key: key);
  final HomeCubit homeCubit;

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Map<String, dynamic>> dataExpenseToChart;
  late List<Map<String, dynamic>> dataIncomeToChart;
  late int totalExpense;
  late int totalIncome;
  late List<Color> colors;

  @override
  void initState() {
    super.initState();
    dataExpenseToChart = [];
    dataIncomeToChart = [];
    colors = [];
    totalExpense = 0;
    totalIncome = 0;
    _tabController = TabController(length: 2, vsync: this);

    for (var i = 0; i < 20; i++) {
      colors.add(Colors.primaries[Random().nextInt(Colors.primaries.length)]);
    }

    //get total money expense and income
    for (var item in widget.homeCubit.listRecordGroupByGenre.entries) {
      totalExpense += item.value.sumBy<int>((e) => e.money! < 0 ? e.money! : 0);
      totalIncome += item.value.sumBy<int>((e) => e.money! > 0 ? e.money! : 0);
    }

    //add expense item to expenseChart
    for (var item in widget.homeCubit.listRecordGroupByGenre.entries) {
      for (var record in item.value) {
        if (record.money! < 0) {
          Map<String, dynamic> obj = {
            'domain': item.key,
            'measure':
                (item.value.sumBy<int>((e) => e.money! < 0 ? e.money! : 0) /
                        totalExpense *
                        100)
                    .round(),
            'totalMoney':
                (item.value.sumBy<int>((e) => e.money! < 0 ? e.money! : 0))
          };
          if (!dataExpenseToChart
              .any((element) => element['domain'] == obj['domain'])) {
            dataExpenseToChart.add(obj);
          }
        }
      }
    }

    if (totalIncome != 0) {
      for (var item in widget.homeCubit.listRecordGroupByType.entries) {
        for (var record in item.value) {
          if (record.money! > 0) {
            Map<String, dynamic> obj = {
              'domain': item.key,
              'measure':
                  item.value.sumBy<int>((e) => e.money! > 0 ? e.money! : 0)
            };
            dataIncomeToChart.add(obj);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) => state is HomeLoaded
                ? buildBottomBar(
                    widget.homeCubit.currentIndex,
                    (int? newIndex) =>
                        widget.homeCubit.changePage(newIndex, context))
                : const SizedBox()),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: <Color>[
                    Color(AppColor.pink),
                    Color(AppColor.yellow)
                  ]),
            ),
          ),
          title: const Text(
            "Thống kê",
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              controller: _tabController,
              tabs: [
                Tab(
                  text: "Chi: ${totalExpense.toString().toVND()}",
                ),
                Tab(
                  text: "Thu: ${totalIncome.toString().toVND()}",
                ),
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            buildTabExpense(),
            buildTabIncome(),
          ],
        ));
  }

  Widget buildTabExpense() {
    return dataExpenseToChart.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: DChartPie(
                      data: dataExpenseToChart,
                      fillColor: (pieData, index) => colors[index!],
                      pieLabel: (pieData, index) {
                        return "${pieData['domain']}:\n${pieData['measure']}%";
                      },
                      labelPosition: PieLabelPosition.outside,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Divider(
                    height: 0,
                    thickness: 2,
                  ),
                ),
                buildListDetailExpense()
              ],
            ),
          )
        : const SizedBox();
  }

  Widget buildListDetailExpense() {
    return Column(
      children: [
        for (var item in dataExpenseToChart)
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(5),
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: colors[dataExpenseToChart.indexOf(item)]),
              child: Center(child: Text('${item['measure']}%')),
            ),
            title: Text(item['domain']),
            trailing: Text(item['totalMoney'].toString().toVND()),
          )
      ],
    );
  }

  Widget buildTabIncome() {
    return dataIncomeToChart.isNotEmpty
        ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: AspectRatio(
                      aspectRatio: 2 / 1,
                      child: DChartBar(
                        data: [
                          {
                            'id': 'Bar',
                            'data': [...dataIncomeToChart]
                          }
                        ],
                        domainLabelPaddingToAxisLine: 16,
                        axisLineColor: const Color(AppColor.pink),
                        measureLabelPaddingToAxisLine: 16,
                        barColor: (barData, index, id) => colors[index!],
                        verticalDirection: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
