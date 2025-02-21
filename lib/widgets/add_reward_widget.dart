import 'package:flutter/material.dart';
import 'package:diabettys_reward/widgets/probability_slider_widget.dart';
import 'package:diabettys_reward/widgets/exclusions_widget.dart';

typedef AddRewardCallback = void Function(
    String rewardName, double winProbability, List<String> exclusions);

class AddRewardWidget extends StatefulWidget {
  final AddRewardCallback addReward;
  final Map<String, String> exclusions;

  AddRewardWidget({required this.addReward, required this.exclusions});

  @override
  _AddRewardWidgetState createState() => _AddRewardWidgetState();
}

class _AddRewardWidgetState extends State<AddRewardWidget> {
  @override
  final _formKey = GlobalKey<FormState>();
  String _rewardName = '';
  double _winProbability = 0.5;
  List<String> _exclusions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reward'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Reward Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reward name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _rewardName = value!;
                },
              ),
              SizedBox(height: 20),
              ProbabilitySlider(
                  initialProbability: 0.5,
                  onChanged: (value) {
                    setState(() {
                      _winProbability = value;
                    });
                  }),
              SizedBox(height: 20),
              ExclusionsWidget(
                  possibleExclusions: widget.exclusions,
                  onChanged: (exclusions) {
                    setState(() {
                      _exclusions = exclusions;
                    });
                  }),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Handle the form submission logic here
                    print('Reward Name: $_rewardName');
                    print('Win Probability: $_winProbability');
                    widget.addReward(_rewardName, _winProbability, _exclusions);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
