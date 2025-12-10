class VerifyOtpModel {
  String email;
  int otp;

  VerifyOtpModel({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "oneTimeCode": otp,
    };
  }
}
