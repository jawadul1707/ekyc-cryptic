import 'package:flutter/material.dart';
import 'package:crypt/pages/home_page.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // Root Widget of Application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
