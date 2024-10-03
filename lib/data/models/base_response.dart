import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable()
class BaseResponse {
  @JsonKey(name: 'TotalRecord')
  final int totalRecord;

  @JsonKey(name: 'Status')
  final bool status;

  @JsonKey(name: 'Message')
  final String message;

  @JsonKey(name: 'Page')
  final int page;

  @JsonKey(name: 'Size')
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
