import 'package:dynamic_table/dynamic_table.dart';
import 'package:flutter/material.dart';

class DynamicTableDateTimeInput extends DynamicTableInputType<DateTime> {
  final BuildContext context;
  final DateTime initialDate;
  final DateTime lastDate;
  final String Function(DateTime)? formatDateTime;
  final InputDecoration? decoration;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final MouseCursor? mouseCursor;

  DynamicTableDateTimeInput({
    required this.context,
    required this.initialDate,
    required this.lastDate,
    this.formatDateTime,
    this.decoration = const InputDecoration(
      border: OutlineInputBorder(),
      suffixIcon: Icon(Icons.calendar_today),
      labelText: "Select date and time",
    ),
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.mouseCursor,
  });

  String _formatDateTime(DateTime dateTime) {
    if (formatDateTime != null) {
      return formatDateTime!(dateTime);
    }
    
    final String date = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    final String time = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    return "$date $time";
  }

  @override
  Widget editingWidget(DateTime? value, Function(DateTime? value, int row, int column)? onChanged, int row, int column) {
    final TextEditingController controller = TextEditingController(
      text: value != null ? _formatDateTime(value) : '',
    );

    return TextFormField(
      controller: controller,
      decoration: decoration,
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: autofocus,
      readOnly: true,
      mouseCursor: mouseCursor ?? SystemMouseCursors.click,
      onTap: () async {
        // Show date picker
        final DateTime? date = await showDatePicker(
          context: context,
          initialDate: value ?? initialDate,
          firstDate: DateTime(1900),
          lastDate: lastDate,
        );
        
        if (date != null) {
          // Show time picker
          final TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(value ?? initialDate),
          );
          
          if (time != null) {
            // Combine date and time
            final DateTime dateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            
            // Update controller text
            controller.text = _formatDateTime(dateTime);
            
            // Call onChanged
            onChanged?.call(dateTime, row, column);
          }
        }
      },
    );
  }

  @override
  Widget displayWidget(DateTime? value) {
    return Text(
      value != null ? _formatDateTime(value) : DynamicTableInputType.emptyValue,
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textAlign: textAlign,
    );
  }

  @override
  void dispose() {}
}