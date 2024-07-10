part of '../fennec.dart';

/// [Application] is a class that contains the application.
class Application {
  CorsOptions? corsOptions;
  final List<MiddlewareHandler> middlewares = [];

  /// instance of [Application] that contains the application.
  static final Application _instance = Application._internal();
  final List<IsolateSupervisor> _supervisors = [];
  final List<Actor> _actors = [];

  /// [Application] is a constructor that creates a new [Application] object.
  factory Application() {
    return _instance;
  }

  Application._internal();

  ///[host] represents host of the server
  dynamic host = '0.0.0.0';

  ///[port] represents port of the server
  int port = 8000;

  ///[securityContext] represents if you bind your server secure
  SecurityContext? securityContext;

  /// [numberOfIsolates] is a [int] that contains the number of isolates of the application.
  int numberOfIsolates = 1;

  final List<Router> routers = [];
  final List<ARoute> routes = [];

  /// [addRouter] is a method that adds a new Router to the application.
  /// [router] is a [Router] that contains the router.
  Application addRouter(Router router) {
    routers.add(router);
    return this;
  }

  /// [addRouters] is a method that adds a List Router to the application.
  /// [routers] is a List Router that contains the router.
  Application addRouters(List<Router> routers) {
    this.routers.addAll(routers);
    return this;
  }

  /// [addRoute] is a method that adds a new Route to the application.
  /// [route] is a [Route] that contains the route.
  Application addRoute(ARoute route) {
    routes.add(route);
    return this;
  }

  /// [addRoutes] is a method that adds a a List of Route to the application.
  Application addRoutes(List<ARoute> routes) {
    this.routes.addAll(routes);
    return this;
  }

  /// [setHost] is a method that sets the host of server of the application.
  /// by default it's set to '0.0.0.0'.
  Application setHost(dynamic host) {
    this.host = host;
    return this;
  }

  Application addActor(Actor actor) {
    _actors.add(actor);
    return this;
  }

  Application addActors(List<Actor> actors) {
    _actors.addAll(actors);
    return this;
  }

  /// [setPort] is a method that sets the port of server of the application.
  /// by default it's set to 8000.
  Application setPort(int port) {
    this.port = port;
    return this;
  }

  /// [setSecurityContext] is a method that sets the SecurityContext of server of the application.
  /// by default it's set to null.
  Application setSecurityContext(SecurityContext securityContext) {
    this.securityContext = securityContext;
    return this;
  }

  /// [setNumberOfIsolates] is a method that sets the number of isolates of the application.
  /// by default it's set to 1.
  Application setNumberOfIsolates(int numberOfIsolates) {
    this.numberOfIsolates = numberOfIsolates;
    return this;
  }

  ///[setCorsOptions] is used to add Cors to the response header
  Application setCorsOptions(CorsOptions corsOptions) {
    this.corsOptions = corsOptions;
    return this;
  }

  /// [useMiddleware] is used to defines middlewares, that will be executed after every request.
  Application useMiddleware(MiddlewareHandler middlewareHandler) {
    middlewares.add(middlewareHandler);
    return this;
  }

  Application post(
      {required String path,
      required RequestHandler requestHandler,
      List<MiddlewareHandler> middlewares = const []}) {
    addRoute(Route(
        requestMethods: [RequestMethod.post()],
        path: path,
        requestHandler: requestHandler,
        middlewares: middlewares));
    return this;
  }

  Application get(
      {required String path,
      required RequestHandler requestHandler,
      List<MiddlewareHandler> middlewares = const []}) {
    addRoute(Route(
        requestMethods: [RequestMethod.get()],
        path: path,
        requestHandler: requestHandler,
        middlewares: middlewares));
    return this;
  }

  Application delete(
      {required String path,
      required RequestHandler requestHandler,
      List<MiddlewareHandler> middlewares = const []}) {
    addRoute(Route(
        requestMethods: [RequestMethod.delete()],
        path: path,
        requestHandler: requestHandler,
        middlewares: middlewares));
    return this;
  }

  Application put(
      {required String path,
      required RequestHandler requestHandler,
      List<MiddlewareHandler> middlewares = const []}) {
    addRoute(Route(
        requestMethods: [RequestMethod.put()],
        path: path,
        requestHandler: requestHandler,
        middlewares: middlewares));
    return this;
  }

  Application options(
      {required String path,
      required RequestHandler requestHandler,
      List<MiddlewareHandler> middlewares = const []}) {
    addRoute(Route(
        requestMethods: [RequestMethod.options()],
        path: path,
        requestHandler: requestHandler,
        middlewares: middlewares));
    return this;
  }

  Application patch(
      {required String path,
      required RequestHandler requestHandler,
      List<MiddlewareHandler> middlewares = const []}) {
    addRoute(Route(
        requestMethods: [RequestMethod.patch()],
        path: path,
        requestHandler: requestHandler,
        middlewares: middlewares));
    return this;
  }

  Application any(
      {List<RequestMethod> requestMethods = const [RequestMethod.all()],
      required String path,
      required RequestHandler requestHandler,
      List<MiddlewareHandler> middlewares = const []}) {
    addRoute(Route(
        requestMethods: requestMethods,
        path: path,
        requestHandler: requestHandler,
        middlewares: middlewares));
    return this;
  }

  Future<ServerInfo> runServer() async {
    Actors actors = Actors(_actors);

    await actors.initState();

    var actorContainers = ActorContainers(actors.actorContainers);
    _supervisors.addAll(
        List.generate(numberOfIsolates, (index) => IsolateSupervisor()));

    await Future.wait(List.generate(
        _supervisors.length, (index) => _supervisors[index].initState()));
    final ServerInput serverInput = ServerInput(
      _instance.port,
      _instance.host,
      _instance.routers,
      _instance.routes,
      _instance.middlewares,
      corsOptions: _instance.corsOptions,
      securityContext: _instance.securityContext,
    );
    ServerContext serverContext = ServerContext(actorContainers);
    ServerInfo? serverInfo;

    for (var i = 0; i < _supervisors.length; i++) {
      IsolateError? error;

      var subscription = _supervisors[i].errors.listen((event) {
        error ??= event;
      });
      var subscriptionServerInfo = _supervisors[i].serverInfo.listen((event) {
        serverInfo ??= event.serverInfo;
      });

      await _supervisors[i]
          .start(ServerTaskHandler(i, true, serverInput, serverContext));

      subscription.cancel();
      subscriptionServerInfo.cancel();

      if (error != null) {
        throw Exception(
            'an error occurred in the server instance: $i.\n\nInstance error:\n\n${error!.error}\n\nInstance stack trace:\n\n${error!.stackTrace}');
      }
    }
    return serverInfo!;
  }

  Future<void> pause() async {
    await Future.wait(_supervisors.map((e) => e.pause()));
  }

  Future<void> resume() async {
    await Future.wait(_supervisors.map((e) => e.resume()));
  }

  Future<void> dispose() async {
    await Future.wait(_supervisors.map((e) => e.dispose()));
  }
}
