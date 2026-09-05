abstract interface class LocalStorageService {
  Future<void> init();

  Future<void> put(String boxName, String key, Map<String, dynamic> value);

  Map<String, dynamic>? get(String boxName, String key);

  List<Map<String, dynamic>> getAll(String boxName);

  Future<void> delete(String boxName, String key);

  Future<void> clear(String boxName);
}
