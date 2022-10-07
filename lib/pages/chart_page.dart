import 'package:d_chart/d_chart.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/helper/constant.dart';
import 'package:moneymanager/pages/home_cubit/home_cubit.dart';

// ignore: must_be_immutable
class ChartPage extends StatefulWidget {
  const ChartPage({Key? key, required this.homeCubit}) : super(key: key);
  final HomeCubit homeCubit;

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Map<String, dynamic>> dataFromPref;
  late int total;

  @override
  void initState() {
    super.initState();
    dataFromPref = [];
    total = 0;
    _tabController = TabController(length: 2, vsync: this);
    for (var item in widget.homeCubit.listRecordGroupByGenre.entries) {
      total += item.value.sumBy<int>((e) => e.money! < 0 ? e.money! : 0);
    }

    for (var item in widget.homeCubit.listRecordGroupByGenre.entries) {
      dataFromPref.add({
        'domain': item.key,
        'measure': (item.value.sumBy<int>((e) => e.money! < 0 ? e.money! : 0) /
                total *
                100)
            .round()
      });
    }

    print(dataFromPref.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              tabs: const [
                Tab(
                  text: "Tháng",
                ),
                Tab(
                  text: "Tuần",
                ),
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            buildTabMonth(),
            buildTabWeek(),
          ],
        ));
  }

  Widget buildTabMonth() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: DChartPie(
                data: dataFromPref,
                fillColor: (pieData, index) => Colors.brown[100 * (index! + 1)],
                pieLabel: (pieData, index) {
                  return "${pieData['domain']}:\n${pieData['measure']}%";
                },
                labelPosition: PieLabelPosition.outside,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabWeek() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: DChartBar(
                  data: const [
                    {
                      'id': 'Bar',
                      'data': [
                        {'domain': 'Monday', 'measure': 3},
                        {'domain': 'Tuesday', 'measure': 4},
                        {'domain': 'Wednesday', 'measure': 6},
                        {'domain': 'Thursday', 'measure': 1.3},
                        {'domain': 'Friday', 'measure': 1.3},
                        {'domain': 'Saturday', 'measure': 1.3},
                        {'domain': 'Sunday', 'measure': 1.3},
                      ],
                    },
                  ],
                  domainLabelPaddingToAxisLine: 16,
                  axisLineColor: Colors.green,
                  measureLabelPaddingToAxisLine: 16,
                  barColor: (barData, index, id) => Colors.green,
                  verticalDirection: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
