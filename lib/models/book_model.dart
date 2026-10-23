class BookModel {
  final String id;
  final String isbn;
  final String title;
  final String author;
  final String publisher;
  final int year;
  final String category;
  final String shelf;
  final int stock;
  final int availableStock;
  final int borrowedCount;
  final String description;
  final String cover;

  BookModel({
    required this.id,
    required this.isbn,
    required this.title,
    required this.author,
    required this.publisher,
    required this.year,
    required this.category,
    required this.shelf,
    required this.stock,
    required this.availableStock,
    this.borrowedCount = 0,
    this.description = '',
    this.cover = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isbn': isbn,
      'title': title,
      'author': author,
      'publisher': publisher,
      'year': year,
      'category': category,
      'shelf': shelf,
      'stock': stock,
      'availableStock': availableStock,
      'borrowedCount': borrowedCount,
      'description': description,
      'cover': cover,
    };
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String? ?? '',
      isbn: json['isbn'] as String? ?? '',
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      publisher: json['publisher'] as String? ?? '',
      year: (json['year'] as num?)?.toInt() ?? 2024,
      category: json['category'] as String? ?? 'Umum',
      shelf: json['shelf'] as String? ?? 'Rak A-01',
      stock: (json['stock'] as num?)?.toInt() ?? 1,
      availableStock: (json['availableStock'] as num?)?.toInt() ?? 1,
      borrowedCount: (json['borrowedCount'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      cover: json['cover'] as String? ?? '',
    );
  }

  BookModel copyWith({
    String? id,
    String? isbn,
    String? title,
    String? author,
    String? publisher,
    int? year,
    String? category,
    String? shelf,
    int? stock,
    int? availableStock,
    int? borrowedCount,
    String? description,
    String? cover,
  }) {
    return BookModel(
      id: id ?? this.id,
      isbn: isbn ?? this.isbn,
      title: title ?? this.title,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      year: year ?? this.year,
      category: category ?? this.category,
      shelf: shelf ?? this.shelf,
      stock: stock ?? this.stock,
      availableStock: availableStock ?? this.availableStock,
      borrowedCount: borrowedCount ?? this.borrowedCount,
      description: description ?? this.description,
      cover: cover ?? this.cover,
    );
  }
}
