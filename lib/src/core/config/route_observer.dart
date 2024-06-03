import 'package:flutter/material.dart';

/// To get routeNamed use `final routeNamed = route?.settings.name`
class CustomRouteObserver extends NavigatorObserver {
  CustomRouteObserver({
    required this.onRouteChanged,
    this.onRouteReplaced,
  });

  final void Function(Route? newRoute, Route? previousRoute) onRouteChanged;
  final void Function(Route? newRoute, Route? oldRoute)? onRouteReplaced;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    onRouteChanged(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    onRouteChanged(previousRoute, route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    onRouteReplaced?.call(newRoute, oldRoute);
  }
}
