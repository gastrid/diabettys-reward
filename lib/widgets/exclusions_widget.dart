import 'package:flutter/material.dart';



class ExclusionsWidget extends StatefulWidget {
  final Map<String, String> possibleExclusions;
  final List<String>? selectedExclusions;
  final ValueChanged<List<String>> onChanged;

  const ExclusionsWidget({
    Key? key,
    required this.possibleExclusions,
    this.selectedExclusions,
    required this.onChanged,
  }) : super(key: key);

  @override
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
    return Column(
      children: [
        Text('Exclusions'),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 5.0,
          children: widget.possibleExclusions.entries.map((entry) {
            return InputChip(
              label: Text(entry.value),
              selected: widget.selectedExclusions!.contains(entry.key),
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    widget.onChanged([...widget.selectedExclusions!, entry.key]);
                  } else {
                    widget.onChanged(widget.selectedExclusions!.where((element) => element != entry.key).toList());
                  }
                });
              },
            );
          }).toList(),


              // List<Widget>.generate(inputs, (int index) {
              //       return InputChip(
              //         label: Text('Person ${index + 1}'),
              //         selected: selectedIndex == index,
              //         onSelected: (bool selected) {
              //           setState(() {
              //             if (selectedIndex == index) {
              //               selectedIndex = null;
              //             } else {
              //               selectedIndex = index;
              //             }
              //           });
              //         },
              //         onDeleted: () {
              //           setState(() {
              //             inputs = inputs - 1;
              //           });
              //         },
              //       );
              //     }).toList(),
                  ),
      ],
    );
  }
}