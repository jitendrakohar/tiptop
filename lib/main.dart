import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:get/get.dart';
import 'package:tiptop/constants.dart';
import 'package:tiptop/controllers/auth_controller.dart';

import 'package:wakelock/wakelock.dart';

import 'package:tiptop/views/screens/auth/login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp();
  } catch (e){
    print("Error initializing new: $e");
  }
  Wakelock.enable();

  Get.put(AuthController());
  if (Firebase.apps.isEmpty) {
    print("Firebase is not initialized");
  } else {
    print("Firebase is initialized");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TipTop',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColorLoginSignup,
      ),
      home: LoginScreen(),
    );
  }
}
