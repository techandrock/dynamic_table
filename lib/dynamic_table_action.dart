import 'package:flutter/material.dart';

/// This is the actions which you see on the last column of [DynamicTable]
@immutable
abstract class DynamicTableAction {
  /// The [icon] which will be displayed on the last column of [DynamicTable] as action.
  ///
  /// You can use [Icon] or [Image] or any other widget.
  final Widget icon;

  /// The [onPressed] function which will be called when the user clicks on the [icon].
  final void Function()? onPressed;

  /// If [showAlways] is true, the [icon] will be displayed on the last column of [DynamicTable] as action.
  ///
  final bool showAlways;

  /// If [showOnlyOnEditing] is true, the [icon] will be displayed on the last column of [DynamicTable] as action only when the [DynamicTableDataRow.isEditing] is in editing mode.
  final bool showOnlyOnEditing;

  /// This is the actions which you see on the last column of [DynamicTable]

  const DynamicTableAction(
      {required this.icon,
      this.onPressed,
      this.showAlways = false,
      this.showOnlyOnEditing = true})
      : assert(!(showAlways && showOnlyOnEditing),
            'showAlways and showOnlyOnEditing cannot be true at the same time');
}

class DynamicTableActionEdit extends DynamicTableAction {
  DynamicTableActionEdit(
      {Widget? icon,
      super.onPressed,
      super.showAlways,
      super.showOnlyOnEditing = false,
      Color? color})
      : super(
            icon: icon ?? Icon(Icons.edit, color: color));
}

class DynamicTableActionSave extends DynamicTableAction {
  DynamicTableActionSave(
      {Widget? icon,
      super.onPressed,
      super.showAlways,
      super.showOnlyOnEditing = true,
      Color? color})
      : super(
            icon: icon ?? Icon(Icons.save, color: color));
}

class DynamicTableActionCancel extends DynamicTableAction {
  DynamicTableActionCancel(
      {Widget? icon,
      super.onPressed,
      super.showAlways,
      super.showOnlyOnEditing = true,
      Color? color})
      : super(
            icon: icon ?? Icon(Icons.cancel, color: color));
}

class DynamicTableActionDelete extends DynamicTableAction {
  DynamicTableActionDelete(
      {Widget? icon,
      super.onPressed,
      super.showAlways = true,
      super.showOnlyOnEditing = false,
      Color? color})
      : super(
            icon: icon ?? Icon(Icons.delete, color: color));
}
