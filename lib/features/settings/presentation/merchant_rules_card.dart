import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_rule_model.dart';

class MerchantRulesCard extends ConsumerStatefulWidget {
  const MerchantRulesCard({super.key});

  @override
  ConsumerState<MerchantRulesCard> createState() => _MerchantRulesCardState();
}

class _MerchantRulesCardState extends ConsumerState<MerchantRulesCard> {
  Future<void> _edit(
    List<CategoryModel> categories, {
    MerchantRuleModel? rule,
  }) async {
    if (categories.isEmpty) {
      _message('Create a category before adding a merchant rule.');
      return;
    }
    final TextEditingController patternController = TextEditingController(
      text: rule?.merchantPattern ?? '',
    );
    int categoryId = rule?.mappedCategoryId ?? categories.first.id;
    if (!categories.any((CategoryModel item) => item.id == categoryId)) {
      categoryId = categories.first.id;
    }

    final bool? save = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text(rule == null ? 'New merchant rule' : 'Edit rule'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: patternController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Merchant text to match',
                      hintText: 'Example: SWIGGY',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: categoryId,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: categories.map((CategoryModel category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(growable: false),
                    onChanged: (int? value) {
                      if (value != null) {
                        setDialogState(() => categoryId = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Longer matching rules are checked first. Everything stays '
                    'on this device.',
                  ),
                ],
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

    final String pattern = patternController.text.trim();
    patternController.dispose();
    if (save != true) {
      return;
    }
    try {
      await ref.read(merchantRuleRepositoryProvider).saveRule(
            id: rule?.id,
            merchantPattern: pattern,
            categoryId: categoryId,
          );
      if (mounted) {
        _message(rule == null ? 'Merchant rule added locally.' : 'Rule updated.');
      }
    } on ArgumentError catch (error) {
      if (mounted) {
        _message(error.message?.toString() ?? 'Could not save this rule.');
      }
    }
  }

  Future<void> _delete(MerchantRuleModel rule) async {
    final bool confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Delete merchant rule?'),
              content: Text(
                'Future merchants matching “${rule.merchantPattern.toUpperCase()}” '
                'will no longer be categorized automatically.',
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
    await ref.read(merchantRuleRepositoryProvider).delete(rule.id);
    if (mounted) {
      _message('Merchant rule deleted locally.');
    }
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<CategoryModel>> categories = ref.watch(
      categoriesProvider,
    );
    final AsyncValue<List<MerchantRuleModel>> rules = ref.watch(
      merchantRulesProvider,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppPalette.mint,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Merchant rules',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text('Friendly automation without cloud AI.'),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Add merchant rule',
                  onPressed: categories.value == null
                      ? null
                      : () => _edit(categories.value!),
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            rules.when(
              loading: () => const LinearProgressIndicator(),
              error: (Object error, StackTrace stackTrace) =>
                  const Text('Could not load merchant rules.'),
              data: (List<MerchantRuleModel> items) {
                if (items.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppPalette.mint.withValues(alpha: 0.32),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'No rules yet. Add one to teach PiggyAI your favorite '
                      'merchant-category matches.',
                    ),
                  );
                }
                final Map<int, String> categoryNames = <int, String>{
                  for (final CategoryModel category
                      in categories.value ?? const <CategoryModel>[])
                    category.id: category.name,
                };
                return Column(
                  children: items.map((MerchantRuleModel rule) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        child: Icon(Icons.bolt_rounded),
                      ),
                      title: Text(rule.merchantPattern.toUpperCase()),
                      subtitle: Text(
                        '→ ${categoryNames[rule.mappedCategoryId] ?? 'Missing category'}',
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (String action) {
                          if (action == 'edit') {
                            _edit(
                              categories.value ?? const <CategoryModel>[],
                              rule: rule,
                            );
                          } else if (action == 'delete') {
                            _delete(rule);
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
                  }).toList(growable: false),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
