import 'package:flutter/material.dart';

abstract class ReportMode {
  void report(BuildContext context, dynamic error, StackTrace stackTrace);
}
