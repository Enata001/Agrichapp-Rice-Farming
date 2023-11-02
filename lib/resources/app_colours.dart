import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const forestGreen = Color.fromARGB(255, 20, 120, 16);
  static const clearGreen = Color.fromARGB(255, 148, 194, 147);
  static final profileColour =
      Colors.primaries[Random().nextInt(Colors.primaries.length)];
}

extension AppxColors on BuildContext {
  Gradient get secondaryGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [
          Color.fromARGB(255, 20, 120, 16),
          Color.fromARGB(0, 125, 170, 123)
        ],
      );

  BoxDecoration get background => BoxDecoration(
        image: const DecorationImage(
          alignment: Alignment.topCenter,
          opacity: 0.1,
          image: AssetImage('assets/images/logo.png'),
        ),
        gradient: secondaryGradient,
      );

  InputDecoration get searchStyle => InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Search",
        suffixIcon: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
          ),
        ),
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      );
}
