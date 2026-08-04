
class ForgotPasswordResponse {
  String message;
  int otp;
  Data data;

  ForgotPasswordResponse({
    required this.message,
    required this.otp,
    required this.data,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) => ForgotPasswordResponse(
    message: json["message"],
    otp: json["otp"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "otp": otp,
    "data": data.toJson(),
  };
}

class Data {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  String phoneNumber;
  String countryCode;
  DateTime registeredDate;
  String nickName;
  DateTime dateOfBirth;
  String address;
  String originOfCountry;
  String userId;
  dynamic passportNumber;
  String isOtpVerified;
  String deviceToken;
  String profilePic;
  dynamic gender;
  String deviceType;
  String isBlock;
  dynamic createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.phoneNumber,
    required this.countryCode,
    required this.registeredDate,
    required this.nickName,
    required this.dateOfBirth,
    required this.address,
    required this.originOfCountry,
    required this.userId,
    required this.passportNumber,
    required this.isOtpVerified,
    required this.deviceToken,
    required this.profilePic,
    required this.gender,
    required this.deviceType,
    required this.isBlock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    phoneNumber: json["phone_number"],
    countryCode: json["country_code"],
    registeredDate: DateTime.parse(json["registeredDate"]),
    nickName: json["nickName"],
    dateOfBirth: DateTime.parse(json["dateOfBirth"]),
    address: json["address"],
    originOfCountry: json["originOfCountry"],
    userId: json["userID"],
    passportNumber: json["passportNumber"],
    isOtpVerified: json["is_otp_verified"],
    deviceToken: json["device_token"],
    profilePic: json["profilePic"],
    gender: json["gender"],
    deviceType: json["device_type"],
    isBlock: json["is_block"],
    createdAt: json["created_at"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "phone_number": phoneNumber,
    "country_code": countryCode,
    "registeredDate": "${registeredDate.year.toString().padLeft(4, '0')}-${registeredDate.month.toString().padLeft(2, '0')}-${registeredDate.day.toString().padLeft(2, '0')}",
    "nickName": nickName,
    "dateOfBirth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
    "address": address,
    "originOfCountry": originOfCountry,
    "userID": userId,
    "passportNumber": passportNumber,
    "is_otp_verified": isOtpVerified,
    "device_token": deviceToken,
    "profilePic": profilePic,
    "gender": gender,
    "device_type": deviceType,
    "is_block": isBlock,
    "created_at": createdAt,
    "updated_at": updatedAt.toIso8601String(),
  };
}
