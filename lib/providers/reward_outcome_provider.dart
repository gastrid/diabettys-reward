import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:diabettys_reward/models/reward_outcome.dart';


class RewardOutcomeProvider extends ChangeNotifier {
  late Box _rewardOutcomes;

  RewardOutcomeProvider() {
  }


  List<RewardOutcomeModel> getRewardOutcomes() {
    return List<RewardOutcomeModel>.from(
        _rewardOutcomes.get("rewardOutcomes", defaultValue: []));
  }

  Future<void> addRewardOutcome(RewardOutcomeModel rewardOutcome) async {
    await _rewardOutcomes.add(rewardOutcome);
    notifyListeners();
  }

  Future<void> updateRewardOutcome(int index, RewardOutcomeModel rewardOutcome) async {
    await _rewardOutcomes.putAt(index, rewardOutcome);
    notifyListeners();
  }

  Future<void> deleteRewardOutcome(int index) async {
    await _rewardOutcomes.deleteAt(index);
    notifyListeners();
  }
}
