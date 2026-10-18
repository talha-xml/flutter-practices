# Day 15 — Local Persistence & Offline Storage

A simple Flutter app that demonstrates **local data persistence** using Hive.

The app allows the user to enter their **name, email, and a note**, save the details locally, and retrieve them later—even after closing and restarting the app or disconnecting from the internet.

## What I Learned

* Local persistence in Flutter
* Storing data directly on the device
* Using Hive for local storage
* Saving and retrieving data using key-value pairs
* Handling empty input fields
* Understanding offline/local data access
* Keeping data available after restarting the app

## Packages Used

### Hive

`hive_ce` is used as the local storage database.

It allows the app to store data directly on the device without requiring an internet connection or an external database server.

### Hive Flutter

`hive_ce_flutter` is used to initialize Hive inside a Flutter application.

## How It Works

```text
User enters Name + Email + Note
              ↓
           Submit
              ↓
       Validate fields
              ↓
          Save to Hive
              ↓
       Data stored locally
              ↓
      App can be closed/restarted
              ↓
          Retrieve
              ↓
      Data loaded from Hive
```

## Local Storage

The app opens a Hive box called `details`:

```dart
await Hive.openBox('details');
```

Data is saved using keys:

```dart
box.put('name', name);
box.put('email', email);
box.put('note', note);
```

Data is retrieved using the same keys:

```dart
box.get('name');
box.get('email');
box.get('note');
```

## Validation

Before saving, the app checks whether all fields contain data.

If any field is empty:

```text
Please fill all fields.
```

If everything is entered:

```text
Details have been submitted.
```

## Offline Support

The app does not depend on an internet connection for retrieving saved details.

The data is stored locally on the device, so it remains available when:

* Internet is disconnected
* The app is closed
* The app is restarted

## Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive_ce: ^2.11.3
  hive_ce_flutter: ^2.3.1
```

## Key Concept

The main idea learned in this project is:

> **Local persistence allows an application to save data on the device and retrieve it later without depending on the internet.**

This is the foundation for implementing **offline caching** in Flutter applications.

