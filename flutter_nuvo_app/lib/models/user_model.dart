class User {
  final int? id;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String role;
  final String? phoneNumber;

  User({
    this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.role,
    this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'role': role,
      'phoneNumber': phoneNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
