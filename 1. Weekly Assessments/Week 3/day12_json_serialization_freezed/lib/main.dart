import 'package:flutter/material.dart';

import 'models/post.dart';
import 'services/post_service.dart';

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
  final PostService postService = PostService();

  List<Post> posts = [];
  bool isLoading = false;

  Future<void> getPosts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await postService.getPosts();

      setState(() {
        posts = result;
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
          final Post post = posts[index];

          return ListTile(title: Text(post.title), subtitle: Text(post.body));
        },
      );
    }
  }
}
