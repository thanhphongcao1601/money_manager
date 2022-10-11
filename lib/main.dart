import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneymanager/pages/app_cubit/app_cubit.dart';
import 'package:moneymanager/pages/app_page.dart';

void main() {
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(create: (_) => AppCubit())
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false, home: AppPage())));
}
