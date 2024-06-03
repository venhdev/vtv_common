
/// Map of redirect functions (callback) to navigate between screens
abstract class BaseRedirect<T> {
  BaseRedirect({required this.redirect});

  Map<T, void Function()> redirect;

  void go(T type) => redirect[type]?.call();
}
