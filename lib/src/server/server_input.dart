part of '../../fennec.dart';

class ServerInput {
  final int port;
  final dynamic host;
  final List<ARoute> routes;
  final List<Router> routers;
  CorsOptions? corsOptions;
  SecurityContext? securityContext;
  final List<MiddlewareHandler> middlewares;

  ServerInput(this.port, this.host, this.routers, this.routes, this.middlewares,
      {this.corsOptions, this.securityContext});
}
