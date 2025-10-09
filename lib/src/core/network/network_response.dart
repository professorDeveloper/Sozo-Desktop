class NetworkResponse<T> {
  final String errorText;
  final T? data;

  NetworkResponse({
    this.errorText = "",
    this.data,
  });
}