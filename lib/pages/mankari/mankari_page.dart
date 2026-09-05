import 'package:flutter/material.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/core/constants/app_colors.dart';
import 'package:kranti_ganesh_mandal/core/locale/l10n_extensions.dart';
import 'package:kranti_ganesh_mandal/core/utils/name_formatter.dart';
import 'package:kranti_ganesh_mandal/core/utils/record_timestamps.dart';
import 'package:kranti_ganesh_mandal/core/widgets/app_widgets.dart';
import 'package:kranti_ganesh_mandal/core/widgets/language_toggle_button.dart';
import 'package:kranti_ganesh_mandal/core/widgets/name_text_field.dart';
import 'package:kranti_ganesh_mandal/l10n/app_localizations.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';
import 'package:uuid/uuid.dart';

class MankariPage extends StatefulWidget {
  const MankariPage({super.key});

  @override
  State<MankariPage> createState() => _MankariPageState();
}

class _MankariPageState extends State<MankariPage> {
  final _hive = HiveService.instance;
  final _uuid = const Uuid();
  List<Map<String, dynamic>> _volunteers = [];

  static const _roleKeys = [
    'decorationLead',
    'foodCommittee',
    'security',
    'culturalEvents',
  ];

  static const _shiftKeys = ['morning', 'evening', 'night', 'allDay'];

  static const _sampleVolunteers = [
    {'id': '1', 'name': 'Amit Jadhav', 'roleKey': 'decorationLead', 'shiftKey': 'morning', 'updatedAt': '2026-08-11T08:00:00.000', 'createdAt': '2026-08-11T08:00:00.000'},
    {'id': '2', 'name': 'Priya Kulkarni', 'roleKey': 'foodCommittee', 'shiftKey': 'evening', 'updatedAt': '2026-08-12T17:00:00.000', 'createdAt': '2026-08-12T17:00:00.000'},
    {'id': '3', 'name': 'Suresh More', 'roleKey': 'security', 'shiftKey': 'night', 'updatedAt': '2026-08-13T22:00:00.000', 'createdAt': '2026-08-13T22:00:00.000'},
    {'id': '4', 'name': 'Meera Shinde', 'roleKey': 'culturalEvents', 'shiftKey': 'allDay', 'updatedAt': '2026-08-14T09:30:00.000', 'createdAt': '2026-08-14T09:30:00.000'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadVolunteers());
  }

  Future<void> _loadVolunteers() async {
    await _hive.openBox(HiveBoxNames.mankari);
    final stored = _hive.getAll(HiveBoxNames.mankari);
    if (stored.isEmpty) {
      for (final volunteer in _sampleVolunteers) {
        await _hive.put(
          HiveBoxNames.mankari,
          volunteer['id']!.toString(),
          Map<String, dynamic>.from(volunteer),
        );
      }
    }
    if (!mounted) return;
    setState(() {
      _volunteers = RecordTimestamps.sortLatest(_hive.getAll(HiveBoxNames.mankari));
    });
  }

  Future<void> _saveVolunteer(
    Map<String, dynamic> volunteer, {
    Map<String, dynamic>? existing,
  }) async {
    await _hive.put(
      HiveBoxNames.mankari,
      volunteer['id']!.toString(),
      RecordTimestamps.stamp(volunteer, existing: existing),
    );
    await _loadVolunteers();
  }

  static String _roleLabel(AppLocalizations l10n, String key) {
    return switch (key) {
      'decorationLead' => l10n.roleDecorationLead,
      'foodCommittee' => l10n.roleFoodCommittee,
      'security' => l10n.roleSecurity,
      'culturalEvents' => l10n.roleCulturalEvents,
      _ => key,
    };
  }

  static String _shiftLabel(AppLocalizations l10n, String key) {
    return switch (key) {
      'morning' => l10n.shiftMorning,
      'evening' => l10n.shiftEvening,
      'night' => l10n.shiftNight,
      'allDay' => l10n.shiftAllDay,
      _ => key,
    };
  }

  Future<Map<String, dynamic>?> _showVolunteerFormDialog({
    required String title,
    Map<String, dynamic>? existing,
  }) async {
    final l10n = context.l10n;
    final nameController = TextEditingController(
      text: existing?['name']?.toString() ?? '',
    );
    var roleKey = existing?['roleKey']?.toString() ?? _roleKeys.first;
    var shiftKey = existing?['shiftKey']?.toString() ?? _shiftKeys.first;

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
                    NameTextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: l10n.name),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      key: ValueKey(roleKey),
                      initialValue: roleKey,
                      decoration: InputDecoration(labelText: l10n.role),
                      items: _roleKeys
                          .map(
                            (key) => DropdownMenuItem(
                              value: key,
                              child: Text(_roleLabel(l10n, key)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => roleKey = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      key: ValueKey(shiftKey),
                      initialValue: shiftKey,
                      decoration: InputDecoration(labelText: l10n.shift),
                      items: _shiftKeys
                          .map(
                            (key) => DropdownMenuItem(
                              value: key,
                              child: Text(_shiftLabel(l10n, key)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => shiftKey = value);
                        }
                      },
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
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(content: Text(l10n.fieldRequired)),
                      );
                      return;
                    }

                    Navigator.pop(dialogContext, {
                      'id': existing?['id'] ?? _uuid.v4(),
                      'name': name,
                      'roleKey': roleKey,
                      'shiftKey': shiftKey,
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

  Future<void> _showAddDialog() async {
    final l10n = context.l10n;
    final volunteer = await _showVolunteerFormDialog(title: l10n.addMankari);
    if (volunteer == null || !mounted) return;
    await _saveVolunteer(volunteer);
  }

  Future<void> _showEditDialog(Map<String, dynamic> existing) async {
    final l10n = context.l10n;
    final volunteer = await _showVolunteerFormDialog(
      title: l10n.editMankari,
      existing: existing,
    );
    if (volunteer == null || !mounted) return;
    await _saveVolunteer(volunteer, existing: existing);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canEdit = AuthController.instance.canEdit;

    return AppScaffold(
      title: l10n.mankari,
      actions: const [LanguageToggleButton()],
      body: _volunteers.isEmpty && !canEdit
          ? EmptyState(
              icon: Icons.groups_outlined,
              title: l10n.noVolunteersYet,
              message: l10n.addVolunteersMessage,
            )
          : Column(
              children: [
                if (canEdit)
                  TopAddButton(
                    label: l10n.addMankari,
                    onPressed: _showAddDialog,
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    canEdit ? l10n.tapMankariToEdit : l10n.readOnlyMode,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _volunteers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final volunteer = _volunteers[index];
                      final name = volunteer['name']?.toString() ?? '';

                      return Card(
                        child: ListTile(
                          onTap: canEdit ? () => _showEditDialog(volunteer) : null,
                          leading: CircleAvatar(
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.12),
                            child: Text(
                              name.isNotEmpty ? name[0] : '?',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _roleLabel(
                                  l10n,
                                  volunteer['roleKey']?.toString() ?? '',
                                ),
                              ),
                              Text(formatRecordDateTime(context, volunteer)),
                            ],
                          ),
                          trailing: Chip(
                            label: Text(
                              _shiftLabel(
                                l10n,
                                volunteer['shiftKey']?.toString() ?? '',
                              ),
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor:
                                AppColors.secondary.withValues(alpha: 0.12),
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
