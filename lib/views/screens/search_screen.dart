import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiptop/models/user.dart';
import 'package:tiptop/controllers/search_controller.dart';
import 'package:tiptop/views/screens/profile_screen.dart';

import '../../constants.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  SearchControllers searchController = Get.put(SearchControllers());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        // backgroundColor:Colors.white54,
        appBar: AppBar(
          backgroundColor: buttonColor,
          title: TextFormField(
            enabled: true,
            decoration: const InputDecoration(
              filled: false,
              hintText: 'Search',
              icon: Icon(Icons.search),

              hintStyle: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onFieldSubmitted: (value) => searchController.searchUser(value),
          ),
        ),
        body: searchController.searchedUsers.isEmpty
            ? const Center(
          child: Text(
            'Search for users!',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : ListView.builder(
          itemCount: searchController.searchedUsers.length,
          itemBuilder: (context, index) {
            User user = searchController.searchedUsers[index];
            return InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(uid: user.uid),
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.profilePhoto,
                  ),
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
