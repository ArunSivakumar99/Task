import 'package:flutter/material.dart';

class Custompageroute extends PageRouteBuilder {
  final Widget child;

  Custompageroute({required this.child})
      : super(
            transitionDuration: Duration(seconds: 2),
            pageBuilder: (context, animation, secondaryanimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1.5, 0), end: Offset.zero)
          .animate(animation),
      child: child,
    );
  }
}
