import 'package:flutter/material.dart';
import 'package:diabettys_reward/widgets/probability_slider_widget.dart';
import 'package:diabettys_reward/widgets/exclusions_widget.dart';
import 'package:diabettys_reward/utils/exceptions.dart';
import 'package:diabettys_reward/widgets/image_upload_widget.dart';

typedef AddRewardCallback = Future<void> Function(
    String rewardName, double winProbability, List<String> exclusions, {String? imagePath} );

class AddRewardWidget extends StatefulWidget {
  final AddRewardCallback addReward;
  final Map<String, String> exclusions;

  const AddRewardWidget(
      {super.key, required this.addReward, required this.exclusions});

  @override
  // ignore: library_private_types_in_public_api
  _AddRewardWidgetState createState() => _AddRewardWidgetState();
}

class _AddRewardWidgetState extends State<AddRewardWidget> {
  final _formKey = GlobalKey<FormState>();
  String _rewardName = '';
  double _winProbability = 0.5;
  List<String> _exclusions = [];
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reward'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Reward Name'),
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
              const SizedBox(height: 20),
              ProbabilitySlider(
                  initialProbability: 0.5,
                  onChanged: (value) {
                    setState(() {
                      _winProbability = value;
                    });
                  }),
              const SizedBox(height: 20),
              ExclusionsWidget(
                  possibleExclusions: widget.exclusions,
                  selectedExclusions: _exclusions,
                  onChanged: (exclusions) {
                    setState(() {
                      _exclusions = exclusions;
                    });
                  }),
              ImageUploadWidget(
                onChanged: (imagePath) {
                    setState(() {
                      _imagePath = imagePath;
                    });
                }
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    try {
                      await widget.addReward(
                          _rewardName, _winProbability, _exclusions, imagePath: _imagePath);
                      Navigator.of(context).pop();
                    } on NameDuplicateException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.message),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
