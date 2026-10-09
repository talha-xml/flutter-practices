# Zakat Calculator

A Flutter-based Android application that calculates monetary Zakat based on a user's assets, eligible liabilities, and selected Nisab standard. The project demonstrates Flutter application development, local authentication, form validation, state management through navigation, local data persistence, and testable calculation logic.

## Features

### Authentication

- User registration and login.
- Name, email, and password validation.
- Password hashing with a randomly generated salt.
- Password credentials stored using `flutter_secure_storage`.
- Login session persistence across app restarts.
- Separate user accounts and user-specific calculation history.
- Logout functionality.

### Asset Entry and Zakat Calculation

- Inputs for cash, bank balance, investments, business inventory, receivables, and debts.
- Gold and silver valuation using user-entered weights, purity, and prices.
- Configurable gold or silver Nisab standard.
- Madhhab settings for applicable jewellery rules.
- Optional inclusion of doubtful receivables.
- Debt deduction with net wealth prevented from becoming negative.
- Detailed result breakdown showing gross wealth, deducted debt, net wealth, Nisab standard, Nisab threshold, and Zakat due.
- Zakat calculated at 2.5% when the net eligible wealth meets the selected Nisab threshold.
- Blank optional asset fields and zero-value inputs supported.

### History and Settings

- Save and view previous Zakat calculations locally.
- Keep calculation history separated by user.
- Configure madhhab, Nisab standard, and doubtful receivable treatment.
- Reopen saved calculation results.

## Technology Stack

- **Flutter and Dart** — Android application development.
- **Hive** — local user records and calculation history.
- **shared_preferences** — lightweight preferences and login session data.
- **flutter_secure_storage** — storage of password salts and password hashes.
- **crypto** — password hashing.
- **decimal** — precise monetary calculations.
- **uuid** — unique user identifiers.

## Target Platform

- Android

## Requirements

- Flutter SDK installed and configured.
- Dart SDK compatible with the Flutter SDK.
- Android Studio or another configured Android development environment, with an Android emulator or connected Android device.

## How to Run

1. Clone or download this repository.
2. Open a terminal in the project directory.
3. Install the dependencies:

   ```bash
   flutter pub get
   ```

4. Connect an Android device or start an Android emulator.
5. Run the application:

   ```bash
   flutter run
   ```

## How to Run Tests

Run the automated tests from the project root:

```bash
flutter test
```

The calculation tests are located in `test/zakat_calculator_test.dart`. They cover the required calculation scenarios, including Nisab thresholds, gold purity, debts, receivables, jewellery rules, business inventory, and empty or zero-value inputs.

## Local Storage Choices

The application uses different local-storage solutions for different purposes:

- **Hive:** Stores user records and Zakat calculation history as structured local data. It supports multiple records without treating a collection of historical calculations as one large preference value.
- **shared_preferences:** Stores lightweight settings and the ID of the currently logged-in user. It is suitable for small key-value preferences, not for the complete calculation history.
- **flutter_secure_storage:** Stores password salts and password hashes using platform-provided secure storage mechanisms where supported. Passwords are not stored as plain text.

All application data is intended to remain on the device. The application does not require a remote database or backend API.

## Calculation and Rounding Rules

- Zakat is calculated at **2.5%** of eligible net wealth when it meets or exceeds the selected Nisab threshold.
- The Nisab standard can be set to silver (612.36 grams) or gold (87.48 grams). Their values are calculated using the prices entered by the user.
- Gold valuation accounts for karat purity. The calculator also applies the configured madhhab rules for personal jewellery and the setting for doubtful receivables.
- Eligible debts are deducted from gross wealth, and net wealth cannot be negative.
- Monetary calculations use the `decimal` package instead of binary floating-point arithmetic.
- Intermediate monetary calculations are not rounded. The final Zakat amount is rounded to **two decimal places using half-up rounding**.

The application assumes that the required hawl (lunar-year holding period) condition has been met. It does not track the holding period or fetch live gold and silver prices.

## Limitations and Incomplete Requirements

- The application is designed for local, single-device use. It does not provide cloud synchronization, remote backups, or cross-device account access.
- Password hashing currently uses salted SHA-256. A dedicated password-based hashing algorithm such as PBKDF2 or bcrypt would provide stronger resistance to offline password guessing.
- Gold and silver prices must be entered by the user; live market prices are not fetched.
- Hawl tracking is not implemented; the calculation assumes its condition has been met.
- The application covers monetary Zakat only. Livestock, agricultural produce (ushr), buried treasure (rikaz), and Zakat al-Fitr are outside its scope.
- The calculation implements the rules specified for this assignment and should not be treated as a substitute for advice from a qualified Islamic scholar in unusual or disputed cases.

## Local Authentication: Security Limitations

Authentication is performed locally, without a remote authentication server. Password salts and hashes are stored through `flutter_secure_storage`, but salted SHA-256 is a fast hashing algorithm and is less resistant to offline password guessing than purpose-built password-hashing algorithms such as PBKDF2 or bcrypt. Local authentication cannot independently protect the application against every form of device compromise, rooted-device access, or malicious access to application data. Because there is no backend, the application cannot provide server-side identity verification, account recovery, or cross-device authentication.

## Project Status

The core assignment features have been implemented, including registration and login, asset entry, Zakat calculation, settings, local calculation history, and calculation unit tests. Remaining limitations are documented above.
