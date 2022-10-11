import 'package:auto_size_text/auto_size_text.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:moneymanager/pages/home/home_page.dart';
import '../helper/constant.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/record_tile.dart';
import 'add_record/add_record_page.dart';
import 'app_cubit/app_cubit.dart';
import 'app_cubit/app_state.dart';
import 'chart/chart_page.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  late AppCubit appCubit;

  @override
  initState() {
    super.initState();
    appCubit = context.read<AppCubit>();
    appCubit.loadListRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddRecordPage(
                  appCubit: appCubit,
                ),
              ));
        },
        backgroundColor: const Color(AppColor.yellow),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BlocBuilder<AppCubit, AppState>(
          builder: (context, state) => buildBottomBar(appCubit.currentIndex,
              (int? newIndex) => appCubit.changePage(newIndex, context))),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Quản lý chi tiêu',
          style: TextStyle(color: Colors.black),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: <Color>[Color(AppColor.pink), Color(AppColor.yellow)]),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<AppCubit, AppState>(builder: (context, state) {
          switch (state) {
            case HomePageLoaded():
              return const HomePage();
            case ChartPageLoaded():
              return const ChartPage();
            case SettingPageLoaded():
              return const HomePage();
            default:
              const HomePage();
          }
          return const HomePage();
        }),
      ),
    );
  }

  Widget buildDashBoard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/dashboardbg.jpg"),
            fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ], borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                        size: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          appCubit.totalIncome.toString().toVND(),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ], borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_downward,
                        color: Colors.redAccent,
                        size: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          appCubit.totalExpense.toString().toVND(),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            // decoration: BoxDecoration(
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.white.withOpacity(0.5),
            //         spreadRadius: 3,
            //         blurRadius: 4,
            //         offset: const Offset(0, 4), // changes position of shadow
            //       ),
            //     ],
            //     // color: Colors.grey[200],
            //     borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Số dư còn lại: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      (appCubit.totalIncome + appCubit.totalExpense)
                          .toString()
                          .toVND(),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listNote() {
    return ListView(
      children: [
        for (var item in appCubit.listRecordGroupByDate.entries)
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                color: const Color(AppColor.pink),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.key,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      item.value.sumBy<int>((e) => e.money!).toString().toVND(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              for (var record in item.value)
                NoteTile(context: context, appCubit: appCubit, record: record),
            ],
          )
      ],
    );
  }
}
