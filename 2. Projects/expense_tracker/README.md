# SpendWise: Personal Expense Tracker

SpendWise is a simple mobile expense tracking app built with Flutter. It helps users log their daily spending, view their total expenses, convert amounts between currencies using real-time exchange rates, and attach receipt photos to their transactions.

## What Has Been Done So Far

1. **Authentication & Session Persistence (Firebase Auth)**

   - Email and password registration and login.
   - Strong password regex check (at least 8 characters, 1 uppercase, 1 lowercase, 1 number, and 1 special symbol).
   - Email format regex validation.
   - SHA-256 password hashing with a secure 32-byte salt saved into Firestore.
   - Automatic login session persistence (user stays logged in when reopening the app).

2. **Navigation (`go_router`)**

   - Clean route hierarchy connecting all screens:
     - `/auth` ➔ Login & Register screen
     - `/` ➔ Main Expenses Dashboard
     - `/detail/:id` ➔ Expense Details screen
     - `/add` & `/edit/:id` ➔ Add/Edit Expense form
     - `/converter` ➔ Currency Converter screen
   - Route guard that redirects logged-out users to `/auth` and logged-in users to `/`.

3. **State Management (`flutter_riverpod`)**

   - Centralized app state using Riverpod providers.
   - Real-time Firestore stream provider listening for live expense updates.

4. **Expense Management (Cloud Firestore)**

   - Real-time list of all user expenses.
   - Total spending summary banner.
   - Add new expenses (amount, category, description).
   - Edit existing expenses.
   - Delete expenses.

5. **List ➔ Detail Navigation**

   - Tapping any expense opens the details screen displaying the amount, category, date, description, and attached receipt.

6. **Currency Converter (Frankfurter REST API via `dio`)**

   - Real-time exchange rate converter for **PKR**, **USD**, and **GBP**.
   - Makes live network requests to the free European Central Bank rates API (Frankfurter API).

7. **Camera & Photo Selection**

   - Camera permission check using `permission_handler` before launching the camera.
   - Image picker support (`image_picker`) for taking photos or picking from the device gallery.

8. **Unit Tests**
   - Logic tests in `test/password_hasher_test.dart` verifying the salt generator, SHA-256 hash output, and email/password regex validation.

## How to Run the App (Cold Start)

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (version 3.16+ recommended).
- Android Studio or VS Code with Flutter extensions.
- An Android device or emulator with Developer Mode enabled.

### Steps to Run

1. **Clone or open the project folder:**

   ```bash
   cd "expense_tracker"
   ```

2. **Install project dependencies:**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**

   - Make sure your `firebase_options.dart` file is present in the `lib/` folder (generated via FlutterFire CLI: `flutterfire configure`), or place your `google-services.json` in `android/app/`.

4. **Run the test suite:**

   ```bash
   flutter test
   ```

5. **Run the app on your device/emulator:**
   ```bash
   flutter run
   ```

## What is Remaining

According to the capstone requirements, here is what is left to complete:

**Cloudinary Receipt Upload**
**Push Notifications (FCM)**
**Offline Cache Verification**
**Additional Unit & Widget Tests**
**Signed Android Release Build**
