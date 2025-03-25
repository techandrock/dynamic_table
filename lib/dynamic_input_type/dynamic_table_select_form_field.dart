part of 'dynamic_table_input_type.dart';

class _DynamicTableSelectFormField extends DynamicTableInputType<String> {
  _DynamicTableSelectFormField({
    required this.items,
    this.type = SelectFormFieldType.dropdown,
    this.icon,
    this.changeIcon = false,
    this.labelText,
    this.hintText,
    this.dialogTitle,
    this.dialogSearchHint,
    this.dialogCancelBtn,
    this.enableSearch = false,
    this.style,
    this.decoration,
    this.onChanged,
    this.textColor,
    this.focusedBorderColor,
  });

  final List<Map<String, dynamic>> items;
  final SelectFormFieldType type;
  final Widget? icon;
  final bool changeIcon;
  final String? labelText;
  final String? hintText;
  final String? dialogTitle;
  final String? dialogSearchHint;
  final String? dialogCancelBtn;
  final bool enableSearch;
  final TextStyle? style;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final Color? textColor;
  final Color? focusedBorderColor;

  @override
  Widget displayWidget(String? value) {
    // Find the label for the current value
    String displayText = '';
    if (value != null && value.isNotEmpty) {
      // First try to find the value in the items list
      bool foundInItems = false;
      for (var item in items) {
        if (item['value'].toString() == value) {
          displayText = item['label']?.toString() ?? value;
          foundInItems = true;
          break;
        }
      }
      
      // If not found in items, just display the value directly
      if (!foundInItems) {
        displayText = value;
      }
    } else {
      // Show a placeholder or the first item's label if no value is selected
      displayText = hintText ?? (items.isNotEmpty ? items.first['label']?.toString() ?? '' : '');
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      alignment: Alignment.centerLeft,
      child: Text(
        displayText,
        style: style ?? TextStyle(color: textColor),
      ),
    );
  }

  @override
  Widget editingWidget(String? value, Function(String?, int, int)? onChanged, int row, int column) {
    // Ensure we have unique values in our dropdown items
    final Map<String, DropdownMenuItem<String>> uniqueItems = {};
    
    for (var item in items) {
      final itemValue = item['value'].toString();
      if (!uniqueItems.containsKey(itemValue)) {
        uniqueItems[itemValue] = DropdownMenuItem<String>(
          value: itemValue,
          child: Text(item['label']?.toString() ?? itemValue),
        );
      }
    }
    
    // Check if the value exists directly in the items
    String? selectedValue = null;
    
    if (value != null && value.isNotEmpty) {
      // First check if the value matches any item's 'value' property
      for (var item in items) {
        if (item['value'].toString() == value) {
          selectedValue = value;
          break;
        }
      }
      
      // If not found by value, check if it matches any item's 'label' property
      if (selectedValue == null) {
        for (var item in items) {
          if (item['label'].toString() == value) {
            selectedValue = item['value'].toString();
            break;
          }
        }
      }
      
      // If still not found but the value exists in uniqueItems, use it directly
      if (selectedValue == null && uniqueItems.containsKey(value)) {
        selectedValue = value;
      }
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        style: style ?? TextStyle(color: textColor),
        dropdownColor: Colors.black,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        items: uniqueItems.values.toList(),
        onChanged: (String? newValue) {
          if (onChanged != null) {
            onChanged(newValue, row, column);
          }
        },
      ),
    );
  }

  @override
  void dispose() {}
}

