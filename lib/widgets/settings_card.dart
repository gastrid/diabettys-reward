import 'package:diabettys_reward/widgets/probability_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:diabettys_reward/models/reward.dart';
import 'package:diabettys_reward/widgets/exclusions_widget.dart';


typedef DeleteRewardCallback = void Function(
    String uuid);
class SettingsCard extends StatefulWidget {
  final RewardModel reward;
  final int index;
  final Map<String, String> exclusions;


  final DeleteRewardCallback onDelete;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<double> onProbabilityChanged;
  final ValueChanged<List<String>> onExclusionsChanged;

  const SettingsCard({
    super.key,
    required this.reward,
    required this.index,
    required this.exclusions,
    required this.onDelete,
    required this.onNameChanged,
    required this.onProbabilityChanged,
    required this.onExclusionsChanged,
  });
  
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
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.reward.name,
                  style: Theme.of(context).textTheme.titleMedium),
                IconButton(onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm Deletion"),
                        content: const Text("Are you sure you want to delete this reward?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.onDelete(widget.reward.id);
                              Navigator.of(context).pop();
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
              }, icon: const Icon(Icons.delete),
              color: Colors.red),
              ],
            ),
            ProbabilitySlider(
              initialProbability: widget.reward.winProbability,
              onChanged: widget.onProbabilityChanged,
            ),
            ExclusionsWidget(
              possibleExclusions: widget.exclusions,
              selectedExclusions: widget.reward.exclusions,
              onChanged: widget.onExclusionsChanged,
            ),


          ],
        ),
      ),
    );
  }
}
