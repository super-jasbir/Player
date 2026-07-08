class NetworkWrapper<T> {
  final T? data;
  final String? error;
  final bool loading;

  NetworkWrapper({
    this.data,
    this.error,
    this.loading = false,
  });
}