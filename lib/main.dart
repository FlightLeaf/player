import 'package:flutter/material.dart';
import 'package:player/tools/dataUtils.dart';
import 'package:player/view/home.dart';

void main() {
  //确保 Flutter 的绑定已经初始化，以便正确运行 Flutter 应用程序
  WidgetsFlutterBinding.ensureInitialized();
  //持久化储存工具类初始化
  DataUtils.init();
  //UI入口
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '悦音APP',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue,
        useMaterial3: true,
        fontFamily: '黑体',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 26.0),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: const HomePage(),
    );
  }
}
