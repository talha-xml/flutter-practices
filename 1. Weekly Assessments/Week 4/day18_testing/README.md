# Day 18 — Flutter Testing

## Topic

Unit Testing, Repository Testing, Widget Testing, Mocktail, Golden Testing, and Test Coverage.

## What I Learned

- **Unit Testing:** Tests individual functions and business logic.
- **Repository Testing:** Verifies data retrieval and error handling.
- **Mocktail:** Creates mock dependencies to test without a real API.
- **Widget Testing:** Checks UI elements and user interactions.
- **Golden Testing:** Compares the rendered UI against a reference image.
- **Test Coverage:** Measures how much of the code is executed during tests, targeting at least 60% coverage for the data and logic layers.

## Project Files

### Application Code — `lib/`

- **`product.dart`:** Defines the Product model and discount calculation; tested using unit tests.
- **`product_repository.dart`:** Defines the data-source contract and repository; tested using Mocktail to simulate successful responses and failures.
- **`product_screen.dart`:** Displays products and applies discounts; tested for UI elements and button interactions.

### Test Code — `test/`

- **`product_test.dart`:** Tests discount calculations with different percentages using `test()` and `expect()`.
- **`product_repository_test.dart`:** Tests repository responses, error propagation, and method calls using Mocktail.
- **`product_screen_test.dart`:** Tests product display and discount-button behavior using `testWidgets()`.
- **`product_screen_golden_test.dart`:** Compares the product screen against a saved reference image.
- **`goldens/product_screen.png`:** Stores the reference image used by the golden test.

## Commands

```bash
# Run all tests
flutter test

# Generate/update golden reference images
flutter test --update-goldens test/product_screen_golden_test.dart

# Generate test coverage
flutter test --coverage
```
