import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/core/constants/app_colors.dart';
import 'package:kranti_ganesh_mandal/core/locale/l10n_extensions.dart';
import 'package:kranti_ganesh_mandal/core/utils/name_formatter.dart';
import 'package:kranti_ganesh_mandal/core/utils/record_timestamps.dart';
import 'package:kranti_ganesh_mandal/core/widgets/app_widgets.dart';
import 'package:kranti_ganesh_mandal/core/widgets/language_toggle_button.dart';
import 'package:kranti_ganesh_mandal/core/widgets/name_text_field.dart';
import 'package:kranti_ganesh_mandal/l10n/app_localizations.dart';
import 'package:kranti_ganesh_mandal/models/cashbook_category.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';
import 'package:kranti_ganesh_mandal/services/user_service.dart';
import 'package:uuid/uuid.dart';

class CashbookPage extends StatefulWidget {
  const CashbookPage({super.key});

  @override
  State<CashbookPage> createState() => _CashbookPageState();
}

class _CashbookPageState extends State<CashbookPage> {
  final _hive = HiveService.instance;
  final _uuid = const Uuid();
  List<Map<String, dynamic>> _entries = [];

  static List<Map<String, dynamic>> _sampleEntries(AppLocalizations l10n) {
    return [
      {
        'id': '1',
        'title': l10n.entryDonationPatil,
        'memberName': 'Patil family',
        'categoryKey': CashbookCategory.donation,
        'amount': 5000,
        'isIncome': true,
        'updatedAt': '2026-08-18T09:00:00.000',
        'createdAt': '2026-08-18T09:00:00.000',
      },
      {
        'id': '2',
        'title': l10n.entryFlowerDecoration,
        'memberName': 'Amit Jadhav',
        'categoryKey': CashbookCategory.decoration,
        'amount': 1200,
        'isIncome': false,
        'updatedAt': '2026-08-17T14:30:00.000',
        'createdAt': '2026-08-17T14:30:00.000',
      },
      {
        'id': '3',
        'title': l10n.entryPledgeCollection,
        'memberName': 'Priya Kulkarni',
        'categoryKey': CashbookCategory.donation,
        'amount': 8500,
        'isIncome': true,
        'updatedAt': '2026-08-19T11:15:00.000',
        'createdAt': '2026-08-19T11:15:00.000',
      },
      {
        'id': '4',
        'title': l10n.entrySoundSystem,
        'memberName': 'Suresh More',
        'categoryKey': CashbookCategory.others,
        'amount': 3000,
        'isIncome': false,
        'updatedAt': '2026-08-16T18:45:00.000',
        'createdAt': '2026-08-16T18:45:00.000',
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadEntries());
  }

  Future<void> _loadEntries() async {
    final l10n = context.l10n;
    await _hive.openBox(HiveBoxNames.cashbook);
    final stored = _hive.getAll(HiveBoxNames.cashbook);
    if (stored.isEmpty) {
      for (final entry in _sampleEntries(l10n)) {
        await _hive.put(
          HiveBoxNames.cashbook,
          entry['id']!.toString(),
          Map<String, dynamic>.from(entry),
        );
      }
    }
    if (mounted) {
      setState(() {
        _entries =
            RecordTimestamps.sortLatest(_hive.getAll(HiveBoxNames.cashbook));
      });
    }
  }

  Future<List<String>> _loadRegisteredUserNames() async {
    await _hive.openBox(HiveBoxNames.users);

    final names = <String>{};
    for (final user in UserService.instance.getAllUsers()) {
      final name = user['name']?.toString().trim();
      if (name != null && name.isNotEmpty) {
        names.add(name);
      }
    }

    return names.toList()..sort();
  }

  static String _categoryLabel(AppLocalizations l10n, String key) {
    return switch (key) {
      CashbookCategory.donation => l10n.categoryDonation,
      CashbookCategory.decoration => l10n.categoryDecoration,
      CashbookCategory.pooja => l10n.categoryPooja,
      CashbookCategory.ganeshIdol => l10n.categoryGaneshIdol,
      CashbookCategory.ganeshAagman => l10n.categoryGaneshAagman,
      CashbookCategory.ganeshVisarjan => l10n.categoryGaneshVisarjan,
      CashbookCategory.prasad => l10n.categoryPrasad,
      CashbookCategory.others => l10n.categoryOthers,
      _ => key,
    };
  }

  String _entryTitle(AppLocalizations l10n, Map<String, dynamic> entry) {
    final member = entry['memberName']?.toString();
    final categoryKey = entry['categoryKey']?.toString();

    if (member != null && member.isNotEmpty) {
      if (categoryKey != null && categoryKey.isNotEmpty) {
        return '$member · ${_categoryLabel(l10n, categoryKey)}';
      }
      return member;
    }

    return entry['title']?.toString() ?? '';
  }

  Future<void> _saveEntry(
    Map<String, dynamic> entry, {
    Map<String, dynamic>? existing,
  }) async {
    await _hive.put(
      HiveBoxNames.cashbook,
      entry['id']!.toString(),
      RecordTimestamps.stamp(entry, existing: existing),
    );
    await _loadEntries();
  }

  Future<Map<String, dynamic>?> _showEntryFormDialog({
    required String title,
    Map<String, dynamic>? existing,
  }) async {
    final l10n = context.l10n;
    final registeredNames = await _loadRegisteredUserNames();
    if (!mounted) return null;

    final amountController = TextEditingController(
      text: existing?['amount']?.toString() ?? '',
    );
    final userNameController = TextEditingController(
      text: existing?['memberName']?.toString() ?? '',
    );
    var isIncome = existing?['isIncome'] != false;
    var selectedMember = isIncome
        ? null
        : existing?['memberName']?.toString();
    if (!isIncome &&
        selectedMember != null &&
        !registeredNames.contains(selectedMember)) {
      selectedMember = null;
    }
    var selectedCategory = existing?['categoryKey']?.toString() ??
        (isIncome
            ? CashbookCategory.donation
            : CashbookCategory.decoration);

    List<String> categoriesForType(bool income) => income
        ? CashbookCategory.incomeCategories
        : CashbookCategory.expenseCategories;

    if (!categoriesForType(isIncome).contains(selectedCategory)) {
      selectedCategory = categoriesForType(isIncome).first;
    }

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              scrollable: true,
              title: Text(title),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(
                          value: true,
                          label: Text(l10n.income),
                          icon: const Icon(Icons.arrow_downward),
                        ),
                        ButtonSegment(
                          value: false,
                          label: Text(l10n.expense),
                          icon: const Icon(Icons.arrow_upward),
                        ),
                      ],
                      selected: {isIncome},
                      onSelectionChanged: (selection) {
                        final income = selection.first;
                        setDialogState(() {
                          if (income) {
                            if (selectedMember != null &&
                                selectedMember!.isNotEmpty) {
                              userNameController.text = selectedMember!;
                            }
                            selectedMember = null;
                          } else {
                            final typed = userNameController.text.trim();
                            selectedMember = registeredNames.contains(typed)
                                ? typed
                                : null;
                          }
                          isIncome = income;
                          selectedCategory =
                              categoriesForType(income).first;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    if (isIncome)
                      NameTextField(
                        controller: userNameController,
                        decoration: InputDecoration(labelText: l10n.userName),
                      )
                    else if (registeredNames.isEmpty)
                      Text(
                        l10n.noRegisteredMembersAvailable,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    else
                      DropdownButtonFormField<String>(
                        key: ValueKey(selectedMember),
                        initialValue: selectedMember,
                        decoration: InputDecoration(
                          labelText: l10n.registeredMember,
                        ),
                        hint: Text(l10n.selectRegisteredMember),
                        items: registeredNames
                            .map(
                              (name) => DropdownMenuItem(
                                value: name,
                                child: Text(name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setDialogState(() => selectedMember = value);
                        },
                      ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      key: ValueKey('$isIncome-$selectedCategory'),
                      initialValue: selectedCategory,
                      decoration:
                          InputDecoration(labelText: l10n.cashbookCategory),
                      items: categoriesForType(isIncome)
                          .map(
                            (key) => DropdownMenuItem(
                              value: key,
                              child: Text(_categoryLabel(l10n, key)),
                            ),
                          )
                          .toList(),
                      onChanged: categoriesForType(isIncome).length == 1
                          ? null
                          : (value) {
                              if (value != null) {
                                setDialogState(() => selectedCategory = value);
                              }
                            },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(labelText: l10n.amount),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    final amount = double.tryParse(amountController.text.trim());
                    final payerName = isIncome
                        ? NameFormatter.format(userNameController.text)
                        : selectedMember?.trim() ?? '';

                    if (payerName.isEmpty) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(content: Text(l10n.fieldRequired)),
                      );
                      return;
                    }
                    if (!isIncome && registeredNames.isEmpty) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(content: Text(l10n.noRegisteredMembersAvailable)),
                      );
                      return;
                    }
                    if (selectedCategory.isEmpty ||
                        !categoriesForType(isIncome)
                            .contains(selectedCategory)) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(content: Text(l10n.fieldRequired)),
                      );
                      return;
                    }
                    if (amount == null || amount <= 0) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(content: Text(l10n.invalidAmount)),
                      );
                      return;
                    }

