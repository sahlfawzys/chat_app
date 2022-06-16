import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  late TextEditingController searchC;

  var queryAwal = [].obs;
  var tempSearch = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchFriend(String data, String email) async {
    if (data.length == 0) {
      queryAwal.value = [];
      tempSearch.value = [];
    } else {
      var capitalized = data.substring(0, 1).toUpperCase() + data.substring(1);
      if (queryAwal.length == 0 && data.length == 1) {
        CollectionReference user = await firestore.collection('users');
        final keyNameResult = await user
            .where('keyName', isEqualTo: data.substring(0, 1).toUpperCase())
            .where('email', isNotEqualTo: email)
            .get();
        print('Total data : ${keyNameResult.docs.length}');
        if (keyNameResult.docs.length > 0) {
          for (int i = 0; i < keyNameResult.docs.length; i++) {
            queryAwal.add(keyNameResult.docs[i].data() as Map<String, dynamic>);
          }
          print("Query result :");
          print(queryAwal);
        } else {
          print('Tidak ada data');
        }
      }

      if (queryAwal.length != 0) {
        tempSearch.value = [];
        queryAwal.forEach((element) {
          print(capitalized);
          if ((element['name'] as String)
              .toLowerCase()
              .startsWith(capitalized.toLowerCase())) {
            print(element['name']);
            tempSearch.add(element);
          }
        });
      }
    }

    queryAwal.refresh();
    tempSearch.refresh();
  }

  @override
  void onInit() {
    searchC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
