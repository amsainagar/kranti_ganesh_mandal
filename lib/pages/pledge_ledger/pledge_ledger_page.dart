import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/core/constants/app_colors.dart';
import 'package:kranti_ganesh_mandal/core/locale/l10n_extensions.dart';
import 'package:kranti_ganesh_mandal/core/utils/name_formatter.dart';
import 'package:kranti_ganesh_mandal/core/utils/record_timestamps.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';
import 'package:kranti_ganesh_mandal/core/widgets/app_widgets.dart';
import 'package:kranti_ganesh_mandal/core/widgets/language_toggle_button.dart';
import 'package:kranti_ganesh_mandal/core/widgets/name_text_field.dart';
import 'package:uuid/uuid.dart';

class PledgeLedgerPage extends StatefulWidget {
  const PledgeLedgerPage({super.key});

  @override
  State<PledgeLedgerPage> createState() => _PledgeLedgerPageState();
}

class _PledgeLedgerPageState extends State<PledgeLedgerPage> {
  final _hive = HiveService.instance;
  final _uuid = const Uuid();
  List<Map<String, dynamic>> _pledges = [];
  String _statusFilter = _allStatusesKey;

  static const _allStatusesKey = 'all';

  static const _samplePledges = [
    {
      'id': '1',
      'name': 'Rajesh Patil',
      'amount': 5100,
      'isCompleted': true,
      'updatedAt': '2026-08-15T18:30:00.000',
      'createdAt': '2026-08-15T18:30:00.000',
      'note': 'Collected during visarjan',
    },
    {
      'id': '2',
      'name': 'Sunita Deshmukh',
      'amount': 2100,
      'isCompleted': false,
      'updatedAt': '2026-08-20T10:00:00.000',
      'createdAt': '2026-08-20T10:00:00.000',
      'note': '',
    },
    {
      'id': '3',
      'name': 'Village Committee',
      'amount': 11000,
      'isCompleted': true,
      'updatedAt': '2026-08-10T20:15:00.000',
      'createdAt': '2026-08-10T20:15:00.000',
      'note': 'Annual contribution',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPledges());
  }

  Future<void> _loadPledges() async {
    await _hive.openBox(HiveBoxNames.pledges);
    final stored = _hive.getAll(HiveBoxNames.pledges);
    if (stored.isEmpty) {
      for (final pledge in _samplePledges) {
        await _hive.put(
          HiveBoxNames.pledges,
          pledge['id']!.toString(),
          Map<String, dynamic>.from(pledge),
        );
      }
    }
    if (!mounted) return;
    setState(() {
      _pledges = RecordTimestamps.sortLatest(_hive.getAll(HiveBoxNames.pledges));
    });
  }

  Future<void> _savePledge(
    Map<String, dynamic> pledge, {
    Map<String, dynamic>? existing,
  }) async {
    await _hive.put(
      HiveBoxNames.pledges,
      pledge['id']!.toString(),
      RecordTimestamps.stamp(pledge, existing: existing),
    );
    await _loadPledges();
  }

  List<Map<String, dynamic>> get _filteredPledges {
    final filtered = switch (_statusFilter) {
      'pending' =>
        _pledges.where((p) => p['isCompleted'] != true).toList(),
      'received' =>
        _pledges.where((p) => p['isCompleted'] == true).toList(),
      _ => _pledges,
    };
    return RecordTimestamps.sortLatest(filtered);
  }

  double _totalAmount(List<Map<String, dynamic>> pledges) {
    return pledges.fold<double>(
      0,
      (sum, pledge) => sum + ((pledge['amount'] as num?)?.toDouble() ?? 0),
    );
  }

  Future<Map<String, dynamic>?> _showPledgeFormDialog({
    required String title,
    Map<String, dynamic>? existing,
  }) async {
    final l10n = context.l10n;
    final nameController = TextEditingController(
      text: existing?['name']?.toString() ?? '',
    );
    final amountController = TextEditingController(
      text: existing?['amount']?.toString() ?? '',
    );
    final noteController = TextEditingController(
      text: existing?['note']?.toString() ?? '',
    );
    var isCompleted = existing?['isCompleted'] == true;

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
                          value: false,
                          label: Text(l10n.pending),
                        ),
                        ButtonSegment(
                          value: true,
                          label: Text(l10n.received),
                        ),
                      ],
                      selected: {isCompleted},
                      onSelectionChanged: (selection) {
                        setDialogState(() => isCompleted = selection.first);
                      },
                    ),
                    const SizedBox(height: 12),
                    NameTextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: l10n.name),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(labelText: l10n.amount),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteController,
                      decoration: InputDecoration(
                        labelText: l10n.note,
                        hintText: l10n.noteHint,
                      ),
                      maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,
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
                    final name = NameFormatter.format(nameController.text);
                    final amount = double.tryParse(amountController.text.trim());

                    if (name.isEmpty) {
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

                    Navigator.pop(dialogContext, {
                      'id': existing?['id'] ?? _uuid.v4(),
                      'name': name,
                      'amount': amount,
                      'note': noteController.text.trim(),
                      'isCompleted': isCompleted,
                    });
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

  Future<void> _showAddPledgeDialog() async {
    final pledge = await _showPledgeFormDialog(
      title: context.l10n.addPledge,
    );
    if (pledge == null || !mounted) return;
    await _savePledge(pledge);
  }

  Future<void> _showEditPledgeDialog(Map<String, dynamic> pledge) async {
    final updated = await _showPledgeFormDialog(
      title: context.l10n.editPledge,
      existing: pledge,
    );
    if (updated == null || !mounted) return;
    await _savePledge(updated, existing: pledge);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updated['isCompleted'] == true
              ? context.l10n.markedAsReceived
              : context.l10n.markedAsPending,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmDeletePledge(Map<String, dynamic> pledge) async {
    final l10n = context.l10n;
    final pledgeId = pledge['id']?.toString();
    if (pledgeId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deletePledge),
        content: Text(l10n.deletePledgeConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.deletePledge),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await _hive.delete(HiveBoxNames.pledges, pledgeId);
    await _loadPledges();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.pledgeDeleted)),
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
    final pledges = _filteredPledges;
    final pendingTotal = _totalAmount(
      _pledges.where((p) => p['isCompleted'] != true).toList(),
    );
    final receivedTotal = _totalAmount(
      _pledges.where((p) => p['isCompleted'] == true).toList(),
    );
    final showAllTotals = _statusFilter == _allStatusesKey;

    return AppScaffold(
      title: l10n.pledgeLedger,
      actions: const [LanguageToggleButton()],
      body: _pledges.isEmpty && !canEdit
          ? EmptyState(
              icon: Icons.menu_book_outlined,
              title: l10n.noPledgesYet,
              message: l10n.addPledgesMessage,
            )
          : Column(
              children: [
                if (canEdit)
                  TopAddButton(
                    label: l10n.addPledge,
                    onPressed: _showAddPledgeDialog,
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: DropdownButtonFormField<String>(
                    key: ValueKey(_statusFilter),
                    initialValue: _statusFilter,
                    decoration: InputDecoration(
                      labelText: l10n.status,
                      prefixIcon: const Icon(Icons.filter_list),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: _allStatusesKey,
                        child: Text(l10n.allStatuses),
                      ),
                      DropdownMenuItem(
                        value: 'pending',
                        child: Text(l10n.pending),
                      ),
                      DropdownMenuItem(
                        value: 'received',
                        child: Text(l10n.received),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _statusFilter = value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: showAllTotals
                      ? Row(
                          children: [
                            Expanded(
                              child: _PledgeTotalCard(
                                label: l10n.totalPending,
                                amount: currency.format(pendingTotal),
                                color: AppColors.pending,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _PledgeTotalCard(
                                label: l10n.totalReceived,
                                amount: currency.format(receivedTotal),
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        )
                      : _PledgeTotalCard(
                          label: _statusFilter == 'pending'
                              ? l10n.totalPending
                              : l10n.totalReceived,
                          amount: currency.format(
                            _statusFilter == 'pending'
                                ? pendingTotal
                                : receivedTotal,
                          ),
                          color: _statusFilter == 'pending'
                              ? AppColors.pending
                              : AppColors.success,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    canEdit ? l10n.tapToEdit : l10n.readOnlyMode,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
                Expanded(
                  child: pledges.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noPledgesYet,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: pledges.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final pledge = pledges[index];
                      final isCompleted = pledge['isCompleted'] == true;
                      final note = pledge['note']?.toString().trim() ?? '';
                      final rowColor = isCompleted
                          ? AppColors.success.withValues(alpha: 0.08)
                          : AppColors.pending.withValues(alpha: 0.06);

                      return Card(
                        color: rowColor,
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: canEdit ? () => _showEditPledgeDialog(pledge) : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pledge['name']?.toString() ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatRecordDateTime(context, pledge),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      if (note.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          note,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color:
                                                    AppColors.textSecondary,
                                                fontStyle: FontStyle.italic,
                                              ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      currency.format(pledge['amount']),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    StatusBadge(
                                      label: isCompleted
                                          ? l10n.received
                                          : l10n.pending,
                                      isCompleted: isCompleted,
                                    ),
                                    if (canDelete) ...[
                                      const SizedBox(height: 4),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 20,
                                        ),
                                        color: AppColors.primary,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () =>
                                            _confirmDeletePledge(pledge),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
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

class _PledgeTotalCard extends StatelessWidget {
  const _PledgeTotalCard({
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
      color: color.withValues(alpha: 0.1),
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
                fontSize: 20,
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
