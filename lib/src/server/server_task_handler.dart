part of '../../fennec.dart';

class ServerTaskHandler extends IsolateTaskHandler {
  late final int _instance;
  late final bool shared;
  final ServerInput serverInput;
  late ServerContext serverContext;

  late final Server server;

  ServerTaskHandler(
      this._instance, this.shared, this.serverInput, this.serverContext);

  @override
  Future<void> onStart(IsolateContext context) async {
    try {
      server = Server(serverInput, serverContext);
      final ServerInfo serverInfo = await server.startServer(_instance, shared);
      context.send(IsolateServerInfo(serverInfo));
    } catch (error, stackTrace) {
      context.send(IsolateError(error, stackTrace));
    }
  }

  @override
  Future<void> onStop(IsolateContext context) async {
    await server.dispose();
  }

  @override
  Future<void> onDispose(IsolateContext context) async {
    await server.dispose();
  }
}
