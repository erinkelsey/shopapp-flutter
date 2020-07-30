import 'package:flutter/material.dart';

/// Screen to show when app is loading.
///
/// Shown before authentication screen, when determining
/// if user is already authenticated.
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
