class BaseResponse {
  int totalRecord;
  bool status;
  String message;
  int page;
  int size;
  dynamic data;

  BaseResponse({
    required this.totalRecord,
    required this.status,
    required this.message,
    required this.page,
    required this.size,
    required this.data,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      totalRecord: json['totalRecord'] as int,
      status: json['status'] as bool,
      message: json['message'] as String,
      page: json['page'] as int,
      size: json['size'] as int,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() => {
    'totalRecord': totalRecord,
    'status': status,
    'message': message,
    'page': page,
    'size': size,
    'data': data,
  };
}