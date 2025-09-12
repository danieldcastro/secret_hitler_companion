class AppRoutes {
  AppRoutes._();

  static const initial = '/';
  static const root = '/root';
  static const roster = '/roster';
}

class NestedRoutes {
  NestedRoutes._();

  static const _root = AppRoutes.root;
  static const roster = '$_root${AppRoutes.roster}/';
}
