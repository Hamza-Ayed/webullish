import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:webullish/constant/contant.dart';
import 'package:webullish/db/db.dart';

import '../page/input_alert.dart';

class Methods {
  final fcmToken = FirebaseMessaging.instance;
  final box = GetStorage();
  // List recives = [
  //   'ee5dlff8RXKz3_edaeQqU7:APA91bFKyF6FoVHUT7cUkYGSVoEtaJR-BG2-NjqJLqYDm2QWFvWsH9G1xldFdTZXtWsNO4v_pLTUtv-MkjnMGY1PlX208WEvLU1vZPg51tJe_dYVHcVcqXRiZntrvgQL3uE0y0Vwjwt5',
  //   'c86P0fsCVEgnndmtwJnZQf:APA91bHWAS64zz5xT24rMW_vM5NPufzfh-i0pNdLi6NCiJvkmhnPtl2P7I2j15Wbj823EHD3OLmh-5W48yVPHW7lUdk4aXOSxk8wM3Q9K7WRAuLTSVXC2mTE_hz4z2GJsr0bjwxZad2s',
  //   'dN7YEhWoTE2gVD-MXsoUUQ:APA91bF6OkSWE7eHrdTUXXHvhZ718fLpGaftkZcLxjpMEiQ-EJR-rMUCPcjjLKqZWnqfRR6k31BImVT2_izaXrAEHq2f2V40AXlMByBcreNrBZhnk89JkQWO0rpFhxuFFKN-4fcudshI',
  //   'cB4zM6eTQZehOQUk-SdDkT:APA91bEW2XnOWEdVQHmnIZApNyoHAqMqJHTd8lsA8nX2XIPzVCQI0lBwNX_iLHngILy8_a41J2kCecydVi5F__IgUSVGbQJ5UML4QXKhoYmrJJJ538iRdr65hDNppwfYATH8gwGKo3o6',
  //   'dYJMhkHdQu-xBmP9FGfxrP:APA91bEmGXBEQvo4cagfDYH4hvzHgvYYEEovZiGyNP27nI1HjQyXUCw2RoC_j8EA09i85ihju1nNItuHluZBvV5eTVpKmAAnmLX86EQIdlzejDm-bu1MpBF7rDNCukllG7A3TvbuoRhV',
  //   'cJaww4NYQ6CA8RKa4eAcg9:APA91bEgF2NMsfbAmUZ3lYnwVT8hd8MsWopWMEIl--LZu1pom3dr4Vf-JktfBvyOhQ0Sb5p7FkNT3WsrAJNex_EHNwTFLwhqeh6KWSCWn4UJTjGI11_ZdXS3n4Rvxh6jzPoUO19TgrMZ'
  // ];
  void boxDelete() {
    box.erase();
    box.remove('token');
  }

  String boxRead() {
    return box.read('token');
  }

  void getToken() async {
    await fcmToken.getToken().then(
      (token) {
        DBSql('tokens').getData('tokens').then((value) {
          if (value.isEmpty) {
            DBSql('tokens').insert({
              'token': token.toString(),
            });
            FirebaseFirestore.instance.collection('tokens').add({
              'token': token.toString(),
            });
          } else {
            // print(value[0]['token']);

            // box.remove('token');
          }
        });
      },
    );

    FirebaseMessaging.onMessage.listen((event) {
      // print(event.notification!.title.toString());
      // Get.snackbar(event.notification!.title.toString(),
      //     event.notification!.body.toString());
      Get.defaultDialog(
          title: event.notification!.title.toString(),
          content: Text(event.notification!.body.toString()),
          onConfirm: () {
            Get.to(() => const InputAlert());
            // Get.back();
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Get.to(() => const InputAlert());
    });
  }

  void sendOrderCollected(String title, body) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('tokens').get();

    querySnapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      http
          .post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': 'key=$serverApi'
              },
              body: jsonEncode({
                'notification': <String, dynamic>{
                  'title': title,
                  'body': body,
                  'sound': 'true'
                },
                'priority': 'high',
                'data': <String, dynamic>{
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'id': '1',
                  'status': 'done'
                },
                'to': data['token']
                // 'dYJMhkHdQu-xBmP9FGfxrP:APA91bEmGXBEQvo4cagfDYH4hvzHgvYYEEovZiGyNP27nI1HjQyXUCw2RoC_j8EA09i85ihju1nNItuHluZBvV5eTVpKmAAnmLX86EQIdlzejDm-bu1MpBF7rDNCukllG7A3TvbuoRhV',

                // await FirebaseMessaging.instance.getToken()
                //
              }))
          .whenComplete(() {})
          .catchError((e) {
        print('sendOrderCollected() error: $e');
      });
    }).toList();
  }

  void requistPermssion() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      // print('User granted provisional permission');
    } else {
      // print('User declined or has not accepted permission');
    }
  }

  Future getPosts() async {
    var res = await http.get(Uri.parse(url));
    print(jsonDecode(res.body));
    return jsonDecode(res.body);
  }
}
