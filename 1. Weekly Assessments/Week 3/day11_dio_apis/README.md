# Flutter HTTP API Practice

A small Flutter practice project for learning how to consume a public REST API using Dio.

## What This Project Does

The app fetches posts from the JSONPlaceholder API and displays them on the screen.

API used:

`https://jsonplaceholder.typicode.com/posts`

## Concepts Practiced

* Dio HTTP client
* GET request
* REST API
* JSON response
* `async` and `await`
* `Future`
* `setState`
* Loading state
* Error handling with `try` and `catch`
* `ListView.builder`
* Displaying API data
* Using `index` to access list items
* Basic conditional UI with `if` and `else`

## How It Works

1. The user presses the **Get Posts** button.
2. `getPosts()` sends a GET request using Dio.
3. The API returns a JSON response.
4. The response data is stored in the `posts` list.
5. `ListView.builder` displays the posts.
6. `isLoading` shows a loading indicator while the request is running.
7. If the request fails, a SnackBar displays an error message.

## API Data

Each post contains:

* `userId`
* `id`
* `title`
* `body`

The app currently displays the `title` and `body` of each post.

## Package Used

* `dio`

## Purpose

This is a learning/practice project for understanding basic HTTP API integration in Flutter.

