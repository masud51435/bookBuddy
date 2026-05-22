import 'package:json_annotation/json_annotation.dart';
import 'book_model.dart';

part 'search_response_model.g.dart';

@JsonSerializable()
class SearchResponseModel {
  @JsonKey(name: 'kind')
  final String? kind;

  @JsonKey(name: 'totalItems')
  final int? totalItems;

  @JsonKey(name: 'items')
  final List<BookModel>? items;

  SearchResponseModel({this.kind, this.totalItems, this.items});

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseModelToJson(this);
}
