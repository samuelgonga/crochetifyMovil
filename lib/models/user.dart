class User {
  final String name;
  final String email;
  final String password;
  final String image;
  final List<Address> address;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.image,
    required this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      image: json['image'],
      address: (json['address'] as List)
          .map((addressJson) => Address.fromJson(addressJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'image': image,
      'address': address.map((address) => address.toJson()).toList(),
    };
  }
}

class Address {
  final String name;
  final String address;
  final String colonia;
  final String country;
  final String phone;  // Cambiado de int a String
  final bool main;

  Address({
    required this.name,
    required this.address,
    required this.colonia,
    required this.country,
    required this.phone,
    required this.main,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      name: json['name'],
      address: json['address'],
      colonia: json['colonia'],
      country: json['country'],
      phone: json['phone'].toString(),
      main: json['main'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'colonia': colonia,
      'country': country,
      'phone': phone,
      'main': main,
    };
  }
}
