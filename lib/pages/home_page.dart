import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:moneymanager/pages/chart_page.dart';
import 'package:moneymanager/pages/home_cubit/home_cubit.dart';
import 'package:moneymanager/pages/home_cubit/home_state.dart';
import '../helper/constant.dart';
import '../widgets/record_tile.dart';
import 'add_record_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit homeCubit;
  late int currentIndex;

  @override
  initState() {
    super.initState();
    homeCubit = context.read<HomeCubit>();
    homeCubit.loadListRecord();
    currentIndex = 0;
  }

  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
      if (index == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChartPage(homeCubit: homeCubit),
            ));
      }
    });
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
                  homeCubit: homeCubit,
                ),
              ));
        },
        backgroundColor: const Color(AppColor.yellow),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
        fabLocation: BubbleBottomBarFabLocation.end,
        //new
        hasNotch: true,
        //new
        hasInk: true,
        //new, gives a cute ink effect
        inkColor: Colors.black12,
        //optional, uses theme color if not specified
        items: const <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Color(AppColor.pink),
              icon: Icon(
                Icons.access_time,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.access_time,
                color: Color(AppColor.yellow),
              ),
              title: Text("Nhật ký")),
          BubbleBottomBarItem(
              backgroundColor: Color(AppColor.pink),
              icon: Icon(
                Icons.dashboard,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Color(AppColor.yellow),
              ),
              title: Text("Thống kê")),
          BubbleBottomBarItem(
              backgroundColor: Color(AppColor.pink),
              icon: Icon(
                Icons.folder_open,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.folder_open,
                color: Color(AppColor.yellow),
              ),
              title: Text("Sao lưu")),
          BubbleBottomBarItem(
              backgroundColor: Color(AppColor.pink),
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.settings,
                color: Color(AppColor.yellow),
              ),
              title: Text("Cài đặt"))
        ],
      ),
      appBar: AppBar(
        // actions: const [
        //   Icon(
        //     Icons.menu,
        //     color: Colors.black,
        //   ),
        //   SizedBox(
        //     width: 5,
        //   )
        // ],
        // leading: Container(
        //   width: 50,
        //   height: 50,
        //   margin: const EdgeInsets.all(5),
        //   decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(100),
        //       color: Colors.black45,
        //       border: Border.all(color: const Color(AppColor.yellow))),
        // ),
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
        child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) => state is HomeLoaded
                ? Column(
                    children: [
                      buildDashBoard(),
                      Expanded(
                        child: listNote(),
                      )
                    ],
                  )
                : const SizedBox()),
      ),
    );
  }

  Widget buildDashBoard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                "https://media.istockphoto.com/vectors/beige-minimal-coffee-color-background-vector-id1364440645?b=1&k=20&m=1364440645&s=612x612&w=0&h=pFwEnJAVWFotQFp7PO_GRONYGu4lWt4yVbxH0RUyFg8="),
            fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 80,
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
                      Text(
                        homeCubit.totalIncome.toString().toVND(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                  height: 80,
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
                      Text(
                        homeCubit.totalExpense.toString().toVND(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            height: 40,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Số dư còn lại: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  (homeCubit.totalIncome + homeCubit.totalExpense)
                      .toString()
                      .toVND(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget listNote() {
    return ListView(
      children: [
        for (var item in homeCubit.listRecordGroupByDate.entries)
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
                NoteTile(
                    context: context, homeCubit: homeCubit, record: record),
            ],
          )
      ],
    );
  }
}
