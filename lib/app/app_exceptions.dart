/// Application specific exceptions not related to services.

/// Navigator couldn't find requested route.
class NoRouteException implements Exception {
  const NoRouteException(this.message);
  final String message;
}
