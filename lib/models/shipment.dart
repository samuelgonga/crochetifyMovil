class Shipment {
  final int idShipment;
  final int idOrder; // Nuevo campo para asociar con una orden
  final int status;
  final DateTime? shippingDay;
  final DateTime? deliveryDay;

  Shipment({
    required this.idShipment,
    required this.idOrder, // Nuevo campo
    required this.status,
    required this.shippingDay,
    this.deliveryDay,
  });

  // Método copyWith
  Shipment copyWith({
    int? idShipment,
    int? idOrder,
    int? status,
    DateTime? shippingDay,
    DateTime? deliveryDay,
  }) {
    return Shipment(
      idShipment: idShipment ?? this.idShipment,
      idOrder: idOrder ?? this.idOrder, // Actualiza el nuevo campo
      status: status ?? this.status,
      shippingDay: shippingDay ?? this.shippingDay,
      deliveryDay: deliveryDay ?? this.deliveryDay,
    );
  }

  // Método para mapear desde JSON
  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      idShipment: json['idShipment'],
      idOrder: json['idOrder'], // Mapea este campo desde el JSON
      status: json['status'],
      shippingDay: json['shipping_day'] != null
          ? DateTime(
              json['shipping_day'][0],
              json['shipping_day'][1],
              json['shipping_day'][2],
            )
          : null,
      deliveryDay: json['delivery_day'] != null
          ? DateTime(
              json['delivery_day'][0],
              json['delivery_day'][1],
              json['delivery_day'][2],
            )
          : null,
    );
  }

  // Método para mapear a JSON (opcional si es necesario)
  Map<String, dynamic> toJson() {
    return {
      'idShipment': idShipment,
      'idOrder': idOrder, // Incluye el nuevo campo
      'status': status,
      'shipping_day': shippingDay != null
          ? [
              shippingDay!.year,
              shippingDay!.month,
              shippingDay!.day,
            ]
          : null,
      'delivery_day': deliveryDay != null
          ? [
              deliveryDay!.year,
              deliveryDay!.month,
              deliveryDay!.day,
            ]
          : null,
    };
  }
}
