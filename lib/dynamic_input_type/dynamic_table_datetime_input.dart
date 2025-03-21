part of 'dynamic_table_input_type.dart';

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
  final bool timePicker;
  final TimePickerEntryMode timePickerEntryMode;

  DynamicTableDateTimeInput({
    required this.context,
    required this.initialDate,
    required this.lastDate,
    this.formatDateTime,
    this.decoration = const InputDecoration(
      border: OutlineInputBorder(),
      suffixIcon: Icon(Icons.calendar_today),
      labelText: "Enter a date/time",
    ),
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.mouseCursor,
    this.timePicker = false,
    this.timePickerEntryMode = TimePickerEntryMode.dial,
  });

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return DynamicTableInputType.emptyValue;
    if (formatDateTime != null) return formatDateTime!(dateTime);
    
    // Default format: DD-MM-YYYY HH:MM if showTimePicker is true, otherwise DD-MM-YYYY
    String dateStr = "${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}-${dateTime.year}";
    if (timePicker) {
      String timeStr = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      return "$dateStr $timeStr";
    }
    return dateStr;
  }

  @override
  Widget displayWidget(DateTime? value) {
    return Text(
      _formatDateTime(value),
      style: style,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textAlign: textAlign,
    );
  }

  @override
  Widget editingWidget(DateTime? value, Function(DateTime? value, int row, int column)? onChanged, int row, int column) {
    // Create a ValueNotifier to track changes
    final ValueNotifier<DateTime?> dateTimeValue = ValueNotifier<DateTime?>(value);
    
    return ValueListenableBuilder<DateTime?>(
      valueListenable: dateTimeValue,
      builder: (context, currentValue, child) {
        return Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () async {
                  // Date picker
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: currentValue ?? initialDate,
                    firstDate: DateTime(1900),
                    lastDate: lastDate,
                  );
                  
                  if (pickedDate != null) {
                    // Use the time from the existing value or current time
                    final DateTime resultDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      currentValue?.hour ?? DateTime.now().hour,
                      currentValue?.minute ?? DateTime.now().minute,
                    );
                    
                    // Update the ValueNotifier to trigger UI update
                    dateTimeValue.value = resultDateTime;
                    
                    // Call onChanged to update parent
                    onChanged?.call(resultDateTime, row, column);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${currentValue != null ? "${currentValue.month.toString().padLeft(2, '0')}-${currentValue.day.toString().padLeft(2, '0')}-${currentValue.year}" : "Select date"}",
                          style: style,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
            ),
            
            if (timePicker) const SizedBox(width: 8),
            
            // Separate time picker button
            if (timePicker)
              TextButton(
                onPressed: () async {
                  if (currentValue == null) {
                    // Show a message that date must be selected first
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a date first")),
                    );
                    return;
                  }
                  
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: currentValue.hour, minute: currentValue.minute),
                    initialEntryMode: timePickerEntryMode,
                  );
                  
                  if (pickedTime != null) {
                    final DateTime resultDateTime = DateTime(
                      currentValue.year,
                      currentValue.month,
                      currentValue.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    
                    // Update the ValueNotifier to trigger UI update
                    dateTimeValue.value = resultDateTime;
                    
                    // Call onChanged to update parent
                    onChanged?.call(resultDateTime, row, column);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${currentValue != null ? "${currentValue.hour.toString().padLeft(2, '0')}:${currentValue.minute.toString().padLeft(2, '0')}" : "Select time"}",
                        style: style,
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // No resources to dispose
  }
}