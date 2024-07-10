part of '../../fennec.dart';

/// [RequestHandler] is a [typedef] that is used to define a callback for a request.
/// [req] is a [Request] that is the request.
/// [res] is a [Response] that is the response.
///
/// returns [FutureOr] of [void].
typedef RequestHandler = FutureOr<Response> Function(
    ServerContext serverContext, Request req, Response res);
typedef RouterInitState = FutureOr<dynamic> Function(
    ServerContext serverContext);

/// [MiddlewareHandler] is a [typedef].
/// [req] is a [Request] that is the request.
/// [res] is a [Response] that is the response.
/// returns [FutureOr] of [Next].
typedef MiddlewareHandler = FutureOr<Middleware> Function(
    ServerContext serverContext, Request req, Response res);

typedef IsolateMessageHandler<T> = FutureOr<void> Function(T message);
