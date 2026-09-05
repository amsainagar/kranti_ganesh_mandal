import 'package:hive_flutter/hive_flutter.dart';
import 'package:kranti_ganesh_mandal/interfaces/local_storage_service.dart';
import 'package:kranti_ganesh_mandal/models/hive_box_names.dart';

export 'package:kranti_ganesh_mandal/models/hive_box_names.dart';

final class HiveService implements LocalStorageService {
  HiveService._();
  static final HiveService instance = HiveService._();

  bool _initialized = false;
  final Set<String> _openedBoxes = {};

  @override
  Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();
    await openBox(HiveBoxNames.settings);

    _initialized = true;
  }

  Future<void> openBox(String name) async {
    if (_openedBoxes.contains(name)) return;
    await Hive.openBox<Map>(name);
    _openedBoxes.add(name);
  }

  Box<Map> box(String name) => Hive.box<Map>(name);

  @override
  Future<void> put(String boxName, String key, Map<String, dynamic> value) async {
    await openBox(boxName);
    await box(boxName).put(key, value);
  }

  @override
  Map<String, dynamic>? get(String boxName, String key) {
    return box(boxName)
        .get(key)
        ?.cast<String, dynamic>();
  }

  @override
  List<Map<String, dynamic>> getAll(String boxName) {
    return box(boxName)
        .values
        .map((e) => e.cast<String, dynamic>())
        .toList();
  }

  @override
  Future<void> delete(String boxName, String key) async {
    await openBox(boxName);
    await box(boxName).delete(key);
  }

  @override
  Future<void> clear(String boxName) async {
    await openBox(boxName);
    await box(boxName).clear();
  }
}
