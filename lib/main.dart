import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vahak_assesment/screen/HomeScreen.dart';
import 'package:vahak_assesment/utils/Constant.dart';
import 'package:vahak_assesment/utils/NetworkConnectionStatus.dart';

NetworkConnectionStatus connectionStatus = NetworkConnectionStatus.getInstance();

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(Constant.HIVE_BOX_NAME);
  runApp(App());
}

class App extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    connectionStatus.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vahak Assesment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
