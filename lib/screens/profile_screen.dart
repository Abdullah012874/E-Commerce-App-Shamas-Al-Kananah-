import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/auth_provider.dart';
import '../providers/orders_provider.dart';
import '../providers/products_provider.dart';
import '../utils/app_colors.dart';
import 'auth/login_screen.dart';
import '../widgets/app_drawer.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.status == AuthStatus.admin) {
      return const AdminDashboard();
    } else if (authState.status == AuthStatus.authenticated) {
      return const UserDashboard();
    } else {
      return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Login required to view dashboard', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class UserDashboard extends ConsumerWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final orders = ref.watch(ordersProvider); // Ideally filter by user id, but since dummy, show all or filtered

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: AppColors.accent, child: Icon(Icons.person, color: Colors.white)),
                title: Text(user?.fullName ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                subtitle: Text('${user?.email}\n${user?.phone}'),
                isThreeLine: true,
              ),
            ),
            const SizedBox(height: 24),
            const Text('My Orders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (orders.isEmpty)
              const Text('No orders yet.')
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Order ID', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: orders.map((order) {
                    Color statusColor;
                    switch (order.status) {
                      case 'Delivered': statusColor = Colors.green; break;
                      case 'Shipped': statusColor = Colors.blue; break;
                      case 'In Process': statusColor = Colors.orange; break;
                      case 'Cancelled': statusColor = Colors.red; break;
                      default: statusColor = Colors.grey;
                    }
                    return DataRow(cells: [
                      DataCell(Text(order.orderId)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(order.status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                      DataCell(Text('${order.totalAmount} SAR')),
                    ]);
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final products = ref.watch(productsProvider);

    final totalRevenue = orders.where((o) => o.status != 'Cancelled').fold(0.0, (sum, o) => sum + o.totalAmount);
    final totalOrders = orders.length;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard('Total Revenue', '${totalRevenue.toStringAsFixed(0)} SAR', Icons.attach_money, Colors.green),
                _buildStatCard('Total Orders', '$totalOrders', Icons.shopping_bag, Colors.blue),
                _buildStatCard('Users', '1', Icons.people, Colors.purple),
                _buildStatCard('Products', '${products.length}', Icons.inventory, Colors.orange),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Recent Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Order ID', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Customer', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: orders.map((order) {
                  Color statusColor;
                  switch (order.status) {
                    case 'Delivered': statusColor = Colors.green; break;
                    case 'Shipped': statusColor = Colors.blue; break;
                    case 'In Process': statusColor = Colors.orange; break;
                    case 'Cancelled': statusColor = Colors.red; break;
                    default: statusColor = Colors.grey;
                  }
                  
                  return DataRow(cells: [
                    DataCell(Text(order.orderId)),
                    DataCell(Text(order.customerName)),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(order.status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                    DataCell(Text('${order.totalAmount} SAR')),
                  ]);
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Manage Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: p.imageUrl.startsWith('http')
                          ? NetworkImage(p.imageUrl)
                          : AssetImage(p.imageUrl) as ImageProvider,
                    ),
                    title: Text(p.name),
                    subtitle: Text('${p.price} SAR - ${p.category}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditProductDialog(context, ref, p);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ref.read(productsProvider.notifier).deleteProduct(p.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, WidgetRef ref, dynamic product) {
    final priceController = TextEditingController(text: product.price.toString());
    final nameController = TextEditingController(text: product.name);
    final catController = TextEditingController(text: product.category);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: catController, decoration: const InputDecoration(labelText: 'Category')),
            TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final newPrice = double.tryParse(priceController.text) ?? product.price;
              ref.read(productsProvider.notifier).updateProductPrice(product.id, newPrice);
              ref.read(productsProvider.notifier).updateProductInfo(product.id, nameController.text, catController.text);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

