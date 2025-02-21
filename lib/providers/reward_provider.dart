import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:diabettys_reward/models/reward.dart';
import 'package:uuid/uuid.dart';

class RewardProvider extends ChangeNotifier {
  late Box<RewardModel> _rewards;

  RewardProvider() {

      _rewards = Hive.box("rewards");
      // var reward = RewardModel(
      //   id: Uuid().v4(),
      //   name: 'New Reward',
      //   winProbability: 0.5,
      //   exclusions: []
      // );
      // addReward(reward);
  }


  List<RewardModel> getRewards() {
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

  Future<void> updateRewardWinProbability(String uuid, double newWinProbability) async {
    final reward = _rewards.get(uuid);
    if (reward != null) {
      reward.winProbability = newWinProbability;
      await _rewards.put(uuid, reward);
      notifyListeners();
    }
  }

  Future<void> updateRewardExclusions(String uuid, List<String> newExclusions) async {
    final reward = _rewards.get(uuid);
    if (reward != null) {
      reward.exclusions = newExclusions;
      await _rewards.put(uuid, reward);
      notifyListeners();
    }
  }
  Future<void> addReward(String rewardName, double winProbability, List<String> exclusions) async {
    // TODO: add verification of no name duplication
    final uuid = Uuid().v4();
    final reward = RewardModel(
      id: uuid,
      name: rewardName,
      winProbability: winProbability,
      exclusions: exclusions
    );
    await _rewards.put(uuid, reward);
    notifyListeners();
  }

  Future<void> updateReward(String uuid, RewardModel reward) async {
    await _rewards.put(uuid, reward);
    notifyListeners();
  }

  Future<void> deleteReward(String uuid) async {
    await _rewards.delete(uuid);
    notifyListeners();
  }
}
