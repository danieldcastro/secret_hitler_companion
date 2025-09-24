import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/core/contracts/navigation/i_nav.dart';
import 'package:secret_hitler_companion/core/contracts/navigation/nav_impl.dart';
import 'package:secret_hitler_companion/core/contracts/storage/i_storage.dart';
import 'package:secret_hitler_companion/core/contracts/storage/storage_impl.dart';
import 'package:secret_hitler_companion/core/utils/stores/voter_store.dart';

class CoreBinds extends Module {
  @override
  void exportedBinds(Injector i) {
    i
      ..addSingleton<INav>(NavImpl.new)
      ..addSingleton<IStorage>(StorageImpl.new)
      ..addSingleton(VoterStore.new);
    super.exportedBinds(i);
  }
}
