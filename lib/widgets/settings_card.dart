import 'package:diabettys_reward/widgets/probability_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diabettys_reward/models/reward.dart';
import 'package:diabettys_reward/providers/reward_provider.dart';
import 'add_reward_widget.dart';

class SettingsCard extends StatefulWidget {
  final RewardModel reward;
  final int index;

  final ValueChanged<String> onNameChanged;
  final ValueChanged<double> onProbabilityChanged;
  final ValueChanged<List<String>> onExclusionsChanged;

  const SettingsCard({
    Key? key,
    required this.reward,
    required this.index,
    required this.onNameChanged,
    required this.onProbabilityChanged,
    required this.onExclusionsChanged,
  }) : super(key: key);
  
  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          // TODO update name option
          Text(widget.reward.name),
          ProbabilitySlider(
            initialProbability: widget.reward.winProbability,
            onChanged: widget.onProbabilityChanged,
          )

        ],
      ),
    );
  }
}
