import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/book_entity.dart';

part 'book_model.g.dart';

@JsonSerializable()
class BookModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'volumeInfo')
  final VolumeInfo volumeInfo;

  BookModel({required this.id, required this.volumeInfo});

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookModelToJson(this);

  factory BookModel.fromEntity(BookEntity entity) {
    return BookModel(
      id: entity.id,
      volumeInfo: VolumeInfo(
        title: entity.title,
        subtitle: entity.subtitle,
        authors: entity.authors,
        description: entity.description,
        imageLinks: ImageLinks(thumbnail: entity.imageUrl),
        publishedDate: entity.publishedDate,
        publisher: entity.publisher,
        categories: entity.categories,
        averageRating: entity.averageRating,
        ratingsCount: entity.ratingsCount,
        language: entity.language,
        pageCount: entity.pageCount,
        printType: entity.printType,
        previewLink: entity.previewLink,
        infoLink: entity.infoLink,
      ),
    );
  }

  BookEntity toEntity({bool isFavorite = false}) {
    return BookEntity(
      id: id,
      title: volumeInfo.title ?? 'Unknown Title',
      subtitle: volumeInfo.subtitle,
      authors: volumeInfo.authors ?? [],
      description: volumeInfo.description,
      imageUrl: volumeInfo.imageLinks?.thumbnail,
      publishedDate: volumeInfo.publishedDate,
      publishedYear: _parseYear(volumeInfo.publishedDate),
      publisher: volumeInfo.publisher,
      categories: volumeInfo.categories,
      averageRating: volumeInfo.averageRating?.toDouble(),
      ratingsCount: volumeInfo.ratingsCount,
      language: volumeInfo.language,
      pageCount: volumeInfo.pageCount,
      printType: volumeInfo.printType,
      previewLink: volumeInfo.previewLink,
      infoLink: volumeInfo.infoLink,
      isFavorite: isFavorite,
    );
  }

  static int? _parseYear(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      return int.parse(dateStr.substring(0, 4));
    } catch (_) {
      return null;
    }
  }
}

@JsonSerializable()
class VolumeInfo {
  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'authors')
  final List<String>? authors;

  @JsonKey(name: 'subtitle')
  final String? subtitle;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'imageLinks')
  final ImageLinks? imageLinks;

  @JsonKey(name: 'publishedDate')
  final String? publishedDate;

  @JsonKey(name: 'publisher')
  final String? publisher;

  @JsonKey(name: 'categories')
  final List<String>? categories;

  @JsonKey(name: 'averageRating')
  final num? averageRating;

  @JsonKey(name: 'ratingsCount')
  final int? ratingsCount;

  @JsonKey(name: 'language')
  final String? language;

  @JsonKey(name: 'pageCount')
  final int? pageCount;

  @JsonKey(name: 'printType')
  final String? printType;

  @JsonKey(name: 'previewLink')
  final String? previewLink;

  @JsonKey(name: 'infoLink')
  final String? infoLink;

  VolumeInfo({
    this.title,
    this.authors,
    this.subtitle,
    this.description,
    this.imageLinks,
    this.publishedDate,
    this.publisher,
    this.categories,
    this.averageRating,
    this.ratingsCount,
    this.language,
    this.pageCount,
    this.printType,
    this.previewLink,
    this.infoLink,
  });

  factory VolumeInfo.fromJson(Map<String, dynamic> json) =>
      _$VolumeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VolumeInfoToJson(this);
}

@JsonSerializable()
class ImageLinks {
  @JsonKey(name: 'thumbnail')
  final String? thumbnail;

  @JsonKey(name: 'smallThumbnail')
  final String? smallThumbnail;

  ImageLinks({this.thumbnail, this.smallThumbnail});

  factory ImageLinks.fromJson(Map<String, dynamic> json) =>
      _$ImageLinksFromJson(json);

  Map<String, dynamic> toJson() => _$ImageLinksToJson(this);
}
