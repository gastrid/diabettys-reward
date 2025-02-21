import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diabettys_reward/providers/reward_provider.dart';
import 'package:diabettys_reward/models/reward.dart';
import 'package:diabettys_reward/widgets/settings_card.dart';
import 'package:diabettys_reward/widgets/add_reward_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    print('SettingsScreen built');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<RewardProvider>(
        builder: (context, rewardProvider, child) {
          var rewards = rewardProvider.getRewards();
          var exclusions = rewardProvider.getExclusions();
          return Column(children: [
            ListView.builder(
              itemCount: rewards.length,
              itemBuilder: (context, index) {
                var reward = rewards[index];
                return SettingsCard(
                  reward: reward,
                  index: index,
                  exclusions: exclusions,
                  onProbabilityChanged: (newProb) =>
                      {_updateRewardWinProbability(reward.id, newProb)},
                  onExclusionsChanged: (newExclusions) => {
                    _updateRewardExclusions(reward.id, newExclusions)
                  },
                  onNameChanged: (name) => _updateRewardName(reward.id, name),
                );
              },
            ),
            OutlinedButton(onPressed: () {
              showDialog(context: context, builder: (context) => AddRewardWidget(
                addReward: _addReward,
                exclusions: exclusions,
              ));
            }, child: Icon(Icons.add))
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
      Provider.of<RewardProvider>(context, listen: false)
          .updateRewardExclusions(uuid, newExclusions);
    });
  }


  void _addReward(String rewardName, double winProbability, List<String> exclusions) {
    setState(() {
      Provider.of<RewardProvider>(context, listen: false)
          .addReward(rewardName, winProbability, exclusions);
    });


  }
}
