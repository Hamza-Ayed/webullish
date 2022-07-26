import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'page/home.dart';
import 'page/input_alert.dart';

Future backgrounMessage(RemoteMessage message) async {
  // print('===========back===');
 Get.to(() => const InputAlert());

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgrounMessage);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WeBullish',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Main(),
    );
  }
}
