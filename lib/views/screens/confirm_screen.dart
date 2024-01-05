import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiptop/controllers/upload_video_controller.dart';
import 'package:tiptop/views/screens/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const ConfirmScreen({
    Key? key,
    required this.videoFile,
    required this.videoPath,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController controller;
  TextEditingController _songController = TextEditingController();
  TextEditingController _captionController = TextEditingController();

  UploadVideoController uploadVideoController =
      Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videoFile);
    });
    controller.initialize();
    //controller.play();
    uploadVideoController.playRingtone();
    controller.setVolume(1);
    controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  String audioPath="";
  String audioName="";
  Future<String?> _getAudioFilePath() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      // allowedExtensions: ['m4a','mp3']
    );


    if (result != null) {
      // File file = File(result.files.single.path!);
      audioPath=result.files.single.path!;
      audioName=result.files.single.name;
      _captionController.text=audioName;
      _songController.text=audioName;
      setState(() {

      });
      // showToast("$audioPath");
      return audioPath;

    } else {
      // User canceled the picker
    }

    return null; // Replace with your audio file path
  }



  @override
  Widget build(BuildContext context) {
    // _songController.text=widget.videoPath;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(

              child: Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: VideoPlayer(controller),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    // color: Colors.red,
                    child: Align(
                     alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: (){
                          _getAudioFilePath();

                        },
                        child: Card(
                          elevation: 3,
                          color: Colors.white12,

                          child: Container(
                            width: MediaQuery.of(context).size.width/2.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Add Music",
                                    style: GoogleFonts.caudex(
                                      fontSize: 22,
                                      color: Colors.white
                                    )
                                ),
                                Container(
                                    child:Icon(Icons.audiotrack,color: Colors.white,
                                    )


                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _songController,
                      labelText: 'Song Name',
                      icon: Icons.music_note,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _captionController,
                      labelText: 'Caption',
                      icon: Icons.closed_caption,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      // onPressed: {(){uploadVideoController.uploadVideo(
                      //     _songController.text,
                      //     _captionController.text,
                      //     widget.videoPath),
                      onPressed: () {
                        loading(context);
                        uploadVideoController.uploadVideo(_songController.text,
                            _captionController.text, widget.videoPath,audioPath);
                      },
                      child: const Text(
                        'Share!',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  loading(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
  }
}
