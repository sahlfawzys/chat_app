import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
            elevation: 5,
            child: Container(
              margin: EdgeInsets.only(top: context.mediaQueryViewPadding.top),
              padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black38,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chats',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.red[900],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => Get.toNamed(Routes.PROFILE),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.chatsStream(authC.user.value.email!),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.active) {
                  var listDocChats = snapshot1.data!.docs;
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: listDocChats.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        stream: controller
                            .friendStream(listDocChats[index]['connection']),
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState ==
                              ConnectionState.active) {
                            var data = snapshot2.data!.data();
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              onTap: () => controller.goToChatroom(
                                  '${listDocChats[index].id}',
                                  authC.user.value.email!,
                                  listDocChats[index]['connection']),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.black26,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: data!['photoUrl'] == 'noimage'
                                      ? Image.asset(
                                          'assets/logo/noimage.png',
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          '${data['photoUrl']}',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              title: Text(
                                '${data['name']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text('${data['status']}'),
                              trailing: listDocChats[index]['totalUnread'] == 0
                                  ? SizedBox()
                                  : Chip(
                                      backgroundColor: Colors.red[900],
                                      label: Text(
                                        '${listDocChats[index]['totalUnread']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH),
        child: Icon(Icons.search),
        backgroundColor: Colors.red[900],
      ),
    );
  }
}
