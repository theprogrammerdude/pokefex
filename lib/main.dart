import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:pokefex/pages/home.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokefex',
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.dark(
        scheme: FlexScheme.aquaBlue,
      ),
      home: const Home(),
    );
  }
}
