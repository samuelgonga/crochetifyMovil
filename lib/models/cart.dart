class CartProduct {
  final int stockId;
  final String color;
  int quantity;
  final Product? product; // Información del producto
  final List<ImageData> images; // Lista de imágenes

  CartProduct({
    required this.stockId,
    required this.color,
    required this.quantity,
    required this.product,
    required this.images,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      stockId: json['stockId'] ?? 0,
      color: json['color'] ?? '',
      quantity: json['quantity'] ?? 0,
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      images: (json['images'] as List?)
              ?.map((image) => ImageData.fromJson(image))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stockId': stockId,
      'color': color,
      'quantity': quantity,
      'product': product?.toJson(),
      'images': images.map((image) => image.toJson()).toList(),
    };
  }

  /// Método copyWith para crear una nueva instancia basada en la existente
  CartProduct copyWith({
    int? stockId,
    String? color,
    int? quantity,
    Product? product,
    List<ImageData>? images,
  }) {
    return CartProduct(
      stockId: stockId ?? this.stockId,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
      images: images ?? this.images,
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
      idProduct: json['idProduct'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? false,
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

class ImageData {
  final int idImage;
  final String image; // Imagen codificada en base64

  ImageData({
    required this.idImage,
    required this.image,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      idImage: json['idImage'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idImage': idImage,
      'image': image,
    };
  }
}

class Cart {
  final int idCart;
  double total;
  final List<CartProduct> cartProducts;

  Cart({
    required this.idCart,
    required this.total,
    required this.cartProducts,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      idCart: json['idCart'] ?? 0,
      total: (json['total'] ?? 0.0).toDouble(),
      cartProducts: (json['cartProducts'] as List?)
              ?.map((item) => CartProduct.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCart': idCart,
      'total': total,
      'cartProducts': cartProducts.map((item) => item.toJson()).toList(),
    };
  }

  /// Método copyWith para crear una nueva instancia basada en la existente
  Cart copyWith({
    int? idCart,
    double? total,
    List<CartProduct>? cartProducts,
  }) {
    return Cart(
      idCart: idCart ?? this.idCart,
      total: total ?? this.total,
      cartProducts: cartProducts ?? this.cartProducts,
    );
  }
}
