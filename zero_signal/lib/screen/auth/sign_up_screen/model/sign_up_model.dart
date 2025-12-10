class RegisterRequestModel {
  final String name;
  final String email;
  final String dateOfBirth;
  final String password;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.dateOfBirth,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "date_of_birth": dateOfBirth,
      "password": password,
    };
  }
}
