class BookEntity {
  final String id;
  final String title;
  final String? subtitle;
  final List<String> authors;
  final String? description;
  final String? imageUrl;
  final String? publishedDate;
  final int? publishedYear;
  final String? publisher;
  final List<String>? categories;
  final double? averageRating;
  final int? ratingsCount;
  final String? language;
  final int? pageCount;
  final String? printType;
  final String? previewLink;
  final String? infoLink;
  final bool isFavorite;

  BookEntity({
    required this.id,
    required this.title,
    this.subtitle,
    required this.authors,
    this.description,
    this.imageUrl,
    this.publishedDate,
    this.publishedYear,
    this.publisher,
    this.categories,
    this.averageRating,
    this.ratingsCount,
    this.language,
    this.pageCount,
    this.printType,
    this.previewLink,
    this.infoLink,
    this.isFavorite = false,
  });

  BookEntity copyWith({
    String? id,
    String? title,
    String? subtitle,
    List<String>? authors,
    String? description,
    String? imageUrl,
    String? publishedDate,
    int? publishedYear,
    String? publisher,
    List<String>? categories,
    double? averageRating,
    int? ratingsCount,
    String? language,
    int? pageCount,
    String? printType,
    String? previewLink,
    String? infoLink,
    bool? isFavorite,
  }) {
    return BookEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      authors: authors ?? this.authors,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedDate: publishedDate ?? this.publishedDate,
      publishedYear: publishedYear ?? this.publishedYear,
      publisher: publisher ?? this.publisher,
      categories: categories ?? this.categories,
      averageRating: averageRating ?? this.averageRating,
      ratingsCount: ratingsCount ?? this.ratingsCount,
      language: language ?? this.language,
      pageCount: pageCount ?? this.pageCount,
      printType: printType ?? this.printType,
      previewLink: previewLink ?? this.previewLink,
      infoLink: infoLink ?? this.infoLink,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
