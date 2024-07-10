part of '../fennec.dart';

/// [BodyParser] is a class that contains the body parser.
/// It's used to parse the body of the request.
class BodyParser {
  /// [parseBody] is a static method that parses the body of the request.
  /// It's used to parse the body of the request.
  /// returns a [Future] of [Request].
  static Future<Request> parseBody(
      HttpRequest httpRequest, Map<String, dynamic> pathParams) async {
    dynamic body;
    Map<String, dynamic> params = {};
    httpRequest.uri.queryParameters.forEach((key, value) {
      params.addAll({key: value});
    });
    ContentType? contentType = httpRequest.headers.contentType;
    if (contentType != null) {
      var content = await utf8.decoder.bind(httpRequest).join();
      body = content;
    }
    return Request(
      httpRequest,
      body,
      params,
      httpRequest.headers,
      pathParams,
    );
  }
}
