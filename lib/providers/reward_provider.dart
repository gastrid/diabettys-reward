import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:diabettys_reward/models/reward.dart';
import 'package:uuid/uuid.dart';
import 'package:diabettys_reward/utils/exceptions.dart';

class RewardProvider extends ChangeNotifier {
  late Box<RewardModel> _rewards;
  final ValueNotifier<int> rewardCount = ValueNotifier(0);


  RewardProvider() {
    _rewards = Hive.box("rewards");
    rewardCount.value = _rewards.values.where((r) => r.isActive == true).length;
  }

  List<RewardModel> getRewards() {
    return _rewards.values.where((r) => r.isActive == true).toList();
  }

  List<RewardModel> getAllrewards() {
    return _rewards.values.toList();
  }

  Future<void> updateRewardName(String uuid, String newName) async {
    final reward = _rewards.get(uuid);
    if (reward != null) {
      reward.name = newName;
      await _rewards.put(uuid, reward);
      notifyListeners();
    }
  }

  Future<void> updateRewardWinProbability(
      String uuid, double newWinProbability) async {
    final reward = _rewards.get(uuid);
    if (reward != null) {
      reward.winProbability = newWinProbability;
      await _rewards.put(uuid, reward);
      notifyListeners();
    }
  }

  Future<void> updateRewardImagePath(String uuid, String newImagePath) async {
    final reward = _rewards.get(uuid);
    if (reward != null) {
      reward.imagePath = newImagePath;
      await _rewards.put(uuid, reward);
      notifyListeners();
    }
  }

  Future<void> updateRewardExclusions(
      String uuid, List<String> newExclusions) async {
    final reward = _rewards.get(uuid);
    if (reward != null) {
      reward.exclusions = newExclusions;
      await _rewards.put(uuid, reward);
      notifyListeners();
    }
  }

  Future<void> addReward(
      String rewardName, double winProbability, List<String> exclusions,
      {String? imagePath}) async {
    if (_rewards.values.any((reward) => reward.name == rewardName)) {
      throw NameDuplicateException(name: rewardName);
    }
    final uuid = const Uuid().v4();
    final reward = RewardModel(
        id: uuid,
        name: rewardName,
        winProbability: winProbability,
        exclusions: exclusions);
    if (imagePath != null) {
      reward.imagePath = imagePath;
    }
    await _rewards.put(uuid, reward);
    rewardCount.value++;
    notifyListeners();
  }

  Future<void> updateReward(String uuid, RewardModel reward) async {
    await _rewards.put(uuid, reward);
    notifyListeners();
  }

  Future<void> deleteReward(String uuid) async {
    final reward = _rewards.get(uuid);
    if (reward != null) {
      reward.isActive = false;
      await _rewards.put(uuid, reward);
      for (var reward in _rewards.values) {
        reward.exclusions.remove(uuid);
        await _rewards.put(reward.id, reward);
      }
      rewardCount.value--;
      notifyListeners();
    }
  }

  Future<void> deleteAllEntries() async {
    _rewards.clear();
    rewardCount.value = 0;
    
    notifyListeners();
  }
}
