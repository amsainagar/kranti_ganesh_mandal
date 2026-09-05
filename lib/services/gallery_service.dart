import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final class GalleryService {
  GalleryService._();
  static final GalleryService instance = GalleryService._();

  final _picker = ImagePicker();
  final _uuid = const Uuid();

  Future<XFile?> pickImage() {
    return _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
  }

  Future<String> saveImageFile(XFile picked) async {
    final galleryDir = await _galleryDirectory();
    final extension = _fileExtension(picked.path);
    final fileName = '${_uuid.v4()}.$extension';
    final destination = File('${galleryDir.path}/$fileName');
    await File(picked.path).copy(destination.path);
    return destination.path;
  }

  Future<void> deleteImageFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<Directory> _galleryDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final galleryDir = Directory('${appDir.path}/gallery');
    if (!await galleryDir.exists()) {
      await galleryDir.create(recursive: true);
    }
    return galleryDir;
  }

  String _fileExtension(String path) {
    final dotIndex = path.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == path.length - 1) {
      return 'jpg';
    }
    return path.substring(dotIndex + 1).toLowerCase();
  }
}
