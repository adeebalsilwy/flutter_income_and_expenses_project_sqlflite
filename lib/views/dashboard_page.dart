import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import '../utils/database_helper.dart';
import '../model/transaction_model.dart';
import '../model/category_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Transaction_model> transactionList = [];
  List<Category> categoryList = [];
  DateTime? _selectedDate;
  Category? _selectedCategory;
  double totalIncome = 0.0;
  double totalExpenses = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadData();
  }

  void reloadData() {
    setState(() {
        _loadCategories();
     _loadData();
    });
    // Function to reload data when called
  }

  Future<void> _loadCategories() async {
    try {
      List<Category> categories = await dbHelper.getAllCategories();
      if (mounted) {
        setState(() {
          // Add 'All Categories' option
          categoryList = [Category(id: -1, name: 'all_categories'.tr)] + categories;
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load categories",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _loadData() async {
    try {
      List<Transaction_model> transactions = await dbHelper.getTransactions(
        date: _selectedDate,
        categoryId: _selectedCategory != null && _selectedCategory!.id != -1
            ? _selectedCategory!.id
            : null,
      );
      double income = 0.0;
      double expenses = 0.0;

      for (var transaction in transactions) {
        if (transaction.type == "Income") {
          income += transaction.amount;
        } else if (transaction.type == "Expense") {
          expenses += transaction.amount;
        }
      }

      if (mounted) {
        setState(() {
          transactionList = transactions;
          totalIncome = income;
          totalExpenses = expenses;
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load data",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  String _getCategoryName(int? categoryId) {
    if (categoryId == null) return "unknown".tr;
    final category = categoryList.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => Category(id: 0, name: "unknown".tr),
    );
    return category.name;
  }

  void _resetFilters() {
    setState(() {
      _selectedDate = null;
      _selectedCategory = null;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to adjust layout for different screen sizes
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text("dashboard".tr),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filters Section
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Date and Category Filters
                    Row(
                      children: [
                        // Date Filter
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _selectedDate = pickedDate;
                                });
                                _loadData();
                              }
                            },
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _selectedDate != null
                                    ? "Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}"
                                    : "select_date".tr,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Category Filter
                        Expanded(
                          child: categoryList.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : DropdownButtonFormField<Category>(
                                  value: _selectedCategory,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                  ),
                                  hint: Text('select_category'.tr),
                                  items: categoryList.map((Category category) {
                                    return DropdownMenuItem<Category>(
                                      value: category,
                                      child: Text(category.name),
                                    );
                                  }).toList(),
                                  onChanged: (Category? newValue) {
                                    setState(() {
                                      _selectedCategory = newValue;
                                    });
                                    _loadData();
                                  },
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Reset Filters Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: _resetFilters,
                        icon: const Icon(Icons.clear),
                        label: Text('reset_filters'.tr),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Use Expanded to prevent overflow
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Total Income and Expenses Summary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSummaryCard(
                          title: "total_income".tr,
                          value: "$totalIncome SAR",
                          color: Colors.green,
                        ),
                        _buildSummaryCard(
                          title: "total_expenses".tr,
                          value: "$totalExpenses SAR",
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Pie Chart: Income vs. Expenses
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "income_vs_expenses".tr,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 200,
                              child: SfCircularChart(
                                legend: Legend(
                                  isVisible: true,
                                  overflowMode: LegendItemOverflowMode.wrap,
                                ),
                                series: <PieSeries>[
                                  PieSeries<Transaction_model, String>(
                                    dataSource: [
                                      Transaction_model(
                                        categoryId: null,
                                        amount: totalIncome,
                                        date: DateTime.now()
                                            .toIso8601String(),
                                        type: "Income",
                                      ),
                                      Transaction_model(
                                        categoryId: null,
                                        amount: totalExpenses,
                                        date: DateTime.now()
                                            .toIso8601String(),
                                        type: "Expense",
                                      ),
                                    ],
                                    xValueMapper: (Transaction_model data, _) =>
                                        data.type.tr,
                                    yValueMapper: (Transaction_model data, _) =>
                                        data.amount,
                                    dataLabelMapper: (Transaction_model data, _) =>
                                        "${data.type.tr}: ${data.amount} SAR",
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
                    // Line Chart for Trends
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "income_expense_trends".tr,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <LineSeries<Transaction_model, String>>[
                                  LineSeries<Transaction_model, String>(
                                    dataSource: transactionList,
                                    xValueMapper: (Transaction_model data, _) =>
                                        data.date.split('T')[0],
                                    yValueMapper: (Transaction_model data, _) =>
                                        data.type == "Income" ? data.amount : 0,
                                    name: "income_trend".tr,
                                    color: Colors.green,
                                  ),
                                  LineSeries<Transaction_model, String>(
                                    dataSource: transactionList,
                                    xValueMapper: (Transaction_model data, _) =>
                                        data.date.split('T')[0],
                                    yValueMapper: (Transaction_model data, _) =>
                                        data.type == "Expense" ? data.amount : 0,
                                    name: "expense_trend".tr,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Recent Transactions
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              "recent_transactions".tr,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transactionList.length,
                              itemBuilder: (context, index) {
                                final transaction = transactionList[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        transaction.type == "Income"
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${_getCategoryName(transaction.categoryId)} | ${transaction.date.split('T')[0]}",
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      {required String title, required String value, required Color color}) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
