import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:income_expenses/utils/dimensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../themes/theme_helper.dart';
import '../utils/database_helper.dart';
import '../model/transaction_model.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  ReportPageState createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage> {
  late TooltipBehavior _tooltipBehavior;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  List<Transaction_model> transactionList = [];
  List<Transaction_model> filteredList = [];
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _loadTransactions();
  }

  void reloadData() {
    setState(() {
      _loadTransactions();
    });
    // Function to reload data when called
  }

  Future<void> _loadTransactions() async {
    List<Transaction_model> transactions = await dbHelper.getAllTransactions();
    setState(() {
      transactionList = transactions;
      filteredList = transactions;
    });
  }

  void _filterTransactions() {
    if (selectedDateRange == null) {
      setState(() {
        filteredList = transactionList;
      });
      return;
    }

    setState(() {
      filteredList = transactionList.where((transaction) {
        DateTime transactionDate =
            DateTime.parse(transaction.date.split(' ')[0]);
        return !transactionDate.isBefore(selectedDateRange!.start) &&
            !transactionDate.isAfter(selectedDateRange!.end);
      }).toList();
    });
  }

  Future<void> _exportToPdf() async {
    try {
      // Check and request storage permissions
      if (await Permission.storage.request().isGranted) {
        PdfDocument document = PdfDocument();
        final page = document.pages.add();

        page.graphics.drawString(
          'transactions_report'.tr,
          PdfStandardFont(PdfFontFamily.helvetica, 18),
          bounds: const Rect.fromLTWH(0, 0, 500, 50),
        );

        PdfGrid grid = PdfGrid();
        grid.columns.add(count: 5);
        grid.headers.add(1);

        PdfGridRow header = grid.headers[0];
        header.cells[0].value = 'id'.tr;
        header.cells[1].value = 'category_id'.tr;
        header.cells[2].value = 'amount_sar'.tr;
        header.cells[3].value = 'date'.tr;
        header.cells[4].value = 'type'.tr;

        for (var transaction in filteredList) {
          PdfGridRow row = grid.rows.add();
          row.cells[0].value = transaction.id.toString();
          row.cells[1].value = transaction.categoryId.toString();
          row.cells[2].value = '${transaction.amount.toString()} SAR';
          row.cells[3].value = transaction.date.split(' ')[0];
          row.cells[4].value = transaction.type.tr;
        }

        grid.draw(
          page: page,
          bounds: const Rect.fromLTWH(0, 50, 0, 0),
        );

        Directory? directory = await getExternalStorageDirectory();
        if (directory != null) {
          String path = '${directory.path}/Transactions_Report.pdf';
          File file = File(path);
          await file.writeAsBytes(await document.save());

          document.dispose();

          Get.snackbar(
            "export_successful".tr,
            "pdf_file_saved".trArgs([path]),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "export_failed".tr,
            "unable_to_access_storage".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // Request permissions
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();

        if (statuses[Permission.storage]!.isGranted) {
          _exportToPdf();
        } else {
          Get.snackbar(
            "permission_denied".tr,
            "storage_permission_required".tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "export_failed".tr,
        "${'error_occurred'.tr}: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showDateRangePicker() async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      // Remove or handle locale parameter carefully
      // locale: Get.locale,
    );
    if (pickedRange != null) {
      setState(() {
        selectedDateRange = pickedRange;
        _filterTransactions();
      });
    }
  }

  // Aggregate data for charts to avoid repetition
  List<PieChartData> _getPieChartData() {
    double incomeTotal = 0.0;
    double expenseTotal = 0.0;

    for (var transaction in filteredList) {
      if (transaction.type == "Income") {
        incomeTotal += transaction.amount;
      } else if (transaction.type == "Expense") {
        expenseTotal += transaction.amount;
      }
    }

    return [
      PieChartData('income'.tr, incomeTotal),
      PieChartData('expenses'.tr, expenseTotal),
    ];
  }

  List<BarChartData> _getBarChartData() {
    Map<String, double> dateAmountMap = {};

    for (var transaction in filteredList) {
      String date = transaction.date.split(' ')[0];
      if (dateAmountMap.containsKey(date)) {
        dateAmountMap[date] = dateAmountMap[date]! + transaction.amount;
      } else {
        dateAmountMap[date] = transaction.amount;
      }
    }

    return dateAmountMap.entries
        .map((entry) => BarChartData(entry.key, entry.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = Dimensions(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "transactions_report".tr,
          style: TextStyle(
            fontSize: dimensions.fontSize20 * 1.5,
            color: Get.find<ThemeHelper>().isDarkMode
                ? Colors.amber
                : Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: _showDateRangePicker,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportToPdf,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(dimensions.height10),
          child: Column(
            children: [
              // Date Range Display
              if (selectedDateRange != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: dimensions.height10),
                  child: Text(
                    "${'from'.tr}: ${selectedDateRange!.start.toLocal().toString().split(' ')[0]} "
                    "${'to'.tr}: ${selectedDateRange!.end.toLocal().toString().split(' ')[0]}",
                    style: TextStyle(
                      fontSize: dimensions.fontSize20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              // Pie Chart
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: dimensions.height10),
                child: Padding(
                  padding: EdgeInsets.all(dimensions.height10),
                  child: Column(
                    children: [
                      Text(
                        "income_vs_expenses".tr,
                        style: TextStyle(
                          fontSize: dimensions.fontSize20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: dimensions.height20 * 10,
                        child: SfCircularChart(
                          legend: Legend(
                            isVisible: true,
                            overflowMode: LegendItemOverflowMode.wrap,
                          ),
                          tooltipBehavior: _tooltipBehavior,
                          series: <PieSeries<PieChartData, String>>[
                            PieSeries<PieChartData, String>(
                              dataSource: _getPieChartData(),
                              xValueMapper: (PieChartData data, _) => data.type,
                              yValueMapper: (PieChartData data, _) =>
                                  data.amount,
                              dataLabelMapper: (PieChartData data, _) =>
                                  '${data.type}: ${data.amount} SAR',
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bar Chart for Transactions
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: dimensions.height10),
                child: Padding(
                  padding: EdgeInsets.all(dimensions.height10),
                  child: Column(
                    children: [
                      Text(
                        "monthly_transactions".tr,
                        style: TextStyle(
                          fontSize: dimensions.fontSize20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: dimensions.height20 * 10,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          tooltipBehavior: _tooltipBehavior,
                          legend: const Legend(isVisible: false),
                          series: <CartesianSeries>[
                            ColumnSeries<BarChartData, String>(
                              dataSource: _getBarChartData(),
                              xValueMapper: (BarChartData data, _) => data.date,
                              yValueMapper: (BarChartData data, _) =>
                                  data.amount,
                              name: "amount_sar".tr,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // List of Transactions
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: dimensions.height10),
                child: Padding(
                  padding: EdgeInsets.all(dimensions.height10),
                  child: Column(
                    children: [
                      Text(
                        "transactions".tr,
                        style: TextStyle(
                          fontSize: dimensions.fontSize20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: dimensions.height20 * 15,
                        child: ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final transaction = filteredList[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: transaction.type == "Income"
                                    ? Colors.green
                                    : Colors.red,
                                child: Icon(
                                  transaction.type == "Income"
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                "${transaction.type.tr}: ${transaction.amount} SAR",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  "${'date'.tr}: ${transaction.date.split(' ')[0]}"),
                              trailing: Text(
                                "${'category_id'.tr}: ${transaction.categoryId}",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: dimensions.fontSize10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper classes for chart data
class PieChartData {
  final String type;
  final double amount;

  PieChartData(this.type, this.amount);
}

class BarChartData {
  final String date;
  final double amount;

  BarChartData(this.date, this.amount);
}
