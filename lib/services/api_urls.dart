
class ApiUrls {
  // Base URLs
  // ===============================
  // static const String baseUrl = 'https://api.eliteerp.com.pk';
  static const String baseUrl = 'https://eliteerp.api.tracktheorder.com';
  // static const String socketUrl = 'http://103.62.234.114:3000/';

  // ===============================
  // Authentication APIs
  // ===============================
  static const String login = '$baseUrl/hr/auth/login';
  static const String logout = '$baseUrl/hr/auth/logout';
  static const String profile = '$baseUrl/hr/auth/profile';

  // ===============================
  // Attendance APIs
  // ===============================
  static const String retailLog = '$baseUrl/hr/attendance/retail-log';
  static const String retailLogConfig = '$baseUrl/hr/attendance/retail-log-config';
  static const String markAttendance = '$baseUrl/hr/attendance/mark';
  static const String todayAttendanceStatus = '$baseUrl/hr/attendance/today-status';
  static const String attendanceHistory = '$baseUrl/hr/attendance/history';

  // ===============================
  // Leave APIs
  // ===============================
  static const String applyLeave = '$baseUrl/hr/leave/apply';
  static const String myLeaveRequests = '$baseUrl/hr/leave/my-requests';
  static const String leaveStatusTypes = '$baseUrl/hr/leave/status-types';
  static const String pendingLeaveForApproval = '$baseUrl/hr/leave/pending-for-approval';
  static const String finalPendingLeave = '$baseUrl/hr/leave/final-pending';
  static const String changeLeaveStatus = '$baseUrl/hr/leave/change-status';
  static const String finalChangeLeaveStatus = '$baseUrl/hr/leave/final-change-status';

  // ===============================
  // Branch APIs
  // ===============================
  static const String managerBranches = '$baseUrl/hr/branch/manager-branches';


 }



