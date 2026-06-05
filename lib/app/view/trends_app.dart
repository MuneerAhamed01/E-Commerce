import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trends/analytics/analytics.dart';
import 'package:trends/home/view/home_page.dart';
import 'package:trends/theme/app_theme.dart';

class TrendsApp extends StatelessWidget {
  const TrendsApp({
    required this.analyticsRepository,
    super.key,
  });

  final AnalyticsRepository analyticsRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AnalyticsRepository>.value(
      value: analyticsRepository,
      child: MaterialApp(
        title: 'Trends',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const HomePage(),
      ),
    );
  }
}
