import '../../../models/order.dart';
import '../../../models/product.dart';

abstract class CartState {}

class InitState extends CartState {}

class UserOrderAdded extends CartState {
  final List<Product> userOrder;
  UserOrderAdded({required this.userOrder});
}

class UserOrderAlreadyAdded extends CartState {
  final Product product;
  UserOrderAlreadyAdded(this.product);
}

class UserOrderRemoved extends CartState {
  final List<Product> userOrder;
  UserOrderRemoved(this.userOrder);
}

class UserOrderQuantityChanged extends CartState {
  final List<Product> userOrder;
  final Map<int, int> productQuantities;
  UserOrderQuantityChanged(this.userOrder, this.productQuantities);
}

class UserOrderStockLimitReached extends CartState {
  final Product product;
  final int stock;
  UserOrderStockLimitReached(this.product, this.stock);
}

class UserOrderCleared extends CartState {}

class OrderLoading extends CartState {}

class OrderSuccess extends CartState {}

class OrderFailure extends CartState {
  final String message;
  OrderFailure(this.message);
}

class OrdersLoading extends CartState {}

class OrdersLoaded extends CartState {
  final List<Orders> orders;
  OrdersLoaded(this.orders);
}

class OrdersError extends CartState {
  final String message;
  OrdersError(this.message);
}
class OrdersFetch extends CartState {
  final List<Orders> orders;
  OrdersFetch({required this.orders});
}

class CartStateUpdated extends CartState{}