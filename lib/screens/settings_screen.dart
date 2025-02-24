import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diabettys_reward/providers/reward_provider.dart';
import 'package:diabettys_reward/widgets/settings_card.dart';
import 'package:diabettys_reward/widgets/add_reward_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}


// PICKUP: pick hierarchy for exclusions
class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<RewardProvider>(
        builder: (context, rewardProvider, child) {
          var rewards = rewardProvider.getRewards();
          Map<String, String> exclusions = rewards.isEmpty ? {} : rewards.map((reward) => {reward.id: reward.name}).reduce((value, element) => value..addAll(element));
          return Column(children: [
            Expanded(
              child: ListView.builder(
                itemCount: rewards.length,
                itemBuilder: (context, index) {
                  var reward = rewards[index];
                  // Create a copy of the exclusions map
                  final rewardExclusions = Map<String, String>.from(exclusions);
                  rewardExclusions.remove(reward.id);
                  return SettingsCard(
                    reward: reward,
                    index: index,
                    exclusions: rewardExclusions,
                    onDelete: _deleteReward,
                    onProbabilityChanged: (newProb) =>
                        {_updateRewardWinProbability(reward.id, newProb)},
                    onExclusionsChanged: (newExclusions) => {
                      _updateRewardExclusions(reward.id, newExclusions)
                    },
                    onNameChanged: (name) => _updateRewardName(reward.id, name),
                  );
                },
              ),
            ),
            OutlinedButton(onPressed: () {
              showDialog(context: context, builder: (context) => AddRewardWidget(
                addReward: _addReward,
                exclusions: exclusions,
              ));
            }, child: const Icon(Icons.add))
          ]);
        },
      ),
    );
  }

  void _updateRewardName(String uuid, String newName) {
    setState(() {
      Provider.of<RewardProvider>(context, listen: false)
          .updateRewardName(uuid, newName);
    });
  }

  void _updateRewardWinProbability(String uuid, double newProbability) {
    setState(() {
      Provider.of<RewardProvider>(context, listen: false)
          .updateRewardWinProbability(uuid, newProbability);
    });
  }

  void _updateRewardExclusions(String uuid, List<String> newExclusions) {
    setState(() {
      final rewards = Provider.of<RewardProvider>(context, listen: false)
          .getRewards();
      for (var id in newExclusions) {
        final newExclusion = rewards.where((r) => r.id == id).first;
        if (newExclusion.exclusions.contains(uuid)) {
            ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Circular exclusion detected'),
            ),
            );
            return;
        }
      }
      Provider.of<RewardProvider>(context, listen: false)
          .updateRewardExclusions(uuid, newExclusions);
    });
  }

  Future<void> _addReward(String rewardName, double winProbability, List<String> exclusions, {String? imagePath}) async {
    await Provider.of<RewardProvider>(context, listen: false)
        .addReward(rewardName, winProbability, exclusions, imagePath: imagePath);
    setState(() {});
  }

  void _deleteReward(String uuid) {
    setState(() {
      Provider.of<RewardProvider>(context, listen: false).deleteReward(uuid);
    });
  }
}
