import '../../domain/entities/book.dart';

class BookModel {
  final String id;
  final VolumeInfo volumeInfo;
  final SaleInfo? saleInfo;
  final AccessInfo? accessInfo;

  const BookModel({
    required this.id,
    required this.volumeInfo,
    this.saleInfo,
    this.accessInfo,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      volumeInfo: VolumeInfo.fromJson(json['volumeInfo'] as Map<String, dynamic>),
      saleInfo: json['saleInfo'] != null
          ? SaleInfo.fromJson(json['saleInfo'] as Map<String, dynamic>)
          : null,
      accessInfo: json['accessInfo'] != null
          ? AccessInfo.fromJson(json['accessInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'volumeInfo': volumeInfo.toJson(),
      'saleInfo': saleInfo?.toJson(),
      'accessInfo': accessInfo?.toJson(),
    };
  }

  Book toEntity() {
    return Book(
      id: id,
      title: volumeInfo.title,
      authors: volumeInfo.authors ?? [],
      description: volumeInfo.description,
      thumbnailUrl: volumeInfo.imageLinks?.thumbnail,
      publishedDate: volumeInfo.publishedDate,
      publisher: volumeInfo.publisher,
      pageCount: volumeInfo.pageCount,
      categories: volumeInfo.categories,
      language: volumeInfo.language,
      averageRating: volumeInfo.averageRating,
      ratingsCount: volumeInfo.ratingsCount,
      isbn: volumeInfo.industryIdentifiers
          ?.where((id) => id.type == 'ISBN_13' || id.type == 'ISBN_10')
          .firstOrNull
          ?.identifier,
      previewLink: volumeInfo.previewLink,
      infoLink: volumeInfo.infoLink,
    );
  }
}

class VolumeInfo {
  final String title;
  final List<String>? authors;
  final String? description;
  final ImageLinks? imageLinks;
  final String? publishedDate;
  final String? publisher;
  final int? pageCount;
  final List<String>? categories;
  final String? language;
  final double? averageRating;
  final int? ratingsCount;
  final List<IndustryIdentifier>? industryIdentifiers;
  final String? previewLink;
  final String? infoLink;

  const VolumeInfo({
    required this.title,
    this.authors,
    this.description,
    this.imageLinks,
    this.publishedDate,
    this.publisher,
    this.pageCount,
    this.categories,
    this.language,
    this.averageRating,
    this.ratingsCount,
    this.industryIdentifiers,
    this.previewLink,
    this.infoLink,
  });

  factory VolumeInfo.fromJson(Map<String, dynamic> json) {
    return VolumeInfo(
      title: json['title'] as String,
      authors: (json['authors'] as List<dynamic>?)?.cast<String>(),
      description: json['description'] as String?,
      imageLinks: json['imageLinks'] != null
          ? ImageLinks.fromJson(json['imageLinks'] as Map<String, dynamic>)
          : null,
      publishedDate: json['publishedDate'] as String?,
      publisher: json['publisher'] as String?,
      pageCount: json['pageCount'] as int?,
      categories: (json['categories'] as List<dynamic>?)?.cast<String>(),
      language: json['language'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      ratingsCount: json['ratingsCount'] as int?,
      industryIdentifiers: (json['industryIdentifiers'] as List<dynamic>?)
          ?.map((item) => IndustryIdentifier.fromJson(item as Map<String, dynamic>))
          .toList(),
      previewLink: json['previewLink'] as String?,
      infoLink: json['infoLink'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'authors': authors,
      'description': description,
      'imageLinks': imageLinks?.toJson(),
      'publishedDate': publishedDate,
      'publisher': publisher,
      'pageCount': pageCount,
      'categories': categories,
      'language': language,
      'averageRating': averageRating,
      'ratingsCount': ratingsCount,
      'industryIdentifiers': industryIdentifiers?.map((item) => item.toJson()).toList(),
      'previewLink': previewLink,
      'infoLink': infoLink,
    };
  }
}

class ImageLinks {
  final String? smallThumbnail;
  final String? thumbnail;
  final String? small;
  final String? medium;
  final String? large;
  final String? extraLarge;

  const ImageLinks({
    this.smallThumbnail,
    this.thumbnail,
    this.small,
    this.medium,
    this.large,
    this.extraLarge,
  });

  factory ImageLinks.fromJson(Map<String, dynamic> json) {
    return ImageLinks(
      smallThumbnail: json['smallThumbnail'] as String?,
      thumbnail: json['thumbnail'] as String?,
      small: json['small'] as String?,
      medium: json['medium'] as String?,
      large: json['large'] as String?,
      extraLarge: json['extraLarge'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'smallThumbnail': smallThumbnail,
      'thumbnail': thumbnail,
      'small': small,
      'medium': medium,
      'large': large,
      'extraLarge': extraLarge,
    };
  }
}

class IndustryIdentifier {
  final String type;
  final String identifier;

  const IndustryIdentifier({
    required this.type,
    required this.identifier,
  });

  factory IndustryIdentifier.fromJson(Map<String, dynamic> json) {
    return IndustryIdentifier(
      type: json['type'] as String,
      identifier: json['identifier'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'identifier': identifier,
    };
  }
}

class SaleInfo {
  final String? country;
  final String? saleability;
  final bool? isEbook;

  const SaleInfo({
    this.country,
    this.saleability,
    this.isEbook,
  });

  factory SaleInfo.fromJson(Map<String, dynamic> json) {
    return SaleInfo(
      country: json['country'] as String?,
      saleability: json['saleability'] as String?,
      isEbook: json['isEbook'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'saleability': saleability,
      'isEbook': isEbook,
    };
  }
}

class AccessInfo {
  final String? country;
  final String? viewability;
  final bool? embeddable;
  final bool? publicDomain;
  final String? textToSpeechPermission;
  final Epub? epub;
  final Pdf? pdf;
  final String? webReaderLink;
  final String? accessViewStatus;
  final bool? quoteSharingAllowed;

  const AccessInfo({
    this.country,
    this.viewability,
    this.embeddable,
    this.publicDomain,
    this.textToSpeechPermission,
    this.epub,
    this.pdf,
    this.webReaderLink,
    this.accessViewStatus,
    this.quoteSharingAllowed,
  });

  factory AccessInfo.fromJson(Map<String, dynamic> json) {
    return AccessInfo(
      country: json['country'] as String?,
      viewability: json['viewability'] as String?,
      embeddable: json['embeddable'] as bool?,
      publicDomain: json['publicDomain'] as bool?,
      textToSpeechPermission: json['textToSpeechPermission'] as String?,
      epub: json['epub'] != null
          ? Epub.fromJson(json['epub'] as Map<String, dynamic>)
          : null,
      pdf: json['pdf'] != null
          ? Pdf.fromJson(json['pdf'] as Map<String, dynamic>)
          : null,
      webReaderLink: json['webReaderLink'] as String?,
      accessViewStatus: json['accessViewStatus'] as String?,
      quoteSharingAllowed: json['quoteSharingAllowed'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'viewability': viewability,
      'embeddable': embeddable,
      'publicDomain': publicDomain,
      'textToSpeechPermission': textToSpeechPermission,
      'epub': epub?.toJson(),
      'pdf': pdf?.toJson(),
      'webReaderLink': webReaderLink,
      'accessViewStatus': accessViewStatus,
      'quoteSharingAllowed': quoteSharingAllowed,
    };
  }
}

class Epub {
  final bool? isAvailable;

  const Epub({this.isAvailable});

  factory Epub.fromJson(Map<String, dynamic> json) {
    return Epub(isAvailable: json['isAvailable'] as bool?);
  }

  Map<String, dynamic> toJson() {
    return {'isAvailable': isAvailable};
  }
}

class Pdf {
  final bool? isAvailable;

  const Pdf({this.isAvailable});

  factory Pdf.fromJson(Map<String, dynamic> json) {
    return Pdf(isAvailable: json['isAvailable'] as bool?);
  }

  Map<String, dynamic> toJson() {
    return {'isAvailable': isAvailable};
  }
}