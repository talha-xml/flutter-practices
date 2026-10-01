# Day 13 – Flutter Architecture

A simple Flutter app demonstrating basic application architecture using the **Repository Pattern, API Client, Controller, Dependency Injection, and Feature-Based Architecture concepts**.

## Architecture

```text
UI → Controller → Repository → API Client → API
```

## Concepts

* **Model** – Represents API data.
* **API Client** – Handles HTTP requests using Dio.
* **Repository** – Provides data to the controller.
* **Controller** – Manages state and actions.
* **Dependency Injection** – Provides required dependencies from outside.
* **UI** – Displays posts and handles user interaction.

## API

Uses [JSONPlaceholder](https://jsonplaceholder.typicode.com/) to fetch posts.

## Run

```bash
flutter pub get
flutter run
```

The app loads posts automatically and the refresh button fetches them again. However, you will not notice much change in the UI as it is more of an architecture structure rather than UI but you might see **Loading** in the start when u press the button first time after launching the app.

