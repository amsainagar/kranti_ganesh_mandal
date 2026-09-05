import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kranti_ganesh_mandal/services/gallery_service.dart';

void main() {
  late Directory tempDir;
  final service = GalleryService.instance;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('kgm_gallery');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (methodCall) async => tempDir.path,
    );
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('saveImageFile copies source into gallery directory', () async {
    final source = File('${tempDir.path}/picked.PNG');
    await source.writeAsBytes([1, 2, 3, 4]);

    final savedPath = await service.saveImageFile(XFile(source.path));

    expect(savedPath, contains('/gallery/'));
    expect(savedPath.endsWith('.png'), isTrue);
    expect(await File(savedPath).exists(), isTrue);
    expect(await File(savedPath).readAsBytes(), [1, 2, 3, 4]);
  });

  test('saveImageFile defaults extension when missing', () async {
    final source = File('${tempDir.path}/no-extension');
    await source.writeAsBytes([9]);

    final savedPath = await service.saveImageFile(XFile(source.path));

    expect(savedPath.endsWith('.jpg'), isTrue);
    expect(await File(savedPath).exists(), isTrue);
  });

  test('deleteImageFile removes existing file', () async {
    final source = File('${tempDir.path}/delete-me.jpg');
    await source.writeAsBytes([1]);

    final savedPath = await service.saveImageFile(XFile(source.path));
    expect(await File(savedPath).exists(), isTrue);

    await service.deleteImageFile(savedPath);
    expect(await File(savedPath).exists(), isFalse);
  });

  test('deleteImageFile is safe when file is missing', () async {
    await service.deleteImageFile('${tempDir.path}/missing.jpg');
  });
}
