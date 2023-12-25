import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiptop/controllers/auth_controller.dart';
import 'package:tiptop/views/add_video_screen.dart';
import 'package:tiptop/views/screens/profile_screen.dart';
import 'package:tiptop/views/screens/search_screen.dart';
import 'package:tiptop/views/screens/video_screen.dart';

List pages = [
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(child: Text('Messages Screen')),
    ],
  ),
  ProfileScreen(uid: authController.user.uid),
];

// COLORS
 const backgroundColorLoginSignup = Color(0xff8c6efa);
const backgroundColor=Colors.black54;
// var buttonColor = Colors.red[400];
var buttonColor = Color(0xffffff);
const backgroundColors=Colors.black54;

const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;

