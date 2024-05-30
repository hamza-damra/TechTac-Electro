import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techtac_electro/provider/order_provider.dart';
import 'package:techtac_electro/screens/root_screen.dart';
import 'package:techtac_electro/services/assets_manager.dart';
import 'package:techtac_electro/widgets/empty_bag.dart';
import 'package:techtac_electro/widgets/text_widget.dart';
import 'orders_widget.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<void> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    await ordersProvider.fetchOrder();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const TitlesTextWidget(
          label: 'Placed orders',
        ),
      ),
      body: FutureBuilder<void>(
        future: _ordersFuture,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: SelectableText(
                "An error has occurred: ${snapshot.error}",
              ),
            );
          } else {
            if (ordersProvider.getOrders.isEmpty) {
              return EmptyBagWidget(
                imagePath: AssetsManager.orderBag,
                title: "No orders have been placed yet",
                subtitle: "",
                buttonText: "Shop now",
                function: () {
                  Navigator.pushReplacementNamed(context, RootScreen.routeName);
                },
              );
            }
            return ListView.separated(
              itemCount: ordersProvider.getOrders.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                  child: OrdersWidget(
                    ordersModel: ordersProvider.getOrders[index],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            );
          }
        }),
      ),
    );
  }
}
