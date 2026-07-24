
class LoginModel {
  String? message;
  LoginData? data;

  LoginModel({this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }


}

class LoginData {
  String? token;
  String? expiresUtc;
  int? rawUserId;
  int? branchId;
  int? employeeId;
  String? userName;
  String? mobileUserName;
  String? employeeName;
  String? regNo;
  bool? isManager;
  bool? isFinalApprover;
  String? userType;
  int? zone;
  int? allowedLeaves;
  bool? allowedWot;
  bool? allowedRot;
  bool? deviceActive;
  int? companyId;
  String? branchName;
  double? latitude;
  double? longitude;
  double? radius;

  LoginData({
    this.token,
    this.expiresUtc,
    this.rawUserId,
    this.branchId,
    this.employeeId,
    this.userName,
    this.mobileUserName,
    this.employeeName,
    this.regNo,
    this.isManager,
    this.isFinalApprover,
    this.userType,
    this.zone,
    this.allowedLeaves,
    this.allowedWot,
    this.allowedRot,
    this.deviceActive,
    this.companyId,
    this.branchName,
    this.latitude,
    this.longitude,
    this.radius,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    token = json['Token'];
    expiresUtc = json['ExpiresUtc'];
    rawUserId = json['Raw_User_Id'];
    branchId = json['Branch_Id'];
    employeeId = json['Employee_Id'];
    userName = json['User_Name'];
    mobileUserName = json['Mobile_User_Name'];
    employeeName = json['Employee_Name'];
    regNo = json['Reg_No'];
    isManager = json['Is_Manager'];
    isFinalApprover = json['Is_Final_Approver'];
    userType = json['User_Type'];
    zone = json['Zone'];
    allowedLeaves = json['Allowed_Leaves'];
    allowedWot = json['Allowed_Wot'];
    allowedRot = json['Allowed_Rot'];
    deviceActive = json['Device_Active'];
    companyId = json['Company_Id'];
    branchName = json['Branch_Name'];
    latitude = (json['Latitude'] as num?)?.toDouble();
    longitude = (json['Longitude'] as num?)?.toDouble();
    radius = (json['Radius'] as num?)?.toDouble();
  }

}