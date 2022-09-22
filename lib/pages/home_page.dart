import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneymanager/pages/home_cubit/home_cubit.dart';
import 'package:moneymanager/pages/home_cubit/home_state.dart';

import '../helper/constant.dart';
import '../widgets/record_tile.dart';
import 'record_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit homeCubit;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    homeCubit = context.read<HomeCubit>();
    homeCubit.loadListRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Icon(
            Icons.menu,
            color: Colors.black,
          ),
          SizedBox(
            width: 5,
          )
        ],
        leading: Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.black45,
              border: Border.all(color: const Color(AppColor.yellow))),
        ),
        centerTitle: true,
        title: InkWell(
          onTap: (){
            print(homeCubit.listRecord.length);
          },
          child: const Text(
            'Money Manager',
            style: TextStyle(color: Colors.black),
          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlocProvider(
                        create: (_) => HomeCubit(),
                        child: NotePage(
                          homeCubit: homeCubit,
                        ),
                      )));
        },
        backgroundColor: const Color(AppColor.pink),
        child: const Icon(
          Icons.add,
          color: Color(AppColor.yellow),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) => Column(
                  children: [
                    buildDashBoard(),
                    Expanded(
                      child: listNote(),
                    )
                  ],
                )),
      ),
    );
  }

  Widget buildDashBoard() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: 80,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset:
                              const Offset(0, 4), // changes position of shadow
                        ),
                      ],
                      color: const Color(AppColor.pink),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        color: Color(AppColor.yellow),
                        size: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        homeCubit.totalIncome.toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            color: Color(AppColor.yellow),
                            fontWeight: FontWeight.bold),
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
                  alignment: Alignment.center,
                  height: 80,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset:
                              const Offset(0, 4), // changes position of shadow
                        ),
                      ],
                      color: const Color(AppColor.yellow),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_downward,
                        color: Color(AppColor.pink),
                        size: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        homeCubit.totalExpense.toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            color: Color(AppColor.pink),
                            fontWeight: FontWeight.bold),
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
              children: const [
                Text(
                  'Số dư còn lại: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "8888",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              color: const Color(AppColor.pink),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "15/9/2000",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "7777",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            for (var record in homeCubit.listRecord) NoteTile(record)
          ],
        )
      ],
    );
  }
}
