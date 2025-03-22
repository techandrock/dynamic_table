import 'dart:math';

import 'package:dynamic_table/dynamic_table.dart';
import 'package:flutter/material.dart';

import 'dummy_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tableKey = GlobalKey<DynamicTableState>();
  var myData = dummyData.toList();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Dynamic Table Example"),
        ),
        body: Builder(builder: (context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: DynamicTable(
              dividerColor: Colors.red,
              dividerSpace: 10,
              dividerThickness: 0.5,
              backgroundColor: Colors.green,
              key: tableKey,
              header: const Text("Person Table"),
              // paginationButtonTextColor: Colors.white,
              paginationButtonColor: Colors.white,
              editButtonColor: Colors.black,
              saveButtonColor: Colors.purple,
              deleteButtonColor: Colors.red,
              cancelButtonColor: Colors.grey,
              onAddRowButtonPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  int numberOfRows = 1; // Default value
                  return AlertDialog(
                    title: const Text("Add Rows"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Select the number of rows to add:"),
                        Slider(
                          value: numberOfRows.toDouble(),
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: numberOfRows.toString(),
                          onChanged: (double value) {
                            setState(() {
                              numberOfRows = value.toInt();
                            });
                          },
                        ),
                        Text("Number of rows: $numberOfRows"),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          for (int i = 0; i < numberOfRows; i++) {
                            // Add your logic to add a new row here
                            // For example, you might want to call a method to add a row
                            // addRow();
                            tableKey.currentState?.addRow(addRowToEnd: true);
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  );
                },
              );
              },
              onRowEdit: (index, row) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Row Edited index:$index row:$row"),
                  ),
                );
                myData[index] = row;
                
                return true;
              },

              onRowDelete: (index, row) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Row Deleted index:$index row:$row"),
                  ),
                );
                myData.removeAt(index);
                return true;
              },
              onRowSave: (index, old, newValue) {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content:
                //         Text("Row Saved index:$index old:$old new:$newValue"),
                //   ),
                // );
                if (newValue[0] == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Name cannot be null"),
                    ),
                  );
                  return null;
                }

                if (newValue[0].toString().length < 3) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Name must be atleast 3 characters long"),
                    ),
                  );
                  return null;
                }
                if (newValue[0].toString().length > 20) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text("Name must be less than 20 characters long"),
                    ),
                  );
                  return null;
                }
                if (newValue[1] == null) {
                  //If newly added row then add unique ID
                  newValue[1] = Random()
                      .nextInt(500)
                      .toString(); // to add Unique ID because it is not editable
                }
                myData[index] = newValue; // Update data
                if (newValue[0] == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Name cannot be null"),
                    ),
                  );
                  return null;
                }
                return newValue;
              },
              showActions: true,
              showAddRowButton: true,
              showDeleteAction: true,
              rowsPerPage: 5,
              showFirstLastButtons: true,
              availableRowsPerPage: const [
                5,
                10,
                15,
                20,
              ],
              dataRowMinHeight: 60,
              dataRowMaxHeight: 60,
              columnSpacing: 60,
              actionColumnTitle: const Text("Action", style: TextStyle(color: Colors.white),),
              showCheckboxColumn: true,
              onSelectAll: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: value ?? false
                        ? const Text("All Rows Selected")
                        : const Text("All Rows Unselected"),
                  ),
                );
              },
              onRowsPerPageChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Rows Per Page Changed to $value"),
                  ),
                );
              },
              actions: [
                IconButton(
                  onPressed: () {
                    for (var i = 0; i < myData.length; i += 2) {
                      tableKey.currentState?.selectRow(i, isSelected: true);
                    }
                  },
                  icon: const Icon(Icons.select_all),
                  tooltip: "Select all odd Values",
                ),
                IconButton(
                  onPressed: () {
                    for (var i = 0; i < myData.length; i += 2) {
                      tableKey.currentState?.selectRow(i, isSelected: false);
                    }
                  },
                  icon: const Icon(Icons.deselect_outlined),
                  tooltip: "Unselect all odd Values",
                ),
              ],
              rows: List.generate(
                myData.length,
                (index) => DynamicTableDataRow(
                  isSelectable: false,
                  onSelectChanged: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: value ?? false
                            ? Text("Row Selected index:$index")
                            : Text("Row Unselected index:$index"),
                      ),
                    );
                  },
                  index: index,
                  cells: List.generate(
                    myData[index].length,
                    (cellIndex) => DynamicTableDataCell(
                      value: myData[index][cellIndex],
                    ),
                  ),
                ),
              ),
              columns: [
                DynamicTableDataColumn(
                    label: const Text("Name"),
                    onSort: (columnIndex, ascending) {},
                    dynamicTableInputType: DynamicTableInputType.text(
                      focusedBorderColor: Colors.red,
                      textColor: Colors.white,
                    )),
                DynamicTableDataColumn(
                    label: const Text("Unique ID"),
                    onSort: (columnIndex, ascending) {},
                    isEditable: false,
                    dynamicTableInputType: DynamicTableInputType.text()),
                DynamicTableDataColumn(
                  label: const Text("Birth Date"),
                  onSort: (columnIndex, ascending) {},

                  dynamicTableInputType: DynamicTableInputType.dateTime(
                    context: context,
                    focusedBorderColor: Colors.green,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        hintText: "Select Birth Date",
                        suffixIcon: Icon(Icons.date_range),
                        border: OutlineInputBorder()),
                    initialDate: DateTime(1900),
                    lastDate: DateTime.now().add(
                      const Duration(days: 365),
                    ),
                    timePicker: true,
                    timePickerEntryMode: TimePickerEntryMode.dial,
                  ),
                ),
                DynamicTableDataColumn(
                  label: const Text("Gender"),
                  dynamicTableInputType: DynamicTableInputType.dropDown<String>(
                    focusedBorderColor: Colors.green,
                    textColor: Colors.white,
                    items: genderDropdown
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(growable: false),
                    selectedItemBuilder: (context) {
                      return genderDropdown
                          .map((e) => Text(e))
                          .toList(growable: false);
                    },
                    decoration: const InputDecoration(
                        hintText: "Select Gender",
                        border: OutlineInputBorder()),
                    displayBuilder: (value) =>
                        value ??
                        "", // How the string will be displayed in non editing mode
                  ),
                ),
                DynamicTableDataColumn(
                  label: const Text("Other Info"),
                  onSort: (columnIndex, ascending) {},
                  dynamicTableInputType: DynamicTableInputType.text(
                    decoration: const InputDecoration(
                      hintText: "Enter Other Info",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 100,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
