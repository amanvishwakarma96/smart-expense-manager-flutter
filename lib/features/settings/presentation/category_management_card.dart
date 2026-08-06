import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/category_repository.dart';

class CategoryManagementCard extends ConsumerStatefulWidget {
  const CategoryManagementCard({super.key});

  @override
  ConsumerState<CategoryManagementCard> createState() =>
      _CategoryManagementCardState();
}

class _CategoryManagementCardState
    extends ConsumerState<CategoryManagementCard> {
  static const List<String> _colors = <String>[
    'FFB7A1',
    '9FD8CB',
    'CBB8FF',
    'A8D8FF',
    'FFCAD4',
    'FFD98E',
    'D7DCE5',
  ];
  static const Map<String, IconData> _icons = <String, IconData>{
    'circle': Icons.circle_rounded,
    'utensils': Icons.restaurant_rounded,
    'car': Icons.directions_car_rounded,
    'shopping-bag': Icons.shopping_bag_rounded,
    'receipt': Icons.receipt_long_rounded,
    'heart-pulse': Icons.favorite_rounded,
    'home': Icons.home_rounded,
    'school': Icons.school_rounded,
    'pets': Icons.pets_rounded,
    'celebration': Icons.celebration_rounded,
  };

  Future<void> _edit(CategoryModel? category) async {
    final TextEditingController nameController = TextEditingController(
      text: category?.name ?? '',
    );
    final TextEditingController budgetController = TextEditingController(
      text: category?.monthlyBudgetLimit.toStringAsFixed(0) ?? '',
    );
    String iconName = category?.iconName ?? 'circle';
    String hexColor = category?.hexColor ?? _colors.first;

    final bool? save = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text(category == null ? 'New category' : 'Edit category'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: budgetController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Monthly budget',
                        prefixText: '$defaultCurrencySymbol ',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pick an icon',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _icons.entries
                          .map((entry) {
                            return ChoiceChip(
                              selected: iconName == entry.key,
                              onSelected: (_) {
                                setDialogState(() => iconName = entry.key);
                              },
                              avatar: Icon(entry.value, size: 18),
                              label: const Text(''),
                            );
                          })
                          .toList(growable: false),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pick a color',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      children: _colors
                          .map((String value) {
                            final bool selected = hexColor == value;
                            return InkWell(
                              borderRadius: BorderRadius.circular(99),
                              onTap: () {
                                setDialogState(() => hexColor = value);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: selected ? 42 : 36,
                                height: selected ? 42 : 36,
                                decoration: BoxDecoration(
                                  color: colorFromHex(value),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected
                                        ? AppPalette.ink
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: selected
                                    ? const Icon(Icons.check_rounded, size: 20)
                                    : null,
                              ),
                            );
                          })
                          .toList(growable: false),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    final String name = nameController.text.trim();
    final double? budget = double.tryParse(budgetController.text.trim());
    nameController.dispose();
    budgetController.dispose();
    if (save != true) {
      return;
    }
    if (budget == null) {
      _message('Enter a valid monthly budget.');
      return;
    }
    try {
      await ref
          .read(categoryRepositoryProvider)
          .save(
            id: category?.id,
            name: name,
            iconName: iconName,
            hexColor: hexColor,
            monthlyBudgetLimit: budget,
          );
      if (mounted) {
        _message(
          category == null ? 'Category added locally.' : 'Category updated.',
        );
      }
    } on ArgumentError catch (error) {
      if (mounted) {
        _message(error.message?.toString() ?? 'Could not save this category.');
      }
    }
  }

  Future<void> _delete(CategoryModel category) async {
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Delete ${category.name}?'),
              content: const Text(
                'Deletion is allowed only when no transaction, recurring item, '
                'or merchant rule uses this category.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
    if (!confirmed) {
      return;
    }
    final CategoryDeleteResult result = await ref
        .read(categoryRepositoryProvider)
        .delete(category.id);
    if (!mounted) {
      return;
    }
    switch (result) {
      case CategoryDeleteResult.deleted:
        _message('Category deleted locally.');
      case CategoryDeleteResult.inUse:
        _message('Move linked transactions and rules before deleting it.');
      case CategoryDeleteResult.lastCategory:
        _message('Keep at least one category in PiggyAI.');
      case CategoryDeleteResult.notFound:
        _message('This category no longer exists.');
    }
  }

  void _message(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<CategoryModel>> categories = ref.watch(
      categoriesProvider,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Categories & budgets',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Add category',
                  onPressed: () => _edit(null),
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text('Create your own colorful buckets and monthly limits.'),
            const SizedBox(height: 10),
            categories.when(
              loading: () => const LinearProgressIndicator(),
              error: (Object error, StackTrace stackTrace) =>
                  const Text('Could not load categories.'),
              data: (List<CategoryModel> items) {
                return Column(
                  children: items
                      .map((CategoryModel category) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: colorFromHex(category.hexColor),
                            child: Icon(
                              _icons[category.iconName] ?? Icons.circle_rounded,
                            ),
                          ),
                          title: Text(category.name),
                          subtitle: Text(
                            '${inrCurrency.format(category.monthlyBudgetLimit)} / month',
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (String action) {
                              if (action == 'edit') {
                                _edit(category);
                              } else if (action == 'delete') {
                                _delete(category);
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                const <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                          ),
                        );
                      })
                      .toList(growable: false),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
