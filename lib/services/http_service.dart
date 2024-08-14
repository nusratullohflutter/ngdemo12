import 'dart:convert';

import 'package:http/http.dart';
import 'package:ngdemo12/models/post_model.dart';

import '../models/post_res_model.dart';

class Network {
  static bool isTester = true;
  static String SERVER_DEV = "jsonplaceholder.typicode.com";
  static String SERVER_PROD = "jsonplaceholder.typicode.com";

  static String getServer() {
    if (isTester) return SERVER_DEV;
    return SERVER_PROD;
  }

  static Map<String, String> headers = {
    'Content-type': 'application/json; charset=UTF-8'
  };

  /* Http Requests */

  static Future<String?> GET(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params);
    var response = await get(uri, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  static Future<String?> POST(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api);
    var response = await post(uri, body: jsonEncode(params), headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  static Future<String?> PUT(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params);
    var response = await put(uri, body: jsonEncode(params), headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  static Future<String?> DELETE(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params);
    var response = await delete(uri, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

/*Http Apis*/
  static String API_POST_LIST = "/posts";
  static String API_POST_CREATE = "/posts";
  static String API_POST_UPDATE = "/posts/"; //{id}
  static String API_POST_DELETE = "/posts/"; //{id}

/*Http Params*/

  static Map<String, String> paramsEmpty() {
    Map<String, String> params = Map();
    return params;
  }

  static Map<String, String> paramsCreate(Post post) {
    Map<String, String> params = {};
    params.addAll({
      'title': post.title!,
      'body': post.body!,
      'userId': post.userId.toString(),
    });
    return params;
  }

  static Map<String, String> paramsUpdate(Post post) {
    Map<String, String> params = {};
    params.addAll({
      'id': post.id.toString(),
      'title': post.title!,
      'body': post.body!,
      'userId': post.userId.toString(),
    });
    return params;
  }

/*Http Parsing*/

  static List<Post> parsePostList(String response) {
    dynamic json = jsonDecode(response);
    List<Post> posts = List<Post>.from(json.map((x) => Post.fromJson(x)));
    return posts;
  }

  static Post parsePost(String response) {
    dynamic json = jsonDecode(response);
    Post post = Post.fromJson(json);
    return post;
  }

  static PostRes parsePostRes(String response) {
    dynamic json = jsonDecode(response);
    PostRes post = PostRes.fromJson(json);
    return post;
  }
}
