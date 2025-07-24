import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI colors for a consistent look
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}