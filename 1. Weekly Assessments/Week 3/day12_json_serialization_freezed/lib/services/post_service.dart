import 'package:dio/dio.dart';

import '../models/post.dart';

class PostService {
  final Dio dio = Dio();

  Future<List<Post>> getPosts() async {
    final response = await dio.get(
      'https://jsonplaceholder.typicode.com/posts',
    );
    final List<dynamic> data = response.data;
    return data.map((json) => Post.fromJson(json)).toList();
  }
}
