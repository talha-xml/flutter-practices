import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePhotoScreen extends StatefulWidget {
  const ProfilePhotoScreen({super.key});

  @override
  State<ProfilePhotoScreen> createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _profilePhoto;
  bool _isPicking = false;

  Future<void> _pickPhoto(ImageSource source) async {
    if (_isPicking) return;

    setState(() {
      _isPicking = true;
    });

    try {
      if (source == ImageSource.camera) {
        var status = await Permission.camera.status;
        if (!status.isGranted) {
          status = await Permission.camera.request();
        }

        if (!mounted) return;
        if (!status.isGranted) {
          if (status.isPermanentlyDenied) {
            await _showPermissionSettingsDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Camera permission denied. '
                  'You can choose a photo from the gallery.',
                ),
              ),
            );
          }

          return;
        }
      }

      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (!mounted || image == null) return;

      setState(() {
        _profilePhoto = File(image.path);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile photo selected!')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not select the photo. Try again.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  Future<void> _showPermissionSettingsDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Camera permission required'),
        content: const Text(
          'Allow camera access in app settings, '
          'or choose a photo from the gallery.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Photo')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 65,
              backgroundImage: _profilePhoto != null
                  ? FileImage(_profilePhoto!)
                  : null,
              child: _profilePhoto == null
                  ? const Icon(Icons.person, size: 65)
                  : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isPicking
                  ? null
                  : () => _pickPhoto(ImageSource.gallery),
              child: const Text('Choose from Gallery'),
            ),
            ElevatedButton(
              onPressed: _isPicking
                  ? null
                  : () => _pickPhoto(ImageSource.camera),
              child: const Text('Take Photo'),
            ),
            if (_isPicking)
              const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
