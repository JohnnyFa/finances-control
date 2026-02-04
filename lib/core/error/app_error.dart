sealed class AppError {
  final String message;
  const AppError(this.message);
}

class NetworkError extends AppError {
  const NetworkError() : super("Falha de conexão");
}

class ServerError extends AppError {
  const ServerError() : super("Erro no servidor");
}

class UnexpectedError extends AppError {
  const UnexpectedError() : super("Erro inesperado");
}

sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);
}
