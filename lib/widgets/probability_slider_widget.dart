import 'package:flutter/material.dart';
import 'package:diabettys_reward/utils/values.dart';



class ProbabilitySlider extends StatefulWidget {
  final double initialProbability;
  final ValueChanged<double> onChanged;

  const ProbabilitySlider({
    Key? key,
    required this.initialProbability,
    required this.onChanged,
  }) : super(key: key);

  @override
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
    return Slider(
      value: _currentProbability,
      min: ProbabilityConfig.lowerBound,
      max: ProbabilityConfig.upperBound,
      divisions: ProbabilityConfig.divisions,
      label: _currentProbability .toStringAsFixed(0) + '%',
      onChanged: (value) {
        setState(() {
          _currentProbability = value;
        });
        widget.onChanged(value);
      },
    );
  }
}