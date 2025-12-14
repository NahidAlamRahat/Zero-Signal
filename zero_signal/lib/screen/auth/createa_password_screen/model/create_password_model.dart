class CreatePasswordModel {
  String newPassword;
  String confirmPassword;

  CreatePasswordModel({
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };
  }
}
