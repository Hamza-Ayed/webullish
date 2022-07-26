import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webullish/db/db.dart';
import 'package:webullish/func/methods.dart';
import 'package:webullish/page/posts.dart';

import 'input_alert.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
    Methods().getToken();
    Methods().requistPermssion();
  }

  dynamic data;
  final box = GetStorage();

  late DocumentSnapshot snapshot;
  final title = TextEditingController();
  final body = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const InputAlert());
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Methods().boxDelete();
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              // print(Methods().boxRead());
              DBSql('tokens').getData('tokens').then((value) => print(value));
            },
            icon: const Icon(Icons.face),
          ),
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                  title: 'Add title of Alert',
                  content: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: title,
                          decoration: const InputDecoration(
                            hintText: 'Enter Title',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            )),
                            // helperText: 'title',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: body,
                          decoration: const InputDecoration(
                            hintText: 'Enter Body of Alert',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            )),
                            // helperText: 'title',
                          ),
                        ),
                      ],
                    ),
                  ),
                  onConfirm: () {
                    Methods().sendOrderCollected(title.text, body.text);
                    Get.back();
                  });

              //
            },
            icon: const Icon(Icons.notification_add),
          ),
          IconButton(
            onPressed: () async {},
            icon: const Icon(Icons.snapchat),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TextButton(
            onPressed: () {
              print(box.read('token'));
            },
            child: const Text(
              "Print from get storage",
            ),
          ),
          TextButton(
            onPressed: () {
              Get.to(() => const Posts());
            },
            child: const Text(
              "Show Post fro wordpress",
            ),
          ),
        ],
      ),
    );
  }
}
