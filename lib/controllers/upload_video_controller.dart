import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiptop/constants.dart';
import 'package:tiptop/models/video.dart';
import 'package:tiptop/views/screens/home_screen.dart';
import 'package:video_compress/video_compress.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fluttertoast/fluttertoast.dart';
// import 'package:video_compress_plus/video_compress_plus.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

class UploadVideoController extends GetxController {
  _compressVideo(String videoPath) async {
    try {
      print("compressing: files");
      VideoCompress.setLogLevel(0);
      final compressedVideo = await VideoCompress.compressVideo(
        videoPath,
        quality: VideoQuality.LowQuality,

      );
      if(compressedVideo==null){
        print("compressed failed");
      }
      else{
        print("compressed successful");
        return compressedVideo.file;
      }

    } catch (e, stackTrace) {
      print('Error during video compression: $e');
      print('Stack trace: $stackTrace');
    }

  }

  //
  //  _compressVideo(  String path) async {
  //
  //   await VideoCompress.setLogLevel(0);
  //   final info = await VideoCompress.compressVideo(
  //     path,
  //     quality: VideoQuality.MediumQuality,
  //     deleteOrigin: false,
  //     includeAudio: true,
  //   );
  //   print(info!.path);
  //   return info;
  // }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask = ref.putFile(   await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;

  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }



  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String?> _getOutputFilePath(String videoName) async {
    final directory = await getTemporaryDirectory();

    String outputPath= '${directory
        .path}/${videoName+".mp4"}';

    return outputPath;// Replace with your desired output file path
  }




  Future<String> _mergeAudioAndVideo(String outputPath,String audioPath,String videoPath) async {



    // Build FFmpeg command
    List<String> arguments = [
      "-i", "$videoPath",
      "-i", "$audioPath",
      "-c:v", "copy",
      "-c:a", "aac",
      "-strict", "experimental",
      "-shortest",
      "-map", "0:v:0",
      "-map", "1:a:0",
      "$outputPath"
    ];


    FFmpegKit.executeWithArguments(arguments).then((session) async {

      // Unique session id created for this execution
      final sessionId = session.getSessionId();

      // Command arguments as a single string
      final command = session.getCommand();

      final commandArguments = session.getArguments();

      final state = await session.getState();


      final returnCode = await session.getReturnCode();


      if (returnCode==0) {
        print("Merge successful: ");

      } else if (returnCode==255) {
        // CANCELPrint
        print("Canceled merge:");

      } else {
        // ERROR
        print("Merge error: ");

      }
      print("Merge error: $outputPath");
      //("Merge error: $outputPath");


      return outputPath;

/*
      final startTime = session.getStartTime();
      final endTime = await session.getEndTime();
      final duration = await session.getDuration();

      // Console output generated for this execution
      final output = await session.getOutput();

      // The stack trace if FFmpegKit fails to run a command
      final failStackTrace = await session.getFailStackTrace();

      // showToast("failed: $failStackTrace");
      // The list of logs generated for this execution
      final logs = await session.getLogs();*/



    });
    return outputPath;












  }





  // upload video
  uploadVideo(String songName, String caption, String videoPath,String audioPath) async {

    final outputPath = await _getOutputFilePath(songName).then((value){
    print("Merge error: $videoPath");
      if(value!=null) {
        _mergeAudioAndVideo(value, audioPath, videoPath).then((asdf) async{
          await delay(15);

          try {

            String uid = firebaseAuth.currentUser!.uid;
            DocumentSnapshot userDoc =
            await firestore.collection('users').doc(uid).get();
            // get id
            var allDocs = await firestore.collection('videos').get();
            int len = allDocs.docs.length;

            // print("videos Path: $value  and $asdf ");
            // String videoUrl = await _uploadVideoToStorage("Video $len", value);
            // String thumbnail = await _uploadImageToStorage("Video $len", videoPath);

            String videoUrl = await _uploadVideoToStorage("Video $len", asdf);
            String thumbnail = await _uploadImageToStorage("Video $len", asdf);
            Video video = Video(
              username: (userDoc.data()! as Map<String, dynamic>)['name'],
              uid: uid,
              id: "Video $len",
              likes: [],
              commentCount: 0,
              shareCount: 0,
              songName: songName,
              caption: caption,
              videoUrl: videoUrl,
              profilePhoto: (userDoc.data()! as Map<String, dynamic>)['profilePhoto'],
              thumbnail: thumbnail,
            );

            await firestore.collection('videos').doc('Video $len').set(
              video.toJson(),
            );

            await playRingtone();

            Get.to(HomeScreen());
            // Get.back();
          } catch (e) {
            Get.snackbar(
              'Error Uploading Video',
              e.toString(),
            );

          }


        });
      }

    });


  }
  Future<void> delay(int seconds) {
    return Future.delayed(Duration(seconds: seconds));
  }
  playRingtone() async{
    final assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(
      Audio("assets/audio/success_notification.mp3"),
      autoStart: true,

    );
    assetsAudioPlayer.setVolume(1);
    assetsAudioPlayer.setLoopMode(LoopMode.single);
    assetsAudioPlayer.play();
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }


}
