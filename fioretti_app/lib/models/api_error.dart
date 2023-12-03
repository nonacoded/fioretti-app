class ApiError {
  final String message;

  const ApiError(this.message);

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(json['message'] as String);
  }
}
