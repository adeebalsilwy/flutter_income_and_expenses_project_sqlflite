import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:income_expenses/model/transaction_model.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io'; // Required for File
import 'package:path_provider/path_provider.dart'; // Required for getTemporaryDirectory
import '../utils/database_helper.dart'; // Import the DatabaseHelper

class SettingPageRetrieveDataToExcel extends StatefulWidget {
  const SettingPageRetrieveDataToExcel({super.key});

  @override
  _SettingPageRetrieveDataToExcelState createState() =>
      _SettingPageRetrieveDataToExcelState();
}

class _SettingPageRetrieveDataToExcelState
    extends State<SettingPageRetrieveDataToExcel> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  List<Map<String, dynamic>> tableData = [];
  String? selectedCategory;
  String? selectedType;
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    _loadDataFromDatabase();
  }

  Future<void> _loadDataFromDatabase() async {
    try {
      List<Transaction_model> transactions =
          await dbHelper.getAllTransactions();
      setState(() {
        tableData = transactions.map((transaction) {
          return {
            'date': transaction.date,
            'category': transaction.categoryId.toString(),
            'amount': transaction.amount,
            'type': transaction.type,
          };
        }).toList();
      });
    } catch (e) {
      print('Error loading data: $e');
      Get.snackbar('error'.tr, 'data_load_failed'.tr);
    }
  }

  void _applyFilters() {
    setState(() {
      tableData = tableData.where((data) {
        bool matchesCategory =
            selectedCategory == null || data['category'] == selectedCategory;
        bool matchesType = selectedType == null || data['type'] == selectedType;
        bool matchesDate = selectedDateRange == null ||
            (DateTime.parse(data['date']).isAfter(selectedDateRange!.start) &&
                DateTime.parse(data['date']).isBefore(
                    selectedDateRange!.end.add(const Duration(days: 1))));
        return matchesCategory && matchesType && matchesDate;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      selectedCategory = null;
      selectedType = null;
      selectedDateRange = null;
      _loadDataFromDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('export_data_to_excel'.tr),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                DropdownButton<String>(
                  value: selectedCategory,
                  hint: Text('select_category'.tr),
                  items: ['Food', 'Salary', 'Transport'].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                    _applyFilters();
                  },
                ),
                DropdownButton<String>(
                  value: selectedType,
                  hint: Text('select_type'.tr),
                  items: ['Income', 'Expense'].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                    _applyFilters();
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    DateTimeRange? range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (range != null) {
                      setState(() {
                        selectedDateRange = range;
                      });
                      _applyFilters();
                    }
                  },
                  child: Text('select_date_range'.tr),
                ),
                ElevatedButton(
                  onPressed: _resetFilters,
                  child: Text('reset_filters'.tr),
                ),
              ],
            ),
          ),
          const Divider(),
          // Data Table Section
          Expanded(
            child: tableData.isEmpty
                ? Center(child: Text('no_data_available'.tr))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('date'.tr)),
                        DataColumn(label: Text('category'.tr)),
                        DataColumn(label: Text('amount'.tr)),
                        DataColumn(label: Text('type'.tr)),
                      ],
                      rows: tableData.map((data) {
                        return DataRow(cells: [
                          DataCell(Text(data['date'].toString())),
                          DataCell(Text(data['category'] ?? 'N/A')),
                          DataCell(Text(data['amount'].toString())),
                          DataCell(Text(data['type'] ?? 'N/A')),
                        ]);
                      }).toList(),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          // Export Button
          ElevatedButton.icon(
            onPressed: () async {
              await exportAndShareExcel();
            },
            icon: const Icon(Icons.share),
            label: Text('export_to_excel'.tr),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> exportAndShareExcel() async {
    try {
      // Create a new Excel document in memory
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      // Add header row
      sheetObject.appendRow([
        TextCellValue('date'.tr),
        TextCellValue('category'.tr),
        TextCellValue('amount'.tr),
        TextCellValue('type'.tr),
      ]);

      // Add data rows
      for (var data in tableData) {
        sheetObject.appendRow([
          TextCellValue(data['date'].toString()),
          TextCellValue(data['category'] ?? 'N/A'),
          IntCellValue(data['amount'] ?? 0),
          TextCellValue(data['type'] ?? 'N/A'),
        ]);
      }

      // Save the file in memory as bytes
      var fileBytes = excel.save();

      // Get the temporary directory
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/exported_data.xlsx');

      // Write the bytes to the file
      await file.writeAsBytes(fileBytes!);

      // Share the file using ShareX
      final xFile = XFile(file.path);
      await Share.shareXFiles([xFile], text: 'exported_data_text'.tr);

      // Notify the user
      Get.snackbar('success'.tr, 'excel_shared_successfully'.tr);
    } catch (e) {
      print('Error: $e');
      Get.snackbar('error'.tr, 'excel_share_failed'.tr);
    }
  }
}
