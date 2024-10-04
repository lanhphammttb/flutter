import 'package:json_annotation/json_annotation.dart';
import 'package:nttcs/data/models/base_response.dart';

part 'specific_status_reponse.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SpecificStatusResponse<T> extends BaseResponse {
  @JsonKey(name: 'Items')
  final T? items;

  SpecificStatusResponse({
    required bool status,
    required String message,
    int totalRecord = 0, // Giá trị mặc định là 0
    int page = 1,        // Giá trị mặc định là 1
    int size = 10,       // Giá trị mặc định là 10
    this.items,          // Items có thể là null
  }) : super(
    totalRecord: totalRecord,
    status: status,
    message: message,
    page: page,
    size: size,
  );

  // Factory function cho việc giải mã kiểu tổng quát T
  factory SpecificStatusResponse.fromJson(
      Map<String, dynamic> json, T Function(Object? json)? fromJsonT) =>
      _$SpecificStatusResponseFromJson(json, fromJsonT!);
}
