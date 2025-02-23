import 'package:flutter/material.dart';

import 'i_report_mode.dart';

class SnackBarReportMode implements ReportMode {
  @override
  void report(BuildContext context, dynamic error, StackTrace stackTrace) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $error')),
    );
  }
}
