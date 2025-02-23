import 'package:flutter/material.dart';
import 'package:flutter_exception_handler/report_modes/i_report_mode.dart';

class DialogReportMode implements ReportMode {
  @override
  void report(BuildContext context, dynamic error, StackTrace stackTrace) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text('$error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
