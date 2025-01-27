import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:ios_color_picker/custom_picker/ios_color_picker.dart';
import 'package:ios_color_picker/custom_picker/pickers/area_picker.dart';
import 'package:ios_color_picker/native_picker/ios_color_picker.dart';
import 'package:ios_color_picker/show_ios_color_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color backgroundColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                ShowIOSColorPicker().showNativeIosColorPicker(
                    // context: context,
                    startingColor: backgroundColor,
                    onColorChanged: (color) {
                      setState(() {
                        backgroundColor = color;
                      });
                    });
              },
              child: Text("SelectColor"),
            ),
          ),
        ],
      ),
    );
  }
}
