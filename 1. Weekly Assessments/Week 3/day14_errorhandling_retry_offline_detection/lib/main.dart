import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  final apiClient = ApiClient(Dio());
  final repository = PostRepository(apiClient);
  final controller = PostController(repository);

  runApp(MyApp(controller: controller));
}

class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(id: json['id'], title: json['title'], body: json['body']);
  }
}

abstract class Result {}

class Success extends Result {
  final List<Post> posts;
  Success(this.posts);
}

class Failure extends Result {
  final String message;
  Failure(this.message);
}

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  Future<List<Post>> getPosts() async {
    final response = await dio.get(
      'https://jsonplaceholder.typicode.com/posts',
    );

    return (response.data as List).map((json) => Post.fromJson(json)).toList();
  }
}

class PostRepository {
  final ApiClient apiClient;

  PostRepository(this.apiClient);

  Future<Result> getPosts() async {
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        final posts = await apiClient.getPosts();

        return Success(posts);
      } catch (e) {
        if (attempt == 3) {
          return Failure('Failed to load posts');
        }

        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return Failure('Failed to load posts');
  }
}

class PostController {
  final PostRepository repository;
  final Connectivity connectivity = Connectivity();

  PostController(this.repository);

  List<Post> posts = [];
  bool isLoading = false;
  String? error;

  Future<void> loadPosts() async {
    isLoading = true;
    error = null;

    final connection = await connectivity.checkConnectivity();

    if (connection.contains(ConnectivityResult.none)) {
      error = 'No internet connection';
      isLoading = false;
      return;
    }

    final result = await repository.getPosts();

    if (result is Success) {
      posts = result.posts;
    } else if (result is Failure) {
      error = result.message;
    }

    isLoading = false;
  }
}

class MyApp extends StatefulWidget {
  final PostController controller;

  const MyApp({super.key, required this.controller});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    await widget.controller.loadPosts();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    Widget bodyContent;

    if (controller.isLoading) {
      bodyContent = const Center(child: Text('Loading...'));
    } else if (controller.error != null) {
      bodyContent = Center(child: Text(controller.error!));
    } else {
      bodyContent = ListView.builder(
        itemCount: controller.posts.length,
        itemBuilder: (context, index) {
          final post = controller.posts[index];

          return Padding(
            padding: const EdgeInsets.all(8),
            child: Text('${post.id}. ${post.title}\n${post.body}'),
          );
        },
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Day 14 - Error Handling')),
        body: bodyContent,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: _loadPosts,
            child: const Text('Refresh Posts'),
          ),
        ),
      ),
    );
  }
}
