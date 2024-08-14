import 'package:flutter/material.dart';
import 'package:ngdemo12/models/post_model.dart';

import '../models/post_res_model.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  bool isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  _createPost() {
    String title = _titleController.text.toString().trim();
    String body = _bodyController.text.toString().trim();
    Post post = Post(userId: 1, title: title, body: body);

    _apiCreatePost(post);
  }

  _apiCreatePost(Post post) async {

    setState(() {
      isLoading = true;
    });

    var response = await Network.POST(Network.API_POST_CREATE, Network.paramsCreate(post));
    LogService.i(response!);
    PostRes postRes = Network.parsePostRes(response!);

    setState(() {
      isLoading = false;
    });

    backToFinish();
  }

  backToFinish() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Create Post"),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Stack(
            children: [
              Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: "Title"),
                  ),
                  TextField(
                    controller: _bodyController,
                    decoration: InputDecoration(hintText: "Body"),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    child: MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        _createPost();
                      },
                      child: Text("Save Post"),
                    ),
                  ),
                ],
              ),

              isLoading ? Center(
                child: CircularProgressIndicator(),
              ): SizedBox.shrink(),
            ]
        ),
      ),
    );
  }
}
