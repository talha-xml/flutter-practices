# Day 14 — Error Handling & Offline Detection

## What I Learned

In Day 14, I learned how to handle API errors and internet problems.

### Main Topics

* **Exception:** An error that happens while the app is running.
* **try/catch:** Used to catch and handle errors.
* **Result:** Shows whether an operation was successful or failed.
* **Success:** Contains the requested data.
* **Failure:** Contains an error message.
* **Retry:** Tries the API request again if it fails.
* **Offline Detection:** Checks if the device has an internet connection.

## How It Works

```text
App starts
   ↓
Controller
   ↓
Check internet
   ↓
Online?
 ┌──────┴──────┐
No            Yes
 ↓              ↓
Error        Repository
                ↓
             API request
                ↓
          Success / Failure
                ↓
              Retry
                ↓
                UI
```

If the request succeeds, posts are shown.

If it fails, the app retries up to 3 times.

If there is no internet, the app shows:

```text
No internet connection
```

## Architecture

```text
UI
 ↓
Controller
 ↓
Repository
 ↓
API Client
 ↓
API
```

Day 14 is simply **error handling, retry, Result, and offline detection** to the Day 13 architecture.

