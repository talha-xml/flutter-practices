import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryConfig {
  // Replace these with your actual Cloudinary credentials
  static String cloudName = 'demo'; // Replace with your Cloudinary cloud name
  static String uploadPreset = 'spendwise_preset'; // Replace with your unsigned upload preset
}

class CloudinaryService {
  final Dio _dio;

  CloudinaryService({Dio? dio}) : _dio = dio ?? Dio();

  /// Uploads an image file to Cloudinary using an unsigned upload preset.
  /// Returns the secure URL of the hosted image.
  Future<String> uploadImage(XFile imageFile) async {
    final cloudName = CloudinaryConfig.cloudName;
    final uploadPreset = CloudinaryConfig.uploadPreset;

    if (cloudName.isEmpty || cloudName == 'YOUR_CLOUD_NAME') {
      throw Exception('Cloudinary Cloud Name is not configured in CloudinaryConfig.');
    }

    final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    final bytes = await imageFile.readAsBytes();
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: imageFile.name),
      'upload_preset': uploadPreset,
    });

    final response = await _dio.post(
      url,
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final secureUrl = response.data['secure_url'] as String?;
      if (secureUrl != null && secureUrl.isNotEmpty) {
        return secureUrl;
      }
    }

    throw Exception('Failed to upload image to Cloudinary: ${response.statusMessage}');
  }
}

