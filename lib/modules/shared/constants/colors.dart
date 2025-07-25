import 'package:flutter/material.dart';
import 'dart:math';

const Color primaryBlue = Color(0xFF355E90);

final List<Color> avatarColors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.indigo,
  Colors.brown,
];

Color getRandomAvatarColor() {
  final random = Random();
  return avatarColors[random.nextInt(avatarColors.length)];
}
