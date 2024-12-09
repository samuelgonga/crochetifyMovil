class Order {
  final int idOrder;
  final double total;
  final int idShipment;
  int statusShipment;
  final String shippingDay;
  final String deliveryDay;
  final String orderDirection;
  final String phoneDirection;
  final List<OrderProduct> orderProducts;

  Order({
    required this.idOrder,
    required this.total,
    required this.idShipment,
    required this.statusShipment,
    required this.shippingDay,
    required this.deliveryDay,
    required this.orderDirection,
    required this.phoneDirection,
    required this.orderProducts,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      idOrder: json['idOrden'],
      total: json['total'],
      idShipment: json['idShipment'],
      statusShipment: json['statusShipment'] ?? 0,
      shippingDay: json['shipping_day'] ?? '',
      deliveryDay: json['delivery_day'] ?? '',
      orderDirection: json['ordenDirection'] ?? '',
      phoneDirection: json['phoneDirection'] ?? '',
      orderProducts: (json['ordenProducts'] as List)
          .map((product) => OrderProduct.fromJson(product))
          .toList(),
    );
  }

  Order copyWith({
    int? idOrder,
    double? total,
    int? idShipment,
    int? statusShipment,
    String? shippingDay,
    String? deliveryDay,
    String? orderDirection,
    String? phoneDirection,
    List<OrderProduct>? orderProducts,
  }) {
    return Order(
      idOrder: idOrder ?? this.idOrder,
      total: total ?? this.total,
      idShipment: idShipment ?? this.idShipment,
      statusShipment: statusShipment ?? this.statusShipment,
      shippingDay: shippingDay ?? this.shippingDay,
      deliveryDay: deliveryDay ?? this.deliveryDay,
      orderDirection: orderDirection ?? this.orderDirection,
      phoneDirection: phoneDirection ?? this.phoneDirection,
      orderProducts: orderProducts ?? this.orderProducts,
    );
  }

  get userId => null;

  get directionId => null;
}


class OrderProduct {
  final int stockId;
  final String color;
  final int quantity;
  final Product product;
  final List<ImageData> images;

  OrderProduct({
    required this.stockId,
    required this.color,
    required this.quantity,
    required this.product,
    required this.images,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      stockId: json['stockId'],
      color: json['color'],
      quantity: json['quantity'],
      product: Product.fromJson(json['product']),
      images: (json['images'] as List)
          .map((image) => ImageData.fromJson(image))
          .toList(),
    );
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
}

class ImageData {
  final int idImage;
  final String image;

  ImageData({
    required this.idImage,
    required this.image,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      idImage: json['idImage'],
      image: json['image'],
    );
  }
}
