import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneymanager/helper/constant.dart';

// ignore: must_be_immutable
class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
            "Chart page",
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              controller: _tabController,
              tabs: const [
                Tab(
                  text: "Day",
                ),
                Tab(
                  text: "Week",
                ),
                Tab(
                  text: "Month",
                )
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            buildTabDay(),
            buildTabWeek(),
            buildTabMonth(),
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
                data: const [
                  {'domain': 'Flutter', 'measure': 28},
                  {'domain': 'React Native', 'measure': 27},
                  {'domain': 'Ionic', 'measure': 20},
                  {'domain': 'Cordova', 'measure': 15},
                ],
                fillColor: (pieData, index) {
                  switch (pieData['domain']) {
                    case 'Flutter':
                      return Colors.blue;
                    case 'React Native':
                      return Colors.blueAccent;
                    case 'Ionic':
                      return Colors.lightBlue;
                    default:
                      return Colors.orange;
                  }
                },
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

  Widget buildTabDay() {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text('Test'),
      ),
    );
  }

}
