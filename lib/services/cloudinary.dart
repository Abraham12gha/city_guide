import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {

  static const cloudName = 'dfaoqq0mj';
  static const uploadPreset = 'city_guide_upload';

  Future<String?> uploadImage(File imageFile) async {

    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest(
      'POST',
      uri,
    );

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200) {

      final responseData =
      jsonDecode(await response.stream.bytesToString());

      return responseData['secure_url'];

    }

    return null;
  }
}