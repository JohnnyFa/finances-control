import 'package:image_picker/image_picker.dart';

class ImageService {
  final _picker = ImagePicker();

  Future<String?> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    return image?.path;
  }
}