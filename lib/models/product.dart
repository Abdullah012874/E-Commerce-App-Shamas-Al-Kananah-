class Product {
  String id;
  String name;
  double price;
  double rating;
  int reviews;
  String category;
  String imageUrl;
  bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.category,
    required this.imageUrl,
    this.inStock = true,
  });
}
