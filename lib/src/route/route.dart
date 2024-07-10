part of '../../fennec.dart';

abstract class ARoute {
  final List<RequestMethod> requestMethods;
  final String path;
  final List<MiddlewareHandler> middlewares;

  ARoute(
      {required this.requestMethods,
      required this.path,
      this.middlewares = const []});
}

class Route extends ARoute {
  final RequestHandler requestHandler;

  Route(
      {required super.requestMethods,
      required super.path,
      required this.requestHandler,
      super.middlewares});
}
