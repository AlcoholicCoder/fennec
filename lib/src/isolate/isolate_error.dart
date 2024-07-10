part of '../../fennec.dart';

class IsolateError {
  final Object error;

  final StackTrace stackTrace;

  IsolateError(this.error, this.stackTrace);
}
