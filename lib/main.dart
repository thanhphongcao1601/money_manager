import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/home_cubit/home_cubit.dart';
import 'pages/home_page.dart';

void main() {
  runApp(BlocProvider(
      create: (_) => HomeCubit(),
      child: const MaterialApp(debugShowCheckedModeBanner: false, home: HomePage())));
}
