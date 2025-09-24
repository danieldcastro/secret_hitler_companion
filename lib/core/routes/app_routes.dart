class AppRoutes {
  AppRoutes._();

  static const initial = '/';
  static const root = '/root';
  static const roster = '/roster';
  static const quantity = '/quantity';
  static const role = '/role';
}

class NestedRoutes {
  NestedRoutes._();

  static const _root = AppRoutes.root;
  static const roster = '$_root${AppRoutes.roster}/';
  static const quantity = '$_root${AppRoutes.quantity}/';
  static const role = '$_root${AppRoutes.role}/';
}
