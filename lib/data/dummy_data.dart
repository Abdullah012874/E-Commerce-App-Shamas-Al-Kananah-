import '../models/product.dart';
import '../models/order.dart';


class DummyData {
  static final List<String> categories = [
    'Electrical',
    'Plumbing',
    'Hardware',
    'Tools',
  ];

  static final List<Product> products = [
    Product(
      id: 'E1',
      name: 'Storage Bag',
      price: 250.0,
      rating: 4.8,
      reviews: 124,
      category: 'Electrical',
      imageUrl: 'assets/images/storage_bag.jpeg',
    ),
    Product(
      id: 'E2',
      name: 'Screw Driver 4x190mm',
      price: 45.0,
      rating: 4.5,
      reviews: 89,
      category: 'Electrical',
      imageUrl: 'assets/images/screw_driver_4.jpeg',
    ),
    Product(
      id: 'P1',
      name: 'Screw Driver 3x190mm',
      price: 35.0,
      rating: 4.2,
      reviews: 56,
      category: 'Plumbing',
      imageUrl: 'assets/images/screw_driver_3.jpeg',
    ),
    Product(
      id: 'P2',
      name: 'Water Gyser',
      price: 180.0,
      rating: 4.9,
      reviews: 210,
      category: 'Plumbing',
      imageUrl: 'assets/images/water_gyser.jpeg',
    ),
    Product(
      id: 'H1',
      name: 'LED BULB',
      price: 65.0,
      rating: 4.6,
      reviews: 145,
      category: 'Hardware',
      imageUrl: 'assets/images/led_bulb.jpeg',
    ),
    Product(
      id: 'H2',
      name: 'Extension',
      price: 120.0,
      rating: 4.7,
      reviews: 180,
      category: 'Hardware',
      imageUrl: 'assets/images/extension.jpeg',
    ),
    Product(
      id: 'T1',
      name: 'Water Pipe Extensions',
      price: 150.0,
      rating: 4.4,
      reviews: 90,
      category: 'Tools',
      imageUrl: 'assets/images/pipe_extensions.jpeg',
    ),
    Product(
      id: 'T2',
      name: 'Acetic Silicone',
      price: 85.0,
      rating: 4.5,
      reviews: 75,
      category: 'Tools',
      imageUrl: 'assets/images/silicone.jpeg',
    ),
  ];

  static final List<Order> recentOrders = [
    Order(
      orderId: 'ORD-1001',
      customerName: 'Ahmad Ali',
      status: 'Delivered',
      totalAmount: 450.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Order(
      orderId: 'ORD-1002',
      customerName: 'Mohammed Khalid',
      status: 'Shipped',
      totalAmount: 180.0,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Order(
      orderId: 'ORD-1003',
      customerName: 'Fatima Saad',
      status: 'In Process',
      totalAmount: 245.0,
      date: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Order(
      orderId: 'ORD-1004',
      customerName: 'Omar Youssef',
      status: 'Cancelled',
      totalAmount: 85.0,
      date: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];
}