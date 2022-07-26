import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class InputAlert extends StatefulWidget {
  const InputAlert({Key? key}) : super(key: key);

  @override
  State<InputAlert> createState() => _InputAlertState();
}

class _InputAlertState extends State<InputAlert> {
  List token = [];
  Future getTokens() async {}
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('tokens').snapshots();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    // CollectionReference users = FirebaseFirestore.instance.collection('tokens');

    return Scaffold(
        body: Center(
            child: StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            box.write('token', data['token']);

            return ListTile(
              title: Text(data['token']),
              // subtitle: Text(data['company']),
            );
          }).toList(),
        );
      },
    )));
  }
}
