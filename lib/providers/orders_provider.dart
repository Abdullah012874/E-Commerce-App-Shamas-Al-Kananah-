import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrdersNotifier extends Notifier<List<Order>> {
  final OrderService _orderService = OrderService();

  @override
  List<Order> build() {
    // We can't return a stream here directly, but we can listen to it
    _listenToOrders();
    return [];
  }

  void _listenToOrders() {
    // Note: For now we show all orders (admin view or simple sync)
    // In a real app, we would filter by user if not admin
    _orderService.getOrders(null).listen((orders) {
      state = orders;
    });
  }

  Future<void> addOrder(Order order) async {
    await _orderService.placeOrder(order);
  }

  void updateOrderStatus(String orderId, String newStatus) {
    // This would ideally be a Firestore update call
  }
}

final ordersProvider = NotifierProvider<OrdersNotifier, List<Order>>(OrdersNotifier.new);

