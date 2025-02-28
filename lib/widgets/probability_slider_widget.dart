import 'package:flutter/material.dart';
import 'package:diabettys_reward/utils/constants.dart';



class ProbabilitySlider extends StatefulWidget {
  final double initialProbability;
  final ValueChanged<double> onChanged;

  const ProbabilitySlider({
    super.key,
    required this.initialProbability,
    required this.onChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ProbabilitySliderState createState() => _ProbabilitySliderState();
}

class _ProbabilitySliderState extends State<ProbabilitySlider> {
  late double _currentProbability;

  @override
  void initState() {
    super.initState();
    _currentProbability = widget.initialProbability;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
        'Probability',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      Slider(
        value: _currentProbability,
        min: ProbabilityConfig.lowerBound,
        max: ProbabilityConfig.upperBound,
        divisions: ProbabilityConfig.divisions,
        label: _currentProbability.toStringAsFixed(1),
        onChanged: (value) {
        setState(() {
          _currentProbability = value;
        });
        widget.onChanged(value);
        },
      ),
      ],
    );
  }
}