typedef JsonObj = Map<String, dynamic>;

typedef ErrorHandler = void Function(Object error, StackTrace? stackTrace);

typedef ErrorWithValueHandler<T> =
    void Function(T value, Object error, StackTrace? stackTrace);

typedef ErrorWithValueIndexedHandler<T> =
    void Function(int index, T value, Object error, StackTrace? stackTrace);
