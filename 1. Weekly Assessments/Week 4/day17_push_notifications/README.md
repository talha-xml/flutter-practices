# Day 17 — Push Notifications & Deep Links

## What I Learned

- Integrated Firebase Cloud Messaging (FCM) into my Flutter app.
- Requested notification permissions and received push notifications on my Android device.
- Used local notifications to display notifications while the app was open.
- Learned how to handle notification taps when the app is in the background or terminated.
- Used custom key-value data to navigate to a specific screen using Flutter's `Navigator`.

## Problem I Faced

My notifications were working, but tapping them only opened the main screen instead of the Details screen.

## How I Fixed It

I added custom data in the Firebase Console under **Additional options**:

- **Key:** `screen`
- **Value:** `details`

My Flutter code checks this data when a notification is tapped and opens the Details screen accordingly.

## What I Achieved

I successfully sent real push notifications from Firebase to my Android device and made notification taps open the correct screen.

**Today's takeaway:** Sending a notification is only half the job. Custom data helps my app decide what to do when the user taps it.
