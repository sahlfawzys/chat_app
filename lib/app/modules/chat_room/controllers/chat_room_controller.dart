import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatRoomController extends GetxController {
  var isShowEmoji = false.obs;
  int totalUnread = 0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late FocusNode focusNode;
  late TextEditingController chatC;
  late ScrollController scrollC;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChat(String chat_id) {
    CollectionReference chats = firestore.collection('chats');
    return chats
        .doc(chat_id)
        .collection('chat')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Object?>> streamFriendData(String friendEmail) {
    CollectionReference users = firestore.collection('users');
    return users.doc(friendEmail).snapshots();
  }

  void addEmojiToChat(Emoji emoji) {
    chatC.text = chatC.text + emoji.emoji;
  }

  void deleteEmoji() {
    chatC.text = chatC.text.substring(0, chatC.text.length - 2);
  }

  void newChat(String email, Map<String, dynamic> argument, String chat) async {
    if (chat != '') {
      CollectionReference chats = firestore.collection('chats');
      CollectionReference users = firestore.collection('users');
      String date = DateTime.now().toIso8601String();

      await chats.doc(argument['chat_id']).collection('chat').add(
        {
          'pengirim': email,
          'penerima': argument['friendEmail'],
          'message': chat,
          'time': date,
          'isRead': false,
          'groupTime': DateFormat.yMMMMd('en_US').format(DateTime.parse(date)),
        },
      );
      Timer(
        Duration.zero,
        () => scrollC.jumpTo(scrollC.position.maxScrollExtent),
      );
      chatC.clear();

      await users
          .doc(email)
          .collection('chats')
          .doc(argument['chat_id'])
          .update({'lastTime': date});

      final checkChatsFriend = await users
          .doc(argument['friendEmail'])
          .collection('chats')
          .doc(argument['chat_id'])
          .get();

      if (checkChatsFriend.exists) {
        await users
            .doc(argument['friendEmail'])
            .collection('chats')
            .doc(argument['chat_id'])
            .get()
            .then((value) =>
                totalUnread = (value.data()!['totalUnread'] as int) + 1);

        await users
            .doc(argument['friendEmail'])
            .collection('chats')
            .doc(argument['chat_id'])
            .update({
          'lastTime': date,
          'totalUnread': totalUnread,
        });
      } else {
        await users
            .doc(argument['friendEmail'])
            .collection('chats')
            .doc(argument['chat_id'])
            .set({
          'connection': email,
          'lastTime': date,
          'totalUnread': 1,
        });
      }
    }
  }

  @override
  void onInit() {
    focusNode = FocusNode();
    chatC = TextEditingController();
    scrollC = ScrollController();
    focusNode.addListener(() {
      if (focusNode.hasListeners) {
        isShowEmoji.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    focusNode.dispose();
    chatC.dispose();
    scrollC.dispose();
    super.onClose();
  }
}
