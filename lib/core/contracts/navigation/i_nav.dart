abstract class INav {
  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  });
  Future<T?> pushReplacementNamed<T extends Object?, R extends Object?>(
    String routeName, {
    R? result,
    Object? arguments,
  });
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String routeName, {
    Object? arguments,
  });
  void pop<T extends Object?>([T? result]);
  void popUntil(String routeName, {Object? arguments});
  Future<T?> popAndPushNamed<T extends Object?, R extends Object?>(
    String routeName, {
    R? result,
    Object? arguments,
  });
  void navigate(String routeName, {Object? arguments});
  String get currentRoute;
}
