import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_rule_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/learned_merchant_mapping.dart';

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
                    items: categories
                        .map((CategoryModel category) {
                          return DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(category.name),
                          );
                        })
                        .toList(growable: false),
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
      await ref
          .read(merchantRuleRepositoryProvider)
          .saveRule(
            id: rule?.id,
            merchantPattern: pattern,
            categoryId: categoryId,
          );
      if (mounted) {
        _message(
          rule == null ? 'Merchant rule added locally.' : 'Rule updated.',
        );
      }
    } on ArgumentError catch (error) {
      if (mounted) {
        _message(error.message?.toString() ?? 'Could not save this rule.');
      }
    }
  }

  Future<void> _editLearned(
    LearnedMerchantMapping mapping,
    List<CategoryModel> categories,
  ) async {
    if (categories.isEmpty) {
      return;
    }
    int categoryId = mapping.categoryId;
    if (!categories.any((CategoryModel item) => item.id == categoryId)) {
      categoryId = categories.first.id;
    }
    final int? selected = await showDialog<int>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text('Edit ${mapping.merchant.toUpperCase()}'),
              content: DropdownButtonFormField<int>(
                initialValue: categoryId,
                decoration: const InputDecoration(labelText: 'Learned category'),
                items: categories
                    .map((CategoryModel category) => DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name),
                        ))
                    .toList(growable: false),
                onChanged: (int? value) {
                  if (value != null) {
                    setDialogState(() => categoryId = value);
                  }
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(categoryId),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
    if (selected == null) {
      return;
    }
    await ref
        .read(merchantRuleRepositoryProvider)
        .editLearnedMapping(id: mapping.id, categoryId: selected);
    if (mounted) {
      _message('Learned mapping updated locally.');
    }
  }

  Future<void> _delete(MerchantRuleModel rule) async {
    final bool confirmed =
        await showDialog<bool>(
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

  Future<void> _deleteLearned(LearnedMerchantMapping mapping) async {
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: const Text('Clear learned mapping?'),
            content: Text(
              'PiggyAI will forget the learned category confidence for ${mapping.merchant.toUpperCase()}.',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Keep'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Clear'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed) {
      return;
    }
    await ref
        .read(merchantRuleRepositoryProvider)
        .deleteLearnedMapping(mapping.id);
    if (mounted) {
      _message('Learned mapping cleared.');
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
    final AsyncValue<List<MerchantRuleModel>> rules = ref.watch(
      merchantRulesProvider,
    );
    final AsyncValue<List<LearnedMerchantMapping>> learned = ref.watch(
      learnedMerchantMappingsProvider,
    );
    final Map<int, String> categoryNames = <int, String>{
      for (final CategoryModel category
          in categories.value ?? const <CategoryModel>[])
        category.id: category.name,
    };

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
                      'No explicit rules yet. Add one when you want a direct merchant match.',
                    ),
                  );
                }
                return Column(
                  children: items
                      .map((MerchantRuleModel rule) => ListTile(
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
                          ))
                      .toList(growable: false),
                );
              },
            ),
            const Divider(height: 28),
            const Text(
              'Learned from confirmations',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            const Text(
              'Only confirmed manual category corrections increase confidence. Merchant text is encrypted on-device.',
            ),
            const SizedBox(height: 10),
            learned.when(
              loading: () => const LinearProgressIndicator(),
              error: (Object error, StackTrace stackTrace) =>
                  const Text('Could not load learned mappings.'),
              data: (List<LearnedMerchantMapping> items) {
                if (items.isEmpty) {
                  return const Text(
                    'No learned mappings yet. Correct a category and confirm the transaction to teach PiggyAI.',
                  );
                }
                return Column(
                  children: items
                      .map((LearnedMerchantMapping mapping) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              child: Icon(Icons.psychology_alt_rounded),
                            ),
                            title: Text(mapping.merchant.toUpperCase()),
                            subtitle: Text(
                              '${categoryNames[mapping.categoryId] ?? 'Missing category'} · confidence ${mapping.confidence}',
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (String action) {
                                if (action == 'edit') {
                                  _editLearned(
                                    mapping,
                                    categories.value ?? const <CategoryModel>[],
                                  );
                                } else if (action == 'clear') {
                                  _deleteLearned(mapping);
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  const <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('Edit category'),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'clear',
                                      child: Text('Clear learned mapping'),
                                    ),
                                  ],
                            ),
                          ))
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
