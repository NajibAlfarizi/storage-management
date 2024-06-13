class Product {
  final int? id;
  final String? name;
  final int? qty;
  final String? url;
  final int? categoryId;
  final String? createdBy;
  final String? updatedBy;

  Product({
    required this.id,
    required this.name,
    required this.qty,
    required this.url,
    required this.categoryId,
    required this.createdBy,
    required this.updatedBy,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      name: json['name'] as String?,
      qty: json['qty'] as int?,
      url: json['url'] as String?,
      categoryId: json['category_id'] as int?,
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
    );
  }
}
