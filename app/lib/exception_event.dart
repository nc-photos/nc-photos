class ExceptionEvent {
  const ExceptionEvent(this.error, [this.stackTrace]);

  void throwMe() {
    Error.throwWithStackTrace(error, stackTrace ?? StackTrace.current);
  }

  final Object error;
  final StackTrace? stackTrace;
}
