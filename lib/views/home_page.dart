import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:income_expenses/utils/app_color.dart';
import 'package:income_expenses/utils/dimensions.dart';
import 'package:income_expenses/utils/database_helper.dart';
import 'package:income_expenses/model/transaction_model.dart';
import 'package:income_expenses/model/category_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  List<Transaction_model> transactionList = [];
  List<Category> categoryList = [];
  List<Transaction_model> filteredList = [];
  Category? selectedCategory;
  String? selectedTransactionType;
  DateTimeRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadTransactions();
  }

  void reloadData() {
    setState(() {
        _loadCategories();
    _loadTransactions(); 
    });
    // Function to reload data when called
  }

  Future<void> _loadTransactions() async {
    try {
      List<Transaction_model> transactions =
          await dbHelper.getAllTransactions();
      setState(() {
        transactionList = transactions;
        filteredList = transactions; // Ensure the filter list updates
      });
    } catch (e) {
      Get.snackbar("error".tr, "transaction_load_error".tr,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _loadCategories() async {
    try {
      List<Category> categories = await dbHelper.getAllCategories();
      setState(() {
        categoryList = categories;
      });
    } catch (e) {
      Get.snackbar("error".tr, "category_load_error".tr,
          snackPosition: SnackPosition.TOP);
    }
  }

  void _showAddTransactionDialog({Transaction_model? transaction}) {
    final TextEditingController amountController = TextEditingController(
        text: transaction != null ? transaction.amount.toString() : '');
    String transactionType = transaction?.type ?? 'Expense';
    DateTime selectedDate =
        transaction != null ? DateTime.parse(transaction.date) : DateTime.now();
    Category? currentCategory = transaction != null
        ? categoryList.firstWhere((cat) => cat.id == transaction.categoryId)
        : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(transaction == null
              ? "add_new_transaction".tr
              : "edit_transaction".tr),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<Category>(
                  value: currentCategory,
                  items: categoryList.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      currentCategory = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "category".tr,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "amount".tr,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: transactionType,
                  items: ['Expense', 'Income']
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type.tr)))
                      .toList(),
                  onChanged: (value) {
                    transactionType = value!;
                  },
                  decoration: InputDecoration(
                    labelText: "transaction_type".tr,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                        "${"date".tr}: ${DateFormat('dd/MM/yyyy').format(selectedDate)}"),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("cancel".tr),
            ),
            TextButton(
              onPressed: () async {
                if (currentCategory != null &&
                    amountController.text.isNotEmpty) {
                  try {
                    if (transaction == null) {
                      await dbHelper.insertTransaction(
                        Transaction_model(
                          categoryId: currentCategory!.id,
                          amount: double.parse(amountController.text),
                          date: DateFormat('yyyy-MM-dd').format(selectedDate),
                          type: transactionType,
                        ),
                      );
                      Get.snackbar("success".tr, "transaction_added".tr,
                          snackPosition: SnackPosition.TOP);
                    } else {
                      await dbHelper.updateTransaction(
                        Transaction_model(
                          id: transaction.id,
                          categoryId: currentCategory!.id,
                          amount: double.parse(amountController.text),
                          date: DateFormat('yyyy-MM-dd').format(selectedDate),
                          type: transactionType,
                        ),
                      );
                      Get.snackbar("success".tr, "transaction_updated".tr,
                          snackPosition: SnackPosition.TOP);
                    }
                    _loadTransactions();
                    Navigator.of(context).pop();
                  } catch (e) {
                    Get.snackbar("error".tr, "transaction_save_error".tr,
                        snackPosition: SnackPosition.TOP);
                  }
                }
              },
              child: Text(transaction == null ? "add".tr : "update".tr),
            ),
          ],
        );
      },
    );
  }

  void _deleteTransaction(int transactionId) async {
    try {
      await dbHelper.deleteTransaction(transactionId);
      _loadTransactions();
      Get.snackbar("success".tr, "transaction_deleted".tr,
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar("error".tr, "transaction_delete_error".tr,
          snackPosition: SnackPosition.TOP);
    }
  }

  void _filterTransactions() {
    setState(() {
      filteredList = transactionList.where((transaction) {
        bool matchesCategory = selectedCategory == null ||
            transaction.categoryId == selectedCategory!.id;
        bool matchesType = selectedTransactionType == null ||
            transaction.type == selectedTransactionType;
        bool matchesDate = selectedDateRange == null ||
            (DateTime.parse(transaction.date).isAfter(selectedDateRange!.start
                    .subtract(const Duration(seconds: 1))) &&
                DateTime.parse(transaction.date).isBefore(
                    selectedDateRange!.end.add(const Duration(seconds: 1))));
        return matchesCategory && matchesType && matchesDate;
      }).toList();
    });
  }

  void _setDateRangeForFilter(String rangeType) {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    setState(() {
      switch (rangeType) {
        case 'Today':
          selectedDateRange = DateTimeRange(start: startOfDay, end: endOfDay);
          break;
        case 'Yesterday':
          DateTime yesterday = startOfDay.subtract(const Duration(days: 1));
          selectedDateRange = DateTimeRange(
            start: yesterday,
            end: yesterday
                .add(const Duration(hours: 23, minutes: 59, seconds: 59)),
          );
          break;
        case 'This Week':
          DateTime startOfWeek =
              startOfDay.subtract(Duration(days: now.weekday - 1));
          DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
          selectedDateRange = DateTimeRange(
            start: startOfWeek,
            end: DateTime(
                endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
          );
          break;
        case 'This Month':
          selectedDateRange = DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
          );
          break;
        case 'This Year':
          selectedDateRange = DateTimeRange(
            start: DateTime(now.year, 1, 1),
            end: DateTime(now.year, 12, 31, 23, 59, 59),
          );
          break;
        default:
          selectedDateRange = null;
      }
      _filterTransactions();
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          color: Get.isDarkMode
              ? Colors.black
              : Colors.white, // Set background color based on theme
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "filter_transactions".tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Get.isDarkMode
                          ? Colors.white
                          : Colors.amber, // Adjust text color
                    ),
                  ),
                  const Divider(),
                  DropdownButton<Category>(
                    value: selectedCategory,
                    hint: Text(
                      "select_category".tr,
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    isExpanded: true,
                    dropdownColor: Get.isDarkMode
                        ? Colors.black87
                        : Colors.white, // Dropdown background
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(
                          "all_categories".tr,
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      ...categoryList.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                        _filterTransactions();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedTransactionType,
                    hint: Text(
                      "select_transaction_type".tr,
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    isExpanded: true,
                    dropdownColor:
                        Get.isDarkMode ? Colors.black87 : Colors.white,
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text(
                          "all_types".tr,
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Expense',
                        child: Text(
                          "expense".tr,
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Income',
                        child: Text(
                          "income".tr,
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedTransactionType = value;
                        _filterTransactions();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _setDateRangeForFilter('Today'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Get.isDarkMode
                              ? Colors.grey[800]
                              : Colors.amber, // Button color
                        ),
                        child: Text("today".tr),
                      ),
                      ElevatedButton(
                        onPressed: () => _setDateRangeForFilter('Yesterday'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Get.isDarkMode ? Colors.grey[800] : Colors.amber,
                        ),
                        child: Text("yesterday".tr),
                      ),
                      ElevatedButton(
                        onPressed: () => _setDateRangeForFilter('This Week'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Get.isDarkMode ? Colors.grey[800] : Colors.amber,
                        ),
                        child: Text("this_week".tr),
                      ),
                      ElevatedButton(
                        onPressed: () => _setDateRangeForFilter('This Month'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Get.isDarkMode ? Colors.grey[800] : Colors.amber,
                        ),
                        child: Text("this_month".tr),
                      ),
                      ElevatedButton(
                        onPressed: () => _setDateRangeForFilter('This Year'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Get.isDarkMode ? Colors.grey[800] : Colors.amber,
                        ),
                        child: Text("this_year".tr),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          DateTimeRange? pickedRange =
                              await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedRange != null) {
                            setState(() {
                              selectedDateRange = pickedRange;
                              _filterTransactions();
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Get.isDarkMode ? Colors.grey[800] : Colors.amber,
                        ),
                        child: Text("custom_date_range".tr),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedCategory = null;
                        selectedTransactionType = null;
                        selectedDateRange = null;
                        _filterTransactions();
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Get.isDarkMode ? Colors.grey[800] : Colors.amber,
                    ),
                    icon: const Icon(Icons.clear),
                    label: Text("clear_filters".tr),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCategories();
    _loadTransactions(); // Reload data every time the page is revisited
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("transactions".tr),
        centerTitle: true,
        automaticallyImplyLeading: false, // لإلغاء زر الرجوع

        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterModal,
          ),
        ],
      ),
      body: filteredList.isEmpty
          ? Center(
              child: Text(
                "no_transactions_found".tr,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final transaction = filteredList[index];
                final category = categoryList.firstWhere(
                  (cat) => cat.id == transaction.categoryId,
                  orElse: () => Category(id: 0, name: "unknown".tr),
                );
                return ListTile(
                  title:
                      Text("${transaction.type.tr}: \$${transaction.amount}"),
                  subtitle: Text(
                    "${category.name} | ${DateFormat('dd/MM/yyyy').format(DateTime.parse(transaction.date))}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteTransaction(transaction.id!);
                    },
                  ),
                  onTap: () =>
                      _showAddTransactionDialog(transaction: transaction),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTransactionDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
