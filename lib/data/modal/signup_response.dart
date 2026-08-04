
class SignupResponse {
  String message;
  String otp;
  SignUpData data;

  SignupResponse({
    required this.message,
    required this.otp,
    required this.data,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) => SignupResponse(
    message: json["message"],
    otp: json["otp"],
    data: SignUpData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "otp": otp,
    "data": data.toJson(),
  };
}

class SignUpData {
  String name;
  String email;
  String password;
  String phoneNumber;
  String countryCode;
  DateTime registeredDate;

  SignUpData({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.countryCode,
    required this.registeredDate,
  });

  factory SignUpData.fromJson(Map<String, dynamic> json) => SignUpData(
    name: json["name"],
    email: json["email"],
    password: json["password"],
    phoneNumber: json["phone_number"],
    countryCode: json["country_code"],
    registeredDate: DateTime.parse(json["registeredDate"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "phone_number": phoneNumber,
    "country_code": countryCode,
    "registeredDate": "${registeredDate.year.toString().padLeft(4, '0')}-${registeredDate.month.toString().padLeft(2, '0')}-${registeredDate.day.toString().padLeft(2, '0')}",
  };
}

class LogoutResponse {
  String? message;

  LogoutResponse({this.message});

  LogoutResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
