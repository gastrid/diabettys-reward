import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diabettys_reward/utils/constants.dart';

class HistoryProvider extends ChangeNotifier {
  // CHECKIT: may be probematic timeline-wise

  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  HistoryProvider();

  Future<String> getLatestActiveDate() async {
    final prefs = await instanceFuture;
    return prefs.getString('latestActiveDate') ?? activeDatePlaceholder;
  }

  Future<void> setLatestActiveDate(String date) async {
    final prefs = await instanceFuture;
    await prefs.setString('latestActiveDate', date);
  }

  Future<void> clear() async {
    final prefs = await instanceFuture;
    await prefs.clear();
  }
}
