import 'package:hive/hive.dart';

part 'reward.g.dart';


@HiveType(typeId: 0)
class RewardModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double winProbability; // number from 1 to 10

  @HiveField(3)
  List<String> exclusions;

  @HiveField(4)
  String? imagePath;

  @HiveField(5)
  bool isActive;

  RewardModel({
    required this.id,
    required this.name,
    required this.winProbability,
    required this.exclusions,
    this.imagePath,
    this.isActive = true,
  });

  // Method to check if a reward excludes another reward
  bool excludesReward(String reward) {
    return exclusions.contains(reward);
  }

  // Method to update the win probability
  void updateWinProbability(double newProbability) {
    if (newProbability >= 0.1 && newProbability <= 1) {
      winProbability = newProbability;
    } else {
      throw ArgumentError('Win probability must be between 1 and 10');
    }
  }

  // Method to add an exclusion
  void addExclusion(String exclusion) {
    if (!exclusions.contains(exclusion)) {
      exclusions.add(exclusion);
    }
  }

  // Method to remove an exclusion
  void removeExclusion(String exclusion) {
    exclusions.remove(exclusion);
  }

  // Method to display reward details
  @override
  String toString() {
    return 'RewardModel{name: $name, winProbability: $winProbability, exclusions: $exclusions}';
  }
}
