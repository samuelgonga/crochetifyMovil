class ApiResponse {
  final bool success;
  final String message;
  final CartResponse response;

  ApiResponse({
    required this.success,
    required this.message,
    required this.response,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'],
      message: json['message'],
      response: CartResponse.fromJson(json['response']),
    );
  }

  get cart => null;

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'response': response.toJson(),
    };
  }
}

class CartResponse {
  final Cart cart;

  CartResponse({
    required this.cart,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      cart: Cart.fromJson(json['cart']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart': cart.toJson(),
    };
  }
}

class Cart {
  final int idCart;
  final double total;
  final List<CartProduct> cartProducts;

  Cart({
    required this.idCart,
    required this.total,
    required this.cartProducts,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      idCart: json['idCart'] ?? 0,  // Asignar 0 si el valor es nulo
      total: (json['total'] ?? 0.0).toDouble(),  // Asignar 0.0 si el valor es nulo
      cartProducts: (json['cartProducts'] as List?)?.map((item) => CartProduct.fromJson(item)).toList() ?? [],  // Asignar lista vacía si es nulo
    );
  }

  get id => null;

  Map<String, dynamic> toJson() {
    return {
      'idCart': idCart,
      'total': total,
      'cartProducts': cartProducts.map((item) => item.toJson()).toList(),
    };
  }
}

class CartProduct {
  final int stockId;
  final String color;
  final int quantity;
  final Product product;

  CartProduct({
    required this.stockId,
    required this.color,
    required this.quantity,
    required this.product,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      stockId: json['stockId'],
      color: json['color'],
      quantity: json['quantity'],
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stockId': stockId,
      'color': color,
      'quantity': quantity,
      'product': product.toJson(),
    };
  }
}

class Product {
  final int idProduct;
  final String name;
  final String description;
  final bool status;

  Product({
    required this.idProduct,
    required this.name,
    required this.description,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProduct: json['idProduct'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProduct': idProduct,
      'name': name,
      'description': description,
      'status': status,
    };
  }
}
