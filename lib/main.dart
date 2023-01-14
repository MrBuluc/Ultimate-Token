import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:ultimate_token/locator.dart';
import 'package:ultimate_token/ui/token_page.dart';
import 'package:ultimate_token/viewmodel/user_model.dart';

Future main() async {
  setupLocator();
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45
    ..radius = 10
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.orange
    ..textColor = Colors.red
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
        title: 'Ultimate Token',
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TokenPage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