// Custom implementation of SelectFormField
class _CustomSelectFormField extends FormField<String> {
  _CustomSelectFormField({
    Key? key,
    this.type = SelectFormFieldType.dropdown,
    this.controller,
    this.icon,
    this.changeIcon = false,
    this.labelText,
    this.hintText,
    this.dialogTitle,
    this.dialogSearchHint,
    this.dialogCancelBtn,
    this.enableSearch = false,
    this.items,
    String? initialValue,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextStyle? style,
    bool autofocus = false,
    bool readOnly = false,
    this.onChanged,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    bool enabled = true,
  }) : super(
          key: key,
          initialValue: controller != null ? controller.text : (initialValue ?? ''),
          onSaved: onSaved,
          validator: validator,
          enabled: enabled,
          builder: (FormFieldState<String> field) {
            final _CustomSelectFormFieldState state = field as _CustomSelectFormFieldState;

            final InputDecoration effectiveDecoration = (decoration ??
                InputDecoration(
                  labelText: labelText,
                  icon: state._icon ?? icon,
                  hintText: hintText,
                  suffixIcon: Container(
                    width: 10,
                    margin: EdgeInsets.all(0),
                    child: TextButton(
                      onPressed: () {},
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ));

            void onChangedHandler(String value) {
              if (onChanged != null) {
                onChanged(value);
              }
              field.didChange(value);
            }

            Widget buildField(SelectFormFieldType peType) {
              VoidCallback? lfOnTap;

              if (readOnly == false) {
                switch (peType) {
                  case SelectFormFieldType.dialog:
                    lfOnTap = state._showSelectFormFieldDialog;
                    break;
                  default:
                    lfOnTap = state._showSelectFormFieldMenu;
                }
              }

              return TextField(
                controller: state._labelController,
                focusNode: focusNode,
                decoration: effectiveDecoration.copyWith(
                  errorText: field.errorText,
                ),
                style: style,
                textAlign: TextAlign.start,
                autofocus: autofocus,
                readOnly: true,
                onTap: readOnly ? null : lfOnTap,
                enabled: enabled,
              );
            }

            switch (type) {
              case SelectFormFieldType.dialog:
                return buildField(SelectFormFieldType.dialog);
              default:
                return buildField(SelectFormFieldType.dropdown);
            }
          },
        );

  final SelectFormFieldType type;
  final TextEditingController? controller;
  final Widget? icon;
  final bool changeIcon;
  final String? labelText;
  final String? hintText;
  final String? dialogTitle;
  final String? dialogSearchHint;
  final String? dialogCancelBtn;
  final bool enableSearch;
  final ValueChanged<String>? onChanged;
  final List<Map<String, dynamic>>? items;

  @override
  _CustomSelectFormFieldState createState() => _CustomSelectFormFieldState();
}

class _CustomSelectFormFieldState extends FormFieldState<String> {
  TextEditingController _labelController = TextEditingController();
  TextEditingController? _stateController;
  Widget? _icon;
  Map<String, dynamic>? _item = <String, dynamic>{};

  @override
  _CustomSelectFormField get widget => super.widget as _CustomSelectFormField;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _stateController;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _stateController = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }

    initValues();
  }

  void initValues() {
    if (_effectiveController?.text != null &&
        _effectiveController?.text != '') {
      widget.items?.forEach((Map<String, dynamic> lmItem) {
        if (lmItem['value'].toString() == _effectiveController?.text) {
          _item = lmItem;
          return;
        }
      });

      if (_item!.isNotEmpty) {
        _labelController.text =
            _item!['label']?.toString() ?? _item!['value']!.toString();

        if (widget.changeIcon &&
            _item?['icon'] != null) {
          _icon = _item?['icon'];
        }
      }
    }
  }

  @override
  void didUpdateWidget(_CustomSelectFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null) {
        _stateController =
            TextEditingController.fromValue(oldWidget.controller?.value);
      }

