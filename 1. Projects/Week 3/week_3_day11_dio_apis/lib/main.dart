import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PostsScreen());
  }
}

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<dynamic> posts = [];
  bool isLoading = false;

  Future<void> getPosts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Dio().get(
        'https://jsonplaceholder.typicode.com/posts',
      );

      setState(() {
        posts = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to load posts')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (posts.isEmpty) {
      return Center(
        child: ElevatedButton(
          onPressed: getPosts,
          child: const Text('Get Posts'),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(posts[index]['title']),
            subtitle: Text(posts[index]['body']),
          );
        },
      );
    }
  }
}
