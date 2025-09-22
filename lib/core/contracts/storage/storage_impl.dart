import 'package:secret_hitler_companion/core/contracts/storage/i_storage.dart';
import 'package:secret_hitler_companion/core/objects/enums/storage_key_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageImpl implements IStorage {
  final _storage = SharedPreferencesAsync();

  Type _getType(Object? value) => value.runtimeType;

  Future<void> _write(StorageKeyEnum key, Object? value) {
    final type = _getType(value);

    if (type == String) {
      return _storage.setString(key.name, value as String);
    } else if (type == int) {
      return _storage.setInt(key.name, value as int);
    } else if (type == double) {
      return _storage.setDouble(key.name, value as double);
    } else if (type == bool) {
      return _storage.setBool(key.name, value as bool);
    } else if (type == List<String>) {
      return _storage.setStringList(key.name, value as List<String>);
    } else {
      throw Exception('Unsupported type: $type');
    }
  }

  Future<T?> _read<T>(StorageKeyEnum key) async {
    final value = await _storage.getAll();

    return value[key.name] as T?;
  }

  @override
  Future<void> writeData(StorageKeyEnum key, {required Object? value}) async {
    await _write(key, value);
  }

  @override
  Future<T?> readData<T>(StorageKeyEnum key) async => _read<T>(key);

  @override
  Future<void> eraseData() async {
    await _storage.clear();
  }

  @override
  Future<void> removeKey(StorageKeyEnum key) async {
    await _storage.remove(key.name);
  }
}
