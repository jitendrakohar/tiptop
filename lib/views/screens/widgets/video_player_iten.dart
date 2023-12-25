import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>   {

  late VideoPlayerController videoPlayerController;
  bool isplaying=true;
  bool _isIconVisible = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        setState(() {
          _isIconVisible = false;
        });
      });
  }



  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: ((){


        if(videoPlayerController.value.isPlaying){
          videoPlayerController.pause();
         isplaying=false;

        }
        else{
          videoPlayerController.play();
          isplaying=true;
        }
        _showIconFor2Seconds();

      }),
      child: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: VideoPlayer(videoPlayerController),
          ),
          Center(
            child: Container(

              child: Visibility(
                visible: _isIconVisible,
                child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child:Icon(videoPlayerController.value.isPlaying ? Icons.play_circle:Icons.pause_circle,
                      size: 80,
                    )
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


    void _showIconFor2Seconds() {
      setState(() {
        _isIconVisible = true;
      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {

          _isIconVisible = false;
        });
      });
    }

  }
