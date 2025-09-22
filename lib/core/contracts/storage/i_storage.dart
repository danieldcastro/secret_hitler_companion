import 'package:secret_hitler_companion/core/objects/enums/storage_key_enum.dart';

abstract class IStorage {
  Future<void> writeData(StorageKeyEnum key, {required Object? value});
  Future<T?> readData<T>(StorageKeyEnum key);
  Future<void> eraseData();
  Future<void> removeKey(StorageKeyEnum key);
}
