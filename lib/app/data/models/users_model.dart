class UsersModel {
  String? uid;
  String? name;
  String? keyName;
  String? email;
  String? creationTime;
  String? lastSignInTime;
  String? photoUrl;
  String? status;
  String? updatedTime;
  List<ChatUser>? chats;

  UsersModel(
      {this.uid,
      this.name,
      this.keyName,
      this.email,
      this.creationTime,
      this.lastSignInTime,
      this.photoUrl,
      this.status,
      this.updatedTime,
      this.chats});

  UsersModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    keyName = json['keyName'];
    email = json['email'];
    creationTime = json['creationTime'];
    lastSignInTime = json['lastSignInTime'];
    photoUrl = json['photoUrl'];
    status = json['status'];
    updatedTime = json['updatedTime'];
    // if (json['chats'] != null) {
    //   chats = <ChatUser>[];
    //   json['chats'].forEach((v) {
    //     chats?.add(ChatUser.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['keyName'] = keyName;
    data['email'] = email;
    data['creationTime'] = creationTime;
    data['lastSignInTime'] = lastSignInTime;
    data['photoUrl'] = photoUrl;
    data['status'] = status;
    data['updatedTime'] = updatedTime;
    // if (chats != null) {
    //   data['chats'] = chats?.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class ChatUser {
  String? connection;
  String? chatId;
  String? lastTime;
  int? totalUnread;

  ChatUser({this.connection, this.chatId, this.lastTime, this.totalUnread});

  ChatUser.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    chatId = json['chatId'];
    lastTime = json['lastTime'];
    totalUnread = json['totalUnread'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['connection'] = connection;
    data['chatId'] = chatId;
    data['lastTime'] = lastTime;
    data['totalUnread'] = totalUnread;
    return data;
  }
}