      if (widget.controller != null) {
        setValue(widget.controller?.text);

        if (oldWidget.controller == null) {
          _stateController = null;
        }
      }
    }

    if (_effectiveController?.text != null &&
        _effectiveController?.text != '') {
      _item = widget.items?.firstWhere(
        (lmItem) => lmItem['value'].toString() == _effectiveController?.text,
        orElse: () => <String, dynamic>{},
      );

      if (_item!.isNotEmpty) {
        _labelController.text =
            _item!['label']?.toString() ?? _item!['value']!.toString();

        if (widget.changeIcon &&
            _item?['icon'] != null) {
          _icon = _item?['icon'];
        }
      }
    } else {
      _labelController.clear();
      _icon = widget.icon;

      initValues();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController?.text = widget.initialValue ?? '';
    });
  }

  void _handleControllerChanged() {
    if (_effectiveController?.text != value) {
      didChange(_effectiveController?.text);
    }
  }

  void onChangedHandler(String value) {
    widget.onChanged?.call(value);
    didChange(value);
  }

  Future<void> _showSelectFormFieldMenu() async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    String? lvPicked = await showMenu<String>(
      context: context,
      position: position,
      items: widget.items?.map((item) {
        return PopupMenuItem<String>(
          value: item['value'].toString(),
          enabled: item['enable'] ?? true,
          child: Row(
            children: [
              if (item['icon'] != null) item['icon'] else SizedBox(width: 5),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  item['label']?.toString() ?? item['value'].toString(),
                  style: item['textStyle'],
                ),
              ),
            ],
          ),
        );
      }).toList() ?? [],
    );

    if (lvPicked != null && lvPicked != value) {
      _item = widget.items?.firstWhere(
        (lmItem) => lmItem['value'].toString() == lvPicked,
        orElse: () => <String, dynamic>{},
      );

      if (_item!.isNotEmpty) {
        _labelController.text =
            _item!['label']?.toString() ?? _item!['value']!.toString();
        _effectiveController?.text = lvPicked.toString();

        if (widget.changeIcon && _item?['icon'] != null) {
          setState(() {
            _icon = _item?['icon'];
          });
        }

        onChangedHandler(lvPicked);
      }
    }
  }

  Future<void> _showSelectFormFieldDialog() async {
    Map<String, dynamic>? lvPicked = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return _ItemPickerDialog(
          widget.dialogTitle,
          widget.items,
          widget.enableSearch,
          widget.dialogSearchHint,
          widget.dialogCancelBtn,
        );
      },
    );

    if (lvPicked != null) {
      _labelController.text =
          lvPicked['label']?.toString() ?? lvPicked['value']!.toString();
      _effectiveController?.text = lvPicked['value'].toString();

      if (widget.changeIcon && lvPicked['icon'] != null) {
        setState(() {
          _icon = lvPicked['icon'];
        });
      }

      onChangedHandler(lvPicked['value'].toString());
    }
  }
}

class _ItemPickerDialog extends StatefulWidget {
  final String? title;
  final String? searchHint;
  final String? cancelBtn;
  final List<Map<String, dynamic>>? items;
  final bool enableSearch;

  _ItemPickerDialog(
    this.title,
    this.items, [
    this.enableSearch = true,
    this.searchHint = '',
    this.cancelBtn,
  ]);

  @override
  _ItemPickerDialogState createState() => _ItemPickerDialogState();
}

class _ItemPickerDialogState extends State<_ItemPickerDialog> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredItems = [];
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterItems);
    _filteredItems = List.from(widget.items ?? []);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.length < 2) {
        _filteredItems = List.from(widget.items ?? []);
      } else {
        _filteredItems = widget.items?.where((item) {
          final label = (item['label']?.toString() ?? item['value'].toString()).toLowerCase();
          return label.contains(query);
        }).toList() ?? [];
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.enableSearch 
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title ?? 'Select an item'),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: widget.searchHint ?? 'Search...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ],
            )
          : Text(widget.title ?? 'Select an item'),
      content: Container(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          itemCount: _filteredItems.length,
          itemBuilder: (context, index) {
            final item = _filteredItems[index];
            return ListTile(
              leading: item['icon'],
              title: Text(
                item['label']?.toString() ?? item['value'].toString(),
                style: item['textStyle'],
              ),
              enabled: item['enable'] ?? true,
              onTap: () => Navigator.of(context).pop(item),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelBtn ?? 'Cancel'),
        ),
      ],
    );
  }
}