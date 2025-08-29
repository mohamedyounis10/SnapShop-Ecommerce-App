import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshop/features/cart/cubit/state.dart';

import '../../../core/db/firebase.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';

class CartCubit extends Cubit<CartState>{
  CartCubit(): super(InitState());
  final FirebaseService services = FirebaseService();

  bool isCurrentSelected = true;
  List<Product> userOrder = [];
  Map<int, int> productQuantities = {};
  List<Orders> UserOrders = []; // Class level variable

  void addToUserOrder(Product product) {
    if (!userOrder.any((p) => p.id == product.id)) {
      userOrder.add(product);
      productQuantities[product.id] = 1;
      emit(UserOrderAdded(userOrder: List.from(userOrder)));
    } else {
      emit(UserOrderAlreadyAdded(product));
    }
  }

  void removeFromUserOrder(Product product) {
    userOrder.removeWhere((p) => p.id == product.id);
    productQuantities.remove(product.id);
    emit(UserOrderRemoved(List.from(userOrder)));
  }

  void increaseQuantity(Product product) {
    int currentQty = productQuantities[product.id] ?? 1;
    if (currentQty < product.stock) {
      productQuantities[product.id] = currentQty + 1;
      emit(UserOrderQuantityChanged(
        List.from(userOrder),
        Map.from(productQuantities),
      ));
    } else {
      emit(UserOrderStockLimitReached(product, product.stock));
    }
  }

  void decreaseQuantity(Product product) {
    int currentQty = productQuantities[product.id] ?? 1;
    if (currentQty > 1) {
      productQuantities[product.id] = currentQty - 1;
      emit(UserOrderQuantityChanged(
        List.from(userOrder),
        Map.from(productQuantities),
      ));
    }
  }

  void previewOrder() {
    if (userOrder.isEmpty) {
      print("Cart is empty");
      return;
    }

    final List<Map<String, dynamic>> orderProducts = userOrder.map((product) {
      final qty = productQuantities[product.id] ?? 1;
      return {
        "id": product.id,
        "title": product.title,
        "price": product.price,
        "quantity": qty,
        "totalPrice": product.price * qty,
        "addedAt": DateTime.now().toIso8601String(),
      };
    }).toList();

    final double totalOrderPrice = orderProducts.fold(
      0,
          (sum, item) => sum + (item['totalPrice'] as double),
    );

    final Map<String, dynamic> orderData = {
      "userId": services.getCurrentUserId() ?? "TEST_USER",
      "totalOrderPrice": totalOrderPrice,
      "orderedAt": DateTime.now().toIso8601String(),
      "products": orderProducts,
    };

    // Will be displayed in terminal instead of Firebase
    print("==== Order Preview ====");
    print(orderData);
  }

  Future<void> saveOrderForUser() async {
    try {
      emit(OrderLoading());

      await services.saveOrder(
        products: userOrder,
        productQuantities: productQuantities,
      );

      emit(OrderSuccess());
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> fetchOrders() async {
    emit(OrdersLoading());
    try {
      print(services.currentUserId);
      print("Fetching orders...");

      final orders = await services.getOrders();
      print("Orders fetched: ${orders.length}");

      for (var order in orders) {
        print("Order ID: ${order.orderId}, Total: ${order.totalOrderPrice}");
      }

      UserOrders = orders; // Store data in class
      emit(OrdersFetch(orders: UserOrders));
    } catch (e) {
      print("Error fetching orders: $e");
      emit(OrdersError(e.toString()));
    }
  }

  void toggleTab(bool currentSelected) {
    isCurrentSelected = currentSelected;
    emit(CartStateUpdated());
  }

  void clearUserOrder() {
    userOrder.clear();
    productQuantities.clear();
    emit(UserOrderCleared());
  }

}