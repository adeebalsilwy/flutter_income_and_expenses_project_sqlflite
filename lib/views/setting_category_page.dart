import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/database_helper.dart';
import '../model/category_model.dart';

class SettingCategoryPage extends StatefulWidget {
  SettingCategoryPage({super.key});

  @override
  _SettingCategoryPageState createState() => _SettingCategoryPageState();
}

class _SettingCategoryPageState extends State<SettingCategoryPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Category> categoryList = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await dbHelper.getAllCategories();
    setState(() {
      categoryList = categories;
    });
  }

  void _showAddCategoryDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('add_new_category'.tr),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'category_name_hint'.tr),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  await dbHelper
                      .insertCategory(Category(name: controller.text));
                  _loadCategories(); // Reload categories
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('add'.tr),
            ),
          ],
        );
      },
    );
  }

  void _showEditCategoryDialog(Category category) {
    final TextEditingController controller =
        TextEditingController(text: category.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('edit_category'.tr),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'category_name_hint'.tr),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  await dbHelper.updateCategory(
                      Category(id: category.id, name: controller.text));
                  _loadCategories(); // Reload categories
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text('update'.tr),
            ),
          ],
        );
      },
    );
  }

  void _deleteCategory(Category category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('delete_category'.tr),
          content: Text('delete_category_confirmation'.tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () async {
                await dbHelper.deleteCategory(category.id!);
                _loadCategories(); // Reload categories
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('delete'.tr),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('manage_categories'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCategoryDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            final category = categoryList[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(category.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showEditCategoryDialog(category);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteCategory(category);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
