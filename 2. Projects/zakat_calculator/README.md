# Zakat Calculator

A Flutter-based Zakat Calculator that helps users calculate their Zakat based on their assets and the applicable Zakat rules.

I am building this project as a practical Flutter project to improve my understanding of app development, authentication, local data storage, form validation, navigation, and separating application logic from the UI.

The app is being developed incrementally, so some features are still under development.

## Why I Am Creating This

I wanted to build a real-world Flutter application instead of only working on small practice examples.

This project allows me to learn how different Flutter concepts work together in one application, including:

* User registration and login
* Secure password handling
* Form validation
* Navigation
* Local storage
* Zakat calculation logic
* Saving calculation history
* User-specific data

## Features Built So Far

### Authentication

* User registration screen
* User login screen
* Name and email validation
* Email format validation using a regular expression
* Password validation
* Password confirmation during registration
* Password hashing with a random salt
* Secure storage using `flutter_secure_storage`
* Login verification through `AuthService`
* Successful login navigates to the Asset Entry screen

### Asset Entry

* Created the Asset Entry screen
* Added initial cash input
* Added basic empty-field validation
* Cash will be handled in PKR as the app's fixed currency

## Future Improvements

The project is still in development. The next features I plan to add are:

* Add bank balance and other cash assets
* Add gold and silver inputs
* Add gold and silver weight calculations
* Add receivables and investments
* Add debt deduction
* Implement Zakat calculation logic
* Add Nisab calculation
* Add different jewellery calculation rules
* Show a detailed Zakat result and breakdown
* Save previous calculations
* Add Zakat calculation history
* Add settings
* Improve user/session protection
* Support separate data for different users
* Add unit tests for the calculation logic
* Improve password hashing to a stronger password-based hashing approach

## Technologies

* Flutter
* Dart
* `flutter_secure_storage`
* `shared_preferences`
* `crypto`

## Project Status

**In Development**

The application is being built step by step while learning and applying Flutter concepts in a real project.

