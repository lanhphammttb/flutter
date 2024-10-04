import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable()
class BaseResponse {
  @JsonKey(name: 'TotalRecord', defaultValue: 0)
  final int totalRecord;

  @JsonKey(name: 'Status', defaultValue: false)
  final bool status;

  @JsonKey(name: 'Message', defaultValue: '')
  final String message;

  @JsonKey(name: 'Page', defaultValue: 1)
  final int page;

  @JsonKey(name: 'Size', defaultValue: 10)
  final int size;

  BaseResponse({
    required this.totalRecord,
    required this.status,
    required this.message,
    required this.page,
    required this.size,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) => _$BaseResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BaseResponseToJson(this);
}
