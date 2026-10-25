# SpendWise: Personal Expense Tracker

SpendWise is a simple mobile expense tracking app built with Flutter. It helps users log their daily spending, view their total expenses, convert amounts between currencies using real-time exchange rates, and attach receipt photos to their transactions.

---

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
   - Real-time Firestore stream providers for both the expense list and individual expense details.

4. **Budget & Expense Management (Cloud Firestore)**
   - Enter and persist a total spending budget (e.g., PKR 30,000) stored in Firestore under the user profile.
   - Automatic deduction: any uploaded expense is subtracted in real time from the total budget, displaying the exact remaining balance.
   - Over-budget warning if total spending exceeds the set budget.
   - Option to edit/update the budget anytime from the dashboard.
   - Real-time list of all user expenses on the main dashboard.
   - Add new expenses (amount, category, description).
   - Edit existing expenses with instant real-time sync.
   - Delete expenses with a confirmation warning dialog to prevent accidental data loss.

5. **List ➔ Detail Navigation**
   - Tapping any expense opens the details screen displaying the amount, category, date, description, and attached receipt photo.

6. **Cloudinary Receipt Hosting (`dio` + `flutter_dotenv`)**
   - Unsigned multipart photo upload to Cloudinary using `dio`.
   - Credentials safely stored in an untracked `.env` file (`CLOUDINARY_CLOUD_NAME` and `CLOUDINARY_UPLOAD_PRESET`) kept out of source control.
   - Automatic Firestore linkage: stores the hosted receipt `secure_url` with the expense document.
   - Full support for adding, updating, or replacing receipts on both new and existing expenses.

7. **Currency Converter (Frankfurter REST API via `dio`)**
   - Real-time exchange rate converter for **PKR**, **USD**, and **GBP**.
   - Makes live network requests to the free European Central Bank rates API (Frankfurter API).

8. **Camera & Photo Selection**
   - Camera permission check using `permission_handler` before launching the camera.
   - Image picker support (`image_picker`) for taking photos or picking from the device gallery.

9. **Push Notifications & 50% Budget Alert (`firebase_messaging` + `flutter_local_notifications`)**
   - Separate `lib/notifications/` module managing FCM permissions, token synchronization to Firestore, and high-priority notification channels.
   - Real-time budget threshold evaluation: automatically triggers a floating heads-up pop-up alert when spending crosses 50% of the allocated budget (e.g., spent 500 out of 1000) indicating the remaining balance.
   - Background push notification handler registered for remote FCM messages.

10. **Unit Tests**
   - Logic tests in `test/password_hasher_test.dart` verifying the salt generator, SHA-256 hash output, and email/password regex validation.

---

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

3. **Configure Environment Variables (`.env`):**
   Create a `.env` file in the project root directory and add your Cloudinary credentials:
   ```env
   CLOUDINARY_CLOUD_NAME=your_cloud_name_here
   CLOUDINARY_UPLOAD_PRESET=your_unsigned_preset_here
   ```

4. **Configure Firebase:**
   - Make sure your `firebase_options.dart` file is present in the `lib/` folder (generated via FlutterFire CLI: `flutterfire configure`), or place your `google-services.json` in `android/app/`.

5. **Run the test suite:**
   ```bash
   flutter test
   ```

6. **Run the app on your device/emulator:**
   ```bash
   flutter run
   ```

---

## What is Remaining

According to the capstone requirements, here is what is left to complete:

- [ ] **Offline Cache Verification**: Explicitly verify/configure offline caching for expenses or currency rates when no internet is available.
- [ ] **Additional Unit & Widget Tests**: Add widget tests for the forms and model serialization tests for `Expense`.
- [ ] **Signed Android Release Build**: Create a release keystore, configure `key.properties` and `build.gradle`, and generate a signed Android App Bundle (`flutter build appbundle`) for the Google Play Console internal test track.
