import 'package:flutter/material.dart';

import 'flutter_exception_handler.dart';

class ExceptionNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    ExceptionHandler.setContext(route.navigator!.context);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    ExceptionHandler.setContext(route.navigator!.context);
  }
}
