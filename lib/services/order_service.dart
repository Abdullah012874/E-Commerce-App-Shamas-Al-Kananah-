import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as app_order;

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(app_order.Order order) async {
    await _firestore.collection('orders').doc(order.orderId).set(order.toMap());
  }

  Stream<List<app_order.Order>> getOrders(String? userId) {
    Query query = _firestore.collection('orders');
    
    // If userId is provided, filter orders. If null, might be admin or guest list view
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }
    
    return query.orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return app_order.Order(
          orderId: data['orderId'],
          customerName: data['customerName'],
          userId: data['userId'],
          status: data['status'],
          totalAmount: (data['totalAmount'] as num).toDouble(),
          date: DateTime.parse(data['date']),
          items: data['items'],
        );
      }).toList();
    });
  }
}
