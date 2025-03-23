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
  final tableKey = GlobalKey<DynamicTableState>();
  final _tableKey = GlobalKey<DynamicTableState>();
  final _scrollController = ScrollController();
  var myData = dummyData.toList();

    List<Map<String, dynamic>> yourListOfMaps = [
    {'route': '1', 'score': 100},
    {'route': '2', 'score': 200},
    {'route': '3', 'score': 300},
  ];



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Dynamic Table Example"),
        ),
        body: Builder(builder: (context) {
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: SingleChildScrollView(
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
                        isDateTimeColumn: true,
                  
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
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 500,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: DynamicTable(
                    key: _tableKey,
                    showOnlyNonEmptyRows: true,
                    showAddRowButton: true,
                    addButtonText: "Add Route",
                    addButtonColor: Colors.blue,
                    addButtonTextColor: Colors.white,
                    actionColumnTitle: const Text("Actions", style: TextStyle(color: Colors.white)),
                    showActions: true,
                    showCheckboxColumn: false,
                    dividerColor: Colors.blue,
                    dividerThickness: 0.5,
                    backgroundColor: Colors.grey,
                    editButtonColor: Colors.blue,
                    deleteButtonColor: Colors.blue,
                    columnSpacing: 0.0,
                    horizontalMargin: 10.0,
                    enablePagination: false,
                    minDataTableWidth: 400,
                    actions: [
                      // Add Edit All button
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text("Edit All", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          _tableKey.currentState?.editAllRows();
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.blue),
                        ),
                      ),
                      // Add Save All button
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text("Save All", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          _tableKey.currentState?.saveAllRows();
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.green),
                        ),
                      ),
                    ],
                    onAddRowButtonPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          TextEditingController rowController = TextEditingController(text: '1');
                          return AlertDialog(
                            title: const Text("Add Rows"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Enter the number of rows to add:"),
                                TextField(
                                  controller: rowController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "Number of rows",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
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
                                  int numberOfRows = int.tryParse(rowController.text) ?? 1;
                                  numberOfRows = numberOfRows.clamp(1, 150);
                                  
                                  // Get the current row count before adding new rows
                                  final lastRowIndex = yourListOfMaps.length - 1;
                                  
                                  // Add the new rows
                                  for (int i = 0; i < numberOfRows; i++) {
                                    yourListOfMaps.add({'route': '${yourListOfMaps.length + 1}', 'score': ""});
                                    _tableKey.currentState?.addRowWithValues(yourListOfMaps.last.values.toList(), isEditing: true, addRowToEnd: true);
                                  }
                                  if (numberOfRows > 0) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      _tableKey.currentState?.scrollToRow(lastRowIndex);
                                    });
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
                  
                    header: const Text('Routes', style: TextStyle(color: Colors.white)),
                    columns: [
                      DynamicTableDataColumn(
                        isEditable: false,
                        label: const Text('Route', style: TextStyle(color: Colors.white)), 
                        dynamicTableInputType: DynamicTableInputType.text(
                        focusedBorderColor: Colors.blue,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      )),
                      DynamicTableDataColumn(label: const Text('Score', style: TextStyle(color: Colors.white)), dynamicTableInputType: DynamicTableInputType.text(
                        focusedBorderColor: Colors.blue,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      )),
                    ],
                    rows: yourListOfMaps.map((entry) => DynamicTableDataRow(
                      index: yourListOfMaps.indexOf(entry),
                      cells: [
                        DynamicTableDataCell(value: entry['route'] ?? ''),
                        DynamicTableDataCell(value: entry['score']?.toString() ?? ''),
                      ],
                    )).toList(),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
