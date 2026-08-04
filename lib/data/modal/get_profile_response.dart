
class GetProfileResponse {
  String message;
  ProfileData data;

  GetProfileResponse({
    required this.message,
    required this.data,
  });

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) => GetProfileResponse(
    message: json["message"],
    data: ProfileData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class ProfileData {
  int id;
  String name;
  String ?foodType;
  String email;
  dynamic emailVerifiedAt;
  String phoneNumber;
  String countryCode;
  DateTime registeredDate;
  String ? nickName;
  DateTime? dateOfBirth;
  String? dateOfBirthString;
  String ? address;
  String ? unit_number;
  String? originOfCountry;
  String userId;
  String passportNumber;
  String nric_number;
  dynamic isOtpVerified;
  dynamic deviceToken;
  String profilePic;
  dynamic gender;
  dynamic deviceType;
  dynamic otpNumber;
  String isBlock;
  dynamic createdAt;
  dynamic updatedAt;

  /// Games available to play, shown as the badge on the home PLAY button.
  /// Null when the API omits the key — the badge is hidden in that case.
  int? totalGameCount;

  ProfileData({
    required this.id,
    required this.name,
     this.foodType,
    required this.email,
    required this.emailVerifiedAt,
    required this.phoneNumber,
    required this.countryCode,
    required this.registeredDate,
     this.nickName,
     this.dateOfBirth,
     this.dateOfBirthString,
     this.address,
     this.unit_number,
     this.originOfCountry,
    required this.userId,
    required this.passportNumber,
    required this.nric_number,
    required this.isOtpVerified,
    required this.deviceToken,
    required this.profilePic,
    required this.gender,
    required this.deviceType,
    required this.otpNumber,
    required this.isBlock,
    required this.createdAt,
    required this.updatedAt,
    this.totalGameCount,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    id: json["id"],
    name: json["name"],
    foodType: json["foodType"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    phoneNumber: json["phone_number"],
    countryCode: json["country_code"],
    registeredDate: DateTime.parse(json["registeredDate"]),
    nickName: json["nickName"],
    dateOfBirthString: json["dateOfBirth"],
    dateOfBirth: json["dateOfBirth"]!=null? DateTime.parse(json["dateOfBirth"]):null,
    address: json["address"],
    unit_number: json["unit_number"],
    originOfCountry: json["originOfCountry"],
    userId: json["userID"],
    passportNumber: json["passportNumber"],
    nric_number: json["nric_number"],
    isOtpVerified: json["is_otp_verified"],
    deviceToken: json["device_token"],
    profilePic: json["profilePic"],
    gender: json["gender"],
    deviceType: json["device_type"],
    otpNumber: json["otp_number"],
    isBlock: json["is_block"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    totalGameCount: _asInt(json["total_game_count"]),
  );

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "foodType": foodType,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "phone_number": phoneNumber,
    "country_code": countryCode,
    "registeredDate": "${registeredDate.year.toString().padLeft(4, '0')}-${registeredDate.month.toString().padLeft(2, '0')}-${registeredDate.day.toString().padLeft(2, '0')}",
    "nickName": nickName,
    "address": address,
    "unit_number": unit_number,
    "originOfCountry": originOfCountry,
    "userID": userId,
    "passportNumber": passportNumber,
    "nric_number": nric_number,
    "is_otp_verified": isOtpVerified,
    "device_token": deviceToken,
    "profilePic": profilePic,
    "gender": gender,
    "device_type": deviceType,
    "otp_number": otpNumber,
    "is_block": isBlock,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "total_game_count": totalGameCount,
  };
}
