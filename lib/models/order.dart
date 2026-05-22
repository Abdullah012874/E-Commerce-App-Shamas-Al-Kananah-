class Order {
  final String orderId;
  final String customerName;
  final String? userId; // Null for guest users
  final String status;
  final double totalAmount;
  final DateTime date;
  final List<dynamic>? items; // Store cart items snapshot

  Order({
    required this.orderId,
    required this.customerName,
    this.userId,
    required this.status,
    required this.totalAmount,
    required this.date,
    this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerName': customerName,
      'userId': userId,
      'status': status,
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
      'items': items,
    };
  }
}

