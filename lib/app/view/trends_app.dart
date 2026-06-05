import 'package:flutter/material.dart';
import 'package:trends/home/view/home_page.dart';
import 'package:trends/theme/app_theme.dart';

class TrendsApp extends StatelessWidget {
  const TrendsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trends',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const HomePage(),
    );
  }
}
