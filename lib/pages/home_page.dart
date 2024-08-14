import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ngdemo12/pages/create_page.dart';

import '../models/post_model.dart';
import '../models/post_res_model.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> items = [];
  bool isLoading = false;

  _apiPostList() async {
    setState(() {
      isLoading = true;
    });

    var response = await Network.GET(Network.API_POST_LIST, Network.paramsEmpty());
    LogService.i(response!);
    List<Post> posts = Network.parsePostList(response);

    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  _apiUpdatePost() async {
    Post post = Post(id: 100, title: "NextGen", body: "Academy", userId: 100);
    var response = await Network.PUT(
        Network.API_POST_UPDATE + post.id.toString(),
        Network.paramsUpdate(post));
    LogService.i(response!);
  }

  _apiDeletePost() async {
    Post post = Post(id: 100, title: "NextGen", body: "Academy", userId: 100);
    var response = await Network.DELETE(
        Network.API_POST_DELETE + post.id.toString(), Network.paramsEmpty());
    LogService.i(response!);
  }

  _callCreatePage() async {
    bool result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return CreatePage();
    }));

    if(result){
      _apiPostList();
    }
  }

  Future<void> _handleRefresh() async {
    _apiPostList();
  }

  @override
  void initState() {
    super.initState();
    _apiPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Posts API"),
      ),
      body: Stack(
        children: [

          RefreshIndicator(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _itemOfPost(items[index], index);
              },
            ),
            onRefresh: _handleRefresh,
          ),

          isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          _callCreatePage();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _itemOfPost(Post post, int index) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title!.toUpperCase(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(post.body!),
        ],
      ),
    );
  }
}
