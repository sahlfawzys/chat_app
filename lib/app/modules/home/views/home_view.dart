import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/modules/home/views/DrawerScreen.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:chatapp/app/utils/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: ColorApp.secondary,
      ),
      drawer: DrawerScreen(),
      body: Container(
        color: ColorApp.primary,
        child: Column(
          children: [
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
                                contentPadding: const EdgeInsets.symmetric(
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
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text('${data['status']}'),
                                trailing:
                                    listDocChats[index]['totalUnread'] == 0
                                        ? const SizedBox()
                                        : Chip(
                                            backgroundColor: Colors.red[900],
                                            label: Text(
                                              '${listDocChats[index]['totalUnread']}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                              );
                            }
                            return const Center(
                              child: const CircularProgressIndicator(),
                            );
                          },
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH),
        child: const Icon(Icons.message),
        backgroundColor: Colors.blue[700],
      ),
    );
  }
}
