part of '../../fennec.dart';

/// [Middleware] is an abstract class that contains the response of the middleware
abstract class Middleware {}

class Next implements Middleware {
  Next();
}

class Stop implements Middleware {
  final Response response;
  Stop(this.response);
}
