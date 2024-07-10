part of '../fennec.dart';

/// [Request] is a class that contains information about the request.
/// It's used to get information about the request.
class Request {
  /// [httpRequest] is a [HttpRequest] that contains the request.
  final HttpRequest httpRequest;

  /// [body] contains the body of the request.
  final dynamic body;

  /// [params] is a [Map] that contains the params of the request.
  final Map<String, dynamic> params;

  /// [httpHeaders] is a [HttpHeaders] that contains the headers of the request.
  final HttpHeaders httpHeaders;

  /// [pathParams] is a [Map] that contains the path params of the request.
  /// It's used to get the path params of the request.
  /// by-default it's null.
  Map<String, dynamic> pathParams = {};

  /// [additionalData] is a [Map] that contains the additional data of the request.
  /// bydefault it's null.
  Map<String, dynamic>? additionalData;

  /// [Request] is a constructor that creates a new [Request] object.
  Request(
    this.httpRequest,
    this.body,
    this.params,
    this.httpHeaders,
    this.pathParams, {
    this.additionalData,
  });

  /// [copyWith] is a method that returns a new [Request] object with the same properties of the current object.
  Request copyWith({
    HttpRequest? httpRequest,
    dynamic body,
    Map<String, dynamic>? params,
    HttpHeaders? httpHeaders,
    Map<String, dynamic>? additionalData,
    Map<String, dynamic>? pathParams,
  }) {
    return Request(
      httpRequest ?? this.httpRequest,
      body ?? this.body,
      params ?? this.params,
      httpHeaders ?? this.httpHeaders,
      pathParams ?? this.pathParams,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}
