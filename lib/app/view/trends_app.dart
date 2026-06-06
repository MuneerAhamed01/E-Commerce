import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trends/analytics/analytics.dart';

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
        home: const ComponentShowcasePage(),
      ),
    );
  }
}
