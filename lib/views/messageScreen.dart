import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiptop/constants.dart';
import 'package:tiptop/controllers/comment_controller.dart';
import 'package:timeago/timeago.dart' as tago;

class messageScreen extends StatelessWidget {
  // final String id;
  messageScreen({
    Key? key,
    // required this.id,
  }) : super(key: key);


  CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    commentController.getCommentAllVideos();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        // toolbarHeight: 0.08*size.height,
        title: Container(
          child: Text("Notification",
          style: TextStyle(

            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),),

        ),

      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height-0.1*size.height,
          child: Obx((){
            return    Center(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    commentController.noOfComment!=0?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.notifications_active,
                        size: 0.1*size.width),


                        Text("${commentController.noOfComment} peoples commented on your post"
                        ,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                      ],
                    )
                        :Row(
                      children: [
                        Icon(Icons.notifications_active,
                            size: 0.08*size.width),


                        Text("Till now, there are no Comment in your post",


                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                      ],
                        ),

                  ],
                ),
              ),
            );
          })


        ),
      ),
    );
  }
}
