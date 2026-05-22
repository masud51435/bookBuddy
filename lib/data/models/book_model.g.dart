// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookModel _$BookModelFromJson(Map<String, dynamic> json) => BookModel(
      id: json['id'] as String,
      volumeInfo:
          VolumeInfo.fromJson(json['volumeInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
      'id': instance.id,
      'volumeInfo': instance.volumeInfo,
    };

VolumeInfo _$VolumeInfoFromJson(Map<String, dynamic> json) => VolumeInfo(
      title: json['title'] as String?,
      authors:
          (json['authors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      subtitle: json['subtitle'] as String?,
      description: json['description'] as String?,
      imageLinks: json['imageLinks'] == null
          ? null
          : ImageLinks.fromJson(json['imageLinks'] as Map<String, dynamic>),
      publishedDate: json['publishedDate'] as String?,
      publisher: json['publisher'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      averageRating: json['averageRating'] as num?,
      ratingsCount: (json['ratingsCount'] as num?)?.toInt(),
      language: json['language'] as String?,
      pageCount: (json['pageCount'] as num?)?.toInt(),
      printType: json['printType'] as String?,
      previewLink: json['previewLink'] as String?,
      infoLink: json['infoLink'] as String?,
    );

Map<String, dynamic> _$VolumeInfoToJson(VolumeInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'authors': instance.authors,
      'subtitle': instance.subtitle,
      'description': instance.description,
      'imageLinks': instance.imageLinks,
      'publishedDate': instance.publishedDate,
      'publisher': instance.publisher,
      'categories': instance.categories,
      'averageRating': instance.averageRating,
      'ratingsCount': instance.ratingsCount,
      'language': instance.language,
      'pageCount': instance.pageCount,
      'printType': instance.printType,
      'previewLink': instance.previewLink,
      'infoLink': instance.infoLink,
    };

ImageLinks _$ImageLinksFromJson(Map<String, dynamic> json) => ImageLinks(
      thumbnail: json['thumbnail'] as String?,
      smallThumbnail: json['smallThumbnail'] as String?,
    );

Map<String, dynamic> _$ImageLinksToJson(ImageLinks instance) =>
    <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'smallThumbnail': instance.smallThumbnail,
    };
