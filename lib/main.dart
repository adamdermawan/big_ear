import 'dart:async';
import 'package:big_ear/modules/shared/view/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
 // Import your ErrorView

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // System UI config
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Global error widget for build-time errors
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material(
      child: ErrorView(
        message: 'Terjadi kesalahan tak terduga.\nSilakan coba lagi nanti.',
      ),
    );
  };

  runZonedGuarded(() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details); // Still prints to console
    };

    runApp(const MyApp());
  }, (error, stackTrace) {
    // You can log this to Firebase Crashlytics or Sentry here
    print('Caught by runZonedGuarded: $error');
  });
}
