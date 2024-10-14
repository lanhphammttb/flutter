import 'package:json_annotation/json_annotation.dart';
import 'base_response.dart';

part 'specific_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SpecificResponse<T> extends BaseResponse {
  @JsonKey(name: 'Items', defaultValue: [])
  final List<T> items;

  SpecificResponse({
    required super.totalRecord,
    required super.status,
    required super.message,
    required super.page,
    required super.size,
    required this.items,
  });

  factory SpecificResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return SpecificResponse(
      totalRecord: json['TotalRecord'] as int? ?? 0,
      status: json['Status'] as bool? ?? false,
      message: json['Message'] as String? ?? '',
      page: json['Page'] as int? ?? 1,
      size: json['Size'] as int? ?? 10,
      items: (json['Items'] as List<dynamic>?)?.map((item) => fromJsonT(item)).toList() ?? <T>[],
    );
  }
}
