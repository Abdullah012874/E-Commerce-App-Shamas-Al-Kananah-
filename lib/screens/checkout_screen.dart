import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_colors.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/locale_provider.dart';
import '../models/order.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _addressController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _confirmOrder() async {
    final t = ref.read(translationProvider);
    
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t['fill_fields'] ?? 'Please fill all required fields')));
      return;
    }

    final cartNotifier = ref.read(cartProvider.notifier);
    final cartItems = ref.read(cartProvider);
    final totalPrice = cartNotifier.totalPrice;
    final user = ref.read(authProvider).user;
    
    if (totalPrice == 0) return;

    final newOrder = Order(
      orderId: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      customerName: _nameController.text.trim(),
      userId: user?.id, // Null means Guest
      status: 'Pending',
      totalAmount: totalPrice,
      date: DateTime.now(),
      items: cartItems.map((e) => {
        'id': e.product.id,
        'name': e.product.name,
        'price': e.product.price,
        'quantity': e.quantity,
      }).toList(),
    );

    await ref.read(ordersProvider.notifier).addOrder(newOrder);
    cartNotifier.clearAll();

    // Show confirmation
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Text(t['order_confirmed'] ?? 'Order Confirmed!'),
          content: Text('${t['order_success_msg'] ?? 'Your order has been placed successfully.'}\n\nID: ${newOrder.orderId}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = ref.watch(cartProvider.notifier).totalPrice;
    final t = ref.watch(translationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t['checkout'] ?? 'Checkout'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t['delivery_info'] ?? 'Delivery Information', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: t['full_name'] ?? 'Full Name', border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: t['phone'] ?? 'Phone Number', border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(labelText: t['address'] ?? 'Delivery Address', border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${t['total'] ?? 'Total'}:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${totalPrice.toStringAsFixed(2)} ${t['sar'] ?? 'SAR'}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.accent)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(t['checkout'] ?? 'Confirm Order', style: const TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

