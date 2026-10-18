# Day 12 - JSON Serialization & Freezed

## What I Did

* Connected the app to the JSONPlaceholder Posts API using Dio.
* Created a `Post` model using Freezed.
* Used `json_serializable` for JSON conversion.
* Used `build_runner` to generate Freezed and JSON files.
* Changed API data from `List<dynamic>` to `List<Post>`.
* Removed direct `Map<String, dynamic>` usage from the UI.

## What I Learned

* JSON Serialization
* Deserialization: JSON → Dart object
* Serialization: Dart object → JSON
* Model classes
* Freezed
* `json_serializable`
* Code generation with `build_runner`
* Typed API data with `List<Post>`

## Generated Files

```text
post.dart
post.freezed.dart
post.g.dart
```

## Issue Faced

The app showed:

```text
The non-abstract class 'Post' is missing implementations
```

The problem was:

```dart
class Post with _$Post
```

### Solution

So i changed it to:

```dart
abstract class Post with _$Post
```

Then regenerated the files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Result

The API data now follows:

```text
API JSON
   ↓
Post.fromJson()
   ↓
List<Post>
   ↓
UI
```

The UI now works with typed `Post` objects instead of raw JSON maps.

