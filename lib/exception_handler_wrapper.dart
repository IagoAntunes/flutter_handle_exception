import 'package:flutter/material.dart';

import 'flutter_exception_handler.dart';

class ExceptionHandlerWrapper extends StatefulWidget {
  final Widget child;
  const ExceptionHandlerWrapper({required this.child, super.key});

  @override
  State<ExceptionHandlerWrapper> createState() => _ExceptionHandlerWrapperState();
}

class _ExceptionHandlerWrapperState extends State<ExceptionHandlerWrapper> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ExceptionHandler.setContext(context);
  }

  @override
  void dispose() {
    ExceptionHandler.setContext(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
