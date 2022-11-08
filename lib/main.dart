import 'package:flutter/material.dart';
// import 'package:mybook/pages/home/home.dart';
import 'package:mybook/pages/provider/username.dart';
import 'package:mybook/routes.dart';
import 'package:provider/provider.dart';
import 'pages/splash/splash.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Username(),
    
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Books",
      debugShowCheckedModeBanner: false,
      initialRoute: Splash.routesName,
      routes: routes,
    );
  }
}
