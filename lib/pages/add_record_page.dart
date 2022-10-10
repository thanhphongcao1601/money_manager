import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/helper/constant.dart';
import 'package:moneymanager/pages/home_cubit/home_cubit.dart';
import 'package:moneymanager/pages/home_cubit/home_state.dart';
import 'package:moneymanager/widgets/item_select.dart';
import 'package:uuid/uuid.dart';

import '../model/record.dart';

// ignore: must_be_immutable
class AddRecordPage extends StatefulWidget {
  const AddRecordPage({Key? key, required this.homeCubit}) : super(key: key);
  final HomeCubit homeCubit;

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage>
    with TickerProviderStateMixin {
  final formKeyExpense = GlobalKey<FormState>();
  final formKeyIncome = GlobalKey<FormState>();

  late bool isExpense;
  late bool showGenre;
  late bool showType;

  late TextEditingController datetimeC;
  late TextEditingController expenseTypeC;
  late TextEditingController genreC;
  late TextEditingController contentC;
  late TextEditingController moneyC;

  late DateTime dateTime;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    isExpense = true;
    showGenre = false;
    showType = true;

    datetimeC = TextEditingController();
    expenseTypeC = TextEditingController();
    genreC = TextEditingController();
    contentC = TextEditingController();
    moneyC = TextEditingController();
    dateTime = DateTime.now();
    _tabController = TabController(length: 2, vsync: this);
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
            "Quản lý chi tiêu",
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              controller: _tabController,
              tabs: const [
                Tab(
                  text: "Chi",
                ),
                Tab(
                  text: "Thu",
                )
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) => Form(
                  key: formKeyExpense,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DateTimeField(
                        initialValue: dateTime,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            icon: Icon(
                              Icons.date_range,
                              color: Color(AppColor.pink),
                            ),
                            hintText: 'Chọn ngày và giờ',
                            labelText: 'Ngày và giờ',
                            border: InputBorder.none),
                        format: DateFormat("yyyy-MM-dd h:mm a"),
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            dateTime = DateTimeField.combine(date, time);
                            return dateTime;
                          } else {
                            return currentValue;
                          }
                        },
                      ),
                      TextFormField(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        autofocus: true,
                        onTap: () {
                          setState(() {
                            showType = !showType;
                            showGenre = false;
                          });
                        },
                        readOnly: true,
                        controller: expenseTypeC,
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            icon: Icon(
                              Icons.category,
                              color: Color(AppColor.pink),
                            ),
                            labelText: 'Loại tài khoản',
                            border: InputBorder.none),
                      ),
                      showType
                          ? GridView.count(
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              childAspectRatio: 3 / 1,
                              children: [
                                for (var item
                                    in AppConstantList.listExpenseType)
                                  ItemSelect(
                                      item,
                                      expenseTypeC,
                                      () => {
                                            setState(() {
                                              showType = false;
                                            })
                                          })
                              ],
                            )
                          : const SizedBox(),
                      TextFormField(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        onTap: () {
                          setState(() {
                            showGenre = !showGenre;
                            showType = false;
                          });
                        },
                        readOnly: true,
                        controller: genreC,
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            icon: Icon(
                              Icons.category,
                              color: Color(AppColor.pink),
                            ),
                            hintText: 'Chọn thể loại bên dưới',
                            labelText: 'Thể loại',
                            border: InputBorder.none),
                      ),
                      showGenre
                          ? GridView.count(
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              childAspectRatio: 3 / 1,
                              children: [
                                for (var item in AppConstantList.listGenre)
                                  ItemSelect(
                                      item,
                                      genreC,
                                      () => {
                                            setState(() {
                                              showGenre = false;
                                            })
                                          })
                              ],
                            )
                          : const SizedBox(),
                      TextFormField(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        onTap: () {
                          setState(() {
                            moneyC.text = "";
                            showGenre = false;
                            showType = false;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Số tiền không được để trống';
                          }
                          return null;
                        },
                        controller: moneyC,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            icon:
                                Icon(Icons.money, color: Color(AppColor.pink)),
                            hintText: 'Nhập số tiền',
                            labelText: 'Số tiền',
                            border: InputBorder.none),
                      ),
                      TextFormField(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          setState(() {
                            showGenre = false;
                            showType = false;
                          });
                        },
                        controller: contentC,
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            icon: Icon(
                              Icons.add_box,
                              color: Color(AppColor.pink),
                            ),
                            hintText: 'Nhập nội dung',
                            labelText: 'Nội dung',
                            border: InputBorder.none),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                                child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(AppColor.pink)),
                              onPressed: () async {
                                if (formKeyExpense.currentState!.validate()) {
                                  final record = Record(
                                      id: const Uuid().v4(),
                                      type: expenseTypeC.text,
                                      datetime: dateTime.millisecondsSinceEpoch,
                                      genre: genreC.text,
                                      content: contentC.text,
                                      money: -int.parse(moneyC.text));

                                  Navigator.pop(context);
                                  widget.homeCubit.addRecordToPrefs(record);
                                }
                              },
                              child: const Text(
                                'Lưu',
                                style: TextStyle(color: Colors.black),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
      ),
    );
  }

  Widget buildTabIncome() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) => Form(
                  key: formKeyIncome,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DateTimeField(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        initialValue: dateTime,
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            icon: Icon(
                              Icons.date_range,
                              color: Color(AppColor.pink),
                            ),
                            hintText: 'Enter your date time',
                            labelText: 'Ngày và giờ',
                            border: InputBorder.none),
                        format: DateFormat("yyyy-MM-dd h:mm a"),
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            dateTime = DateTimeField.combine(date, time);
                            return dateTime;
                          } else {
                            return currentValue;
                          }
                        },
                      ),
                      TextFormField(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        autofocus: true,
                        onTap: () {
                          setState(() {
                            showType = !showType;
                            showGenre = false;
                          });
                        },
                        readOnly: true,
                        controller: expenseTypeC,
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            icon: Icon(
                              Icons.category,
                              color: Color(AppColor.pink),
                            ),
                            hintText: 'Choose expense type below',
                            labelText: 'Type',
                            border: InputBorder.none),
                      ),
                      showType
                          ? GridView.count(
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              childAspectRatio: 3 / 1,
                              children: [
                                for (var item
                                    in AppConstantList.listExpenseType)
                                  ItemSelect(
                                      item,
                                      expenseTypeC,
                                      () => {
                                            setState(() {
                                              showType = false;
                                            })
                                          })
                              ],
                            )
                          : const SizedBox(),
                      TextFormField(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        onTap: () {
                          setState(() {
                            moneyC.text = "";
                            showType = false;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Money can not null';
                          }
                          return null;
                        },
                        controller: moneyC,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            icon:
                                Icon(Icons.money, color: Color(AppColor.pink)),
                            hintText: 'Enter your money',
                            labelText: 'Money',
                            border: InputBorder.none),
                      ),
                      TextFormField(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textInputAction: TextInputAction.next,
                        onTap: () {
                          setState(() {
                            showType = false;
                          });
                        },
                        controller: contentC,
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            icon: Icon(
                              Icons.add_box,
                              color: Color(AppColor.pink),
                            ),
                            hintText: 'Enter your content',
                            labelText: 'Content',
                            border: InputBorder.none),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                                child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(AppColor.pink)),
                              onPressed: () async {
                                if (formKeyIncome.currentState!.validate()) {
                                  final record = Record(
                                      id: const Uuid().v4(),
                                      type: expenseTypeC.text,
                                      datetime: dateTime.millisecondsSinceEpoch,
                                      content: contentC.text,
                                      money: int.parse(moneyC.text));

                                  widget.homeCubit.addRecordToPrefs(record);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(color: Colors.black),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
      ),
    );
  }
}
