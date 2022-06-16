import 'dart:async';

import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  final authC = Get.find<AuthController>();
  final String chat_id = (Get.arguments as Map<String, dynamic>)['chat_id'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        leadingWidth: 100,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          borderRadius: BorderRadius.circular(100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 10),
              Icon(Icons.arrow_back),
              SizedBox(width: 10),
              CircleAvatar(
                radius: 23,
                backgroundColor: Colors.grey,
                child: StreamBuilder<DocumentSnapshot<Object?>>(
                  stream: controller.streamFriendData(
                      (Get.arguments as Map<String, dynamic>)['friendEmail']),
                  builder: (context, snapshotPhoto) {
                    if (snapshotPhoto.connectionState ==
                        ConnectionState.active) {
                      var friendPhoto =
                          snapshotPhoto.data!.data() as Map<String, dynamic>;
                      if (friendPhoto['photoUrl'] == 'noimage') {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/logo/noimage.png',
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            friendPhoto['photoUrl'],
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/logo/noimage.png',
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        title: StreamBuilder<DocumentSnapshot<Object?>>(
            stream: controller.streamFriendData(
                (Get.arguments as Map<String, dynamic>)['friendEmail']),
            builder: (context, snapshotData) {
              if (snapshotData.connectionState == ConnectionState.active) {
                var dataFriend =
                    snapshotData.data!.data() as Map<String, dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataFriend['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      dataFriend['status'],
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'loading',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'loading',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              );
            }),
        centerTitle: false,
      ),
      body: WillPopScope(
        onWillPop: () {
          if (controller.isShowEmoji.isTrue) {
            controller.isShowEmoji.value = false;
          } else {
            Navigator.pop(context);
          }
          return Future.value(false);
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.streamChat(chat_id),
                  builder: (context, snapshotChat) {
                    if (snapshotChat.connectionState ==
                        ConnectionState.active) {
                      var alldata = snapshotChat.data!.docs;
                      print('alldata => $alldata');
                      print(alldata.length);
                      Timer(
                        Duration.zero,
                        () => controller.scrollC.jumpTo(
                            controller.scrollC.position.maxScrollExtent),
                      );
                      return ListView.builder(
                        controller: controller.scrollC,
                        itemCount: alldata.length,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${alldata[index]['groupTime']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                itemChat(
                                  message: '${alldata[index]['message']}',
                                  isSender: alldata[index]['pengirim'] ==
                                          authC.user.value.email
                                      ? true
                                      : false,
                                  time: '${alldata[index]['time']}',
                                ),
                              ],
                            );
                          } else {
                            if (alldata[index]['groupTime'] ==
                                alldata[index - 1]['groupTime']) {
                              return itemChat(
                                message: '${alldata[index]['message']}',
                                isSender: alldata[index]['pengirim'] ==
                                        authC.user.value.email
                                    ? true
                                    : false,
                                time: '${alldata[index]['time']}',
                              );
                            } else {
                              return Column(
                                children: [
                                  Text(
                                    '${alldata[index]['groupTime']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  itemChat(
                                    message: '${alldata[index]['message']}',
                                    isSender: alldata[index]['pengirim'] ==
                                            authC.user.value.email
                                        ? true
                                        : false,
                                    time: '${alldata[index]['time']}',
                                  ),
                                ],
                              );
                            }
                          }
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: controller.isShowEmoji.isTrue
                      ? 5
                      : context.mediaQueryPadding.bottom),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: TextField(
                        autocorrect: false,
                        controller: controller.chatC,
                        focusNode: controller.focusNode,
                        onEditingComplete: () => controller.newChat(
                          authC.user.value.email!,
                          Get.arguments as Map<String, dynamic>,
                          controller.chatC.text,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            onPressed: () {
                              controller.focusNode.unfocus();
                              controller.isShowEmoji.toggle();
                            },
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Material(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.red[900],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => controller.newChat(
                        authC.user.value.email!,
                        Get.arguments as Map<String, dynamic>,
                        controller.chatC.text,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => (controller.isShowEmoji.isTrue)
                  ? Container(
                      height: 320,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          controller.addEmojiToChat(emoji);
                        },
                        onBackspacePressed: () {
                          controller.deleteEmoji();
                        },
                        config: Config(
                            columns: 7,
                            emojiSizeMax: 32 *
                                (GetPlatform.isIOS
                                    ? 1.30
                                    : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            initCategory: Category.RECENT,
                            bgColor: Color(0xFFF2F2F2),
                            indicatorColor: Colors.blue,
                            iconColor: Colors.grey,
                            iconColorSelected: Colors.blue,
                            progressIndicatorColor: Colors.blue,
                            showRecentsTab: true,
                            recentsLimit: 28,
                            noRecentsText: "No Recents",
                            noRecentsStyle: const TextStyle(
                                fontSize: 20, color: Colors.black26),
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class itemChat extends StatelessWidget {
  const itemChat({
    Key? key,
    required this.isSender,
    required this.message,
    required this.time,
  }) : super(key: key);

  final bool isSender;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red[900],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: isSender ? Radius.circular(15) : Radius.zero,
                bottomRight: isSender ? Radius.zero : Radius.circular(15),
              ),
            ),
            padding: EdgeInsets.all(15),
            child: Text(
              '$message',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 5),
          Text('${DateFormat.jm().format(DateTime.parse(time))}'),
        ],
      ),
    );
  }
}
