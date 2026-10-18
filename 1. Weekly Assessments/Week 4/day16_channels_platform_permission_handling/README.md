# Day 16 – Platform Integration, Permissions & File Handling

## Topics Learned
- Platform channels and native Android/iOS integration basics.
- Handling runtime permissions using `permission_handler`.
- Selecting images from the gallery using `image_picker`.
- Capturing photos using the device camera.
- Displaying selected images using `File` and `FileImage`.
- Handling permission denial, loading states, and errors.
- Organizing Flutter code into `main.dart` and separate screen files.

## Packages & Tools Used
- `image_picker` – Camera and gallery image selection.
- `permission_handler` – Runtime camera permission handling.
- `dart:io` – Working with local files.
- Android Manifest – Declaring camera permission.

## Practical Implementation
Built a Profile Photo screen that allows users to select an image from the gallery or take a photo, preview the image, and handle denied permissions.

**Note:** Actual server-side file uploading with Dio remains to be implemented.
