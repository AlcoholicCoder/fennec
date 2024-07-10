import 'dart:async';
import 'package:fennec/fennec.dart';

void main(List<String> arguments) async {
  Application application = Application();

  application.setNumberOfIsolates(1);
  application.setPort(8000);
  application.addRouters([testRouter()]);
  application.addActor(CustomisedActor("customizedActor"));

  ServerInfo serverInfo = await application.runServer();
  print("Server is running at Port ${serverInfo.port}");
}

Router testRouter() {
  Future<Middleware> testMiddleware(
      ServerContext serverContext, Request req, Response res) async {
    if (2 == 2) {
      return Next();
    }
    return Stop(res.forbidden(body: {"error": "not allowed"}).json());
  }

  Router router = Router();
  router.useMiddleware(testMiddleware);
  router.useMiddleware((serverContext, req, res) {
    if (2 == 2) {
      return Next();
    }
    return Stop(res.forbidden(body: {"error": "not allowed"}).json());
  });

  router.get(
      path: "/test/{id}",
      requestHandler: (context, req, res) async {
        context.actorContainers['customizedActor']!.execute("insert");
        CustomisedActor customisedActor =
            await context.actorContainers['customizedActor']!.getInstance();
        print(customisedActor.get("get"));
        return res.ok(body: {"id": req.pathParams['id']}).json();
      });

  return router;
}

class CustomisedActor extends Actor {
  final List<String> _strings = [];

  CustomisedActor(super.name);

  @override
  FutureOr<void> execute(String action,
      {Map<String, dynamic> data = const {}}) {
    if (action == 'insert') {
      _strings.add(" new item");
    } else {
      if (_strings.isNotEmpty) {
        _strings.removeLast();
      }
    }
  }

  @override
  FutureOr get(String action, {Map<String, dynamic> data = const {}}) {
    if (action == "get") {
      return _strings;
    }
    return null;
  }
}