                    final entryTitle =
                        '$payerName · ${_categoryLabel(l10n, selectedCategory)}';

                    final entry = <String, dynamic>{
                      'id': existing?['id'] ?? _uuid.v4(),
                      'title': entryTitle,
                      'memberName': payerName,
                      'categoryKey': selectedCategory,
                      'amount': amount,
                      'isIncome': isIncome,
                    };

                    Navigator.pop(dialogContext, entry);
                  },
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showAddEntryDialog() async {
    final entry = await _showEntryFormDialog(title: context.l10n.addEntry);
    if (entry == null || !mounted) return;
    await _saveEntry(entry);
  }

  Future<void> _showEditEntryDialog(Map<String, dynamic> existing) async {
    final entry = await _showEntryFormDialog(
      title: context.l10n.editEntry,
      existing: existing,
    );
    if (entry == null || !mounted) return;
    await _saveEntry(entry, existing: existing);
  }

  Future<void> _confirmDeleteEntry(Map<String, dynamic> entry) async {
    final l10n = context.l10n;
    final entryId = entry['id']?.toString();
    if (entryId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteEntry),
        content: Text(l10n.deleteEntryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.deleteEntry),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await _hive.delete(HiveBoxNames.cashbook, entryId);
    await _loadEntries();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.entryDeleted)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canEdit = AuthController.instance.canEdit;
    final canDelete = AuthController.instance.isSuperAdmin;
    final currency = NumberFormat.currency(
      locale: currencyLocaleFor(context),
      symbol: '₹',
    );

    final income = _entries
        .where((e) => e['isIncome'] == true)
        .fold<double>(0, (sum, e) => sum + (e['amount'] as num));
    final expense = _entries
        .where((e) => e['isIncome'] != true)
        .fold<double>(0, (sum, e) => sum + (e['amount'] as num));

    return AppScaffold(
      title: l10n.cashbook,
      actions: const [LanguageToggleButton()],
      body: Column(
        children: [
          if (canEdit)
            TopAddButton(
              label: l10n.addEntry,
              onPressed: _showAddEntryDialog,
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: l10n.income,
                    amount: currency.format(income),
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    label: l10n.expense,
                    amount: currency.format(expense),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _entries.isEmpty
                ? EmptyState(
                    icon: Icons.account_balance_wallet_outlined,
                    title: l10n.noCashbookEntries,
                    message: l10n.addCashbookMessage,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _entries.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final entry = _entries[index];
                      final isIncome = entry['isIncome'] == true;

                      return ListTile(
                        onTap:
                            canEdit ? () => _showEditEntryDialog(entry) : null,
                        leading: CircleAvatar(
                          backgroundColor: isIncome
                              ? AppColors.success.withValues(alpha: 0.12)
                              : AppColors.primary.withValues(alpha: 0.12),
                          child: Icon(
                            isIncome
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color:
                                isIncome ? AppColors.success : AppColors.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(_entryTitle(l10n, entry)),
                        subtitle: Text(formatRecordDateTime(context, entry)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${isIncome ? '+' : '-'}${currency.format(entry['amount'])}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isIncome
                                    ? AppColors.success
                                    : AppColors.primary,
                              ),
                            ),
                            if (canDelete) ...[
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: AppColors.primary,
                                onPressed: () => _confirmDeleteEntry(entry),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(
              amount,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
