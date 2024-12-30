import 'package:flutter/material.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/presentation/features/practice/widgets/select_button.dart';

enum SelectionType { single, multiple }

class SelectGroup extends StatefulWidget {
  final List<SelectOption> options;
  final SelectionType selectionType;
  final String? initialValue;
  final List<String>? initialValues;
  final void Function(String?)? onChanged;
  final void Function(List<String>)? onMultiChanged;
  final String? label;

  const SelectGroup({
    super.key,
    required this.options,
    this.selectionType = SelectionType.single,
    this.initialValue,
    this.initialValues,
    this.onChanged,
    this.onMultiChanged,
    this.label,
  }) : assert(
            (selectionType == SelectionType.single && onChanged != null) ||
                (selectionType == SelectionType.multiple && onMultiChanged != null),
            'onChanged must be provided for single selection, onMultiChanged for multiple selection');

  @override
  State<SelectGroup> createState() => _SelectGroupState();
}

class _SelectGroupState extends State<SelectGroup> {
  String? _selectedValue;
  final Set<String> _selectedValues = {};

  @override
  void initState() {
    super.initState();
    if (widget.selectionType == SelectionType.single) {
      _selectedValue = widget.initialValue;
    } else {
      _selectedValues.addAll(widget.initialValues ?? []);
    }
  }

  void _handleSingleSelection(String id) {
    setState(() {
      if (_selectedValue == id) {
        _selectedValue = null;
      } else {
        _selectedValue = id;
      }
    });
    widget.onChanged?.call(_selectedValue);
  }

  void _handleMultiSelection(String id) {
    setState(() {
      if (_selectedValues.contains(id)) {
        _selectedValues.remove(id);
      } else {
        _selectedValues.add(id);
      }
    });
    widget.onMultiChanged?.call(_selectedValues.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.h3_5,
          ),
          const SizedBox(height: 8),
        ],
        ...widget.options.map((option) {
          final isSelected = widget.selectionType == SelectionType.single
              ? _selectedValue == option.id
              : _selectedValues.contains(option.id);

          return SelectButton(
            option: option,
            isSelected: isSelected,
            onPressed: () {
              if (widget.selectionType == SelectionType.single) {
                _handleSingleSelection(option.id);
              } else {
                _handleMultiSelection(option.id);
              }
            },
          );
        }),
      ],
    );
  }
}
