import 'package:hive/hive.dart';

part 'reward_outcome.g.dart';


@HiveType(typeId: 1)
class RewardOutcomeModel {
  @HiveField(0)
  final String rewardName;

  @HiveField(1)
  final bool won;

  @HiveField(2)
  final DateTime date;

  RewardOutcomeModel({
    required this.rewardName,
    required this.won,
    required this.date,
  });
}
