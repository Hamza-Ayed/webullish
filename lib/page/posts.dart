import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:webullish/func/methods.dart';

class Posts extends StatefulWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  List list = [];
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    Methods().getPosts().then((value) {
      setState(() {
        list = value;
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Posts Page'),
        ),
        body: Center(
          child: isloading
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    var res = list[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        res['title']['rendered'],
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
        ));
  }
}
