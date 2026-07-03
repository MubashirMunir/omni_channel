import 'package:get/get.dart';

class StatsController extends GetxController {
  /// STATS DATA
  final stats = {
    "messages": 12450,
    "chats": 1240,
    "unread": 320,
    "resolved": 8900,
  };

  final sideStats = [
    {"title": "Top Channel", "value": "WhatsApp", "color": "green"},
    {"title": "Conversion Rate", "value": "78%", "color": "blue"},
    {"title": "Response Time", "value": "1m 20s", "color": "orange"},
  ];

  /// Simulate API refresh
  void refreshStats() {
    stats["messages"] = stats["messages"]! + 10;
    update();
  }
}