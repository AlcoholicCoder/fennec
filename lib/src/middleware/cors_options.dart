part of '../../fennec.dart';

class CorsOptions {
  int age;
  String headers;
  String methods;
  String origin;
  CorsOptions(
      {this.age = 86400,
      this.headers = '*',
      this.methods = 'POST, GET, OPTIONS, PUT, PATCH, DELETE',
      this.origin = '*'});
}
