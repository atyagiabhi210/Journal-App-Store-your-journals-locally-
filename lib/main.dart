import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:journal_local_app/core/theme/app_theme.dart';
import 'package:journal_local_app/features/homepage/presentation/bloc/home_bloc.dart';
import 'package:journal_local_app/features/homepage/presentation/pages/homepage.dart';
import 'package:journal_local_app/init_dependencies.dart';

void main() {
  initDependencies();
  runApp(
    BlocProvider(
      create: (_) => serviceLocator<HomeBloc>(),
      child: (const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: HomePage(),
    );
  }
}
