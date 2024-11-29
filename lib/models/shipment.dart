class Shipment {
  final int idShipment;
  final int status;
  final DateTime? shippingDay;
  final DateTime? deliveryDay;

  Shipment({
    required this.idShipment,
    required this.status,
    required this.shippingDay,
    this.deliveryDay,
  });

  // Método copyWith
  Shipment copyWith({
    int? idShipment,
    int? status,
    DateTime? shippingDay,
    DateTime? deliveryDay,
  }) {
    return Shipment(
      idShipment: idShipment ?? this.idShipment,
      status: status ?? this.status,
      shippingDay: shippingDay ?? this.shippingDay,
      deliveryDay: deliveryDay ?? this.deliveryDay,
    );
  }

  // Método para mapear desde JSON
  factory Shipment.fromJson(Map<String, dynamic> json) {
    return Shipment(
      idShipment: json['idShipment'],
      status: json['status'],
      shippingDay: DateTime(
        json['shipping_day'][0],
        json['shipping_day'][1],
        json['shipping_day'][2],
      ),
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
