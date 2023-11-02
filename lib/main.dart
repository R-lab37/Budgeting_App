import 'package:flutter/material.dart';

void main() {
  runApp(BudgetApp());
}

var currentThemeMode = ThemeMode.light; // Set the initial theme mode to light.

class BudgetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(
                  255, 194, 33, 243))), // Set the default light theme.

      home: BudgetHomePage(),
    );
  }
}

class BudgetHomePage extends StatefulWidget {
  @override
  _BudgetHomePageState createState() => _BudgetHomePageState();
}

class _BudgetHomePageState extends State<BudgetHomePage> {
  final List<Category> categories = [];
  double totalBudget = 0;
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categoryBudgetController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  TextEditingController expenseNameController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget App'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: categoryNameController,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: categoryBudgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Category Budget'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final categoryName = categoryNameController.text;
              final categoryBudget =
                  double.tryParse(categoryBudgetController.text) ?? 0.0;

              if (categoryName.isNotEmpty && categoryBudget > 0) {
                setState(() {
                  categories.add(Category(
                      name: categoryName,
                      budget: categoryBudget,
                      expenses: []));
                  categoryNameController.clear();
                  categoryBudgetController.clear();
                });
              }
            },
            child: Text('Add Category'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: incomeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Income Amount'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final incomeAmount =
                  double.tryParse(incomeController.text) ?? 0.0;

              setState(() {
                totalBudget += incomeAmount;
                incomeController.clear();
              });
            },
            child: Text('Add Income'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(category: category);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatefulWidget {
  final Category category;

  CategoryCard({required this.category});

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  TextEditingController expenseNameController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(widget.category.name),
            subtitle:
                Text('Budget: \$${widget.category.budget.toStringAsFixed(2)}'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: expenseNameController,
              decoration: InputDecoration(labelText: 'Expense Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: expenseAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Expense Amount'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final expenseName = expenseNameController.text;
              final expenseAmount =
                  double.tryParse(expenseAmountController.text) ?? 0.0;

              if (expenseName.isNotEmpty && expenseAmount > 0) {
                setState(() {
                  widget.category.expenses
                      .add(Expense(name: expenseName, amount: expenseAmount));
                  expenseNameController.clear();
                  expenseAmountController.clear();
                });
              }
            },
            child: Text('Add Expense'),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.category.expenses.length,
            itemBuilder: (context, index) {
              final expense = widget.category.expenses[index];
              return ListTile(
                title: Text(expense.name),
                subtitle: Text('\$${expense.amount.toStringAsFixed(2)}'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Category {
  final String name;
  final double budget;
  final List<Expense> expenses;

  Category({required this.name, required this.budget, required this.expenses});
}

class Expense {
  final String name;
  final double amount;

  Expense({required this.name, required this.amount});
}
