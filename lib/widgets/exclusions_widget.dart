import 'package:flutter/material.dart';

class ExclusionsWidget extends StatefulWidget {
  final Map<String, String> possibleExclusions;
  final List<String>? selectedExclusions;
  final ValueChanged<List<String>> onChanged;

  const ExclusionsWidget({
    super.key,
    required this.possibleExclusions,
    this.selectedExclusions,
    required this.onChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExclusionsWidgetState createState() => _ExclusionsWidgetState();
}

class _ExclusionsWidgetState extends State<ExclusionsWidget> {
  // late Map<String, String> _currentExclusions;

  @override
  void initState() {
    super.initState();
    // _currentExclusions = widget.possibleExclusions;
  }

  @override
  Widget build(BuildContext context) {
    List<String> selectedExclusions =
        widget.selectedExclusions != null ? widget.selectedExclusions! : [];
    return Row(
      children: [
        Text('Exclusions',
        style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Wrap(
            spacing: 5.0,
            children: widget.possibleExclusions.entries.map((entry) {
              return InputChip(
                label: Text(entry.value),
                visualDensity: VisualDensity.compact,
                labelPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                selected: selectedExclusions.contains(entry.key),
                showCheckmark: false,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      widget.onChanged([...selectedExclusions, entry.key]);
                    } else {
                      widget.onChanged(selectedExclusions
                          .where((element) => element != entry.key)
                          .toList());
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
