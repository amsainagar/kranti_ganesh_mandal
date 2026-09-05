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

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  final _hive = HiveService.instance;
  final _uuid = const Uuid();
  List<Map<String, dynamic>> _games = [];

  static List<Map<String, dynamic>> _sampleGames(AppLocalizations l10n) {
    return [
      {
        'id': '1',
        'name': l10n.gameTugOfWar,
        'participants': 8,
        'winner1': '',
        'winner2': '',
        'winner3': '',
        'updatedAt': '2026-08-12T10:00:00.000',
        'createdAt': '2026-08-12T10:00:00.000',
      },
      {
        'id': '2',
        'name': l10n.gameMatkiPhod,
        'participants': 12,
        'winner1': '',
        'winner2': '',
        'winner3': '',
        'updatedAt': '2026-08-13T12:00:00.000',
        'createdAt': '2026-08-13T12:00:00.000',
      },
      {
        'id': '3',
        'name': l10n.gameRangoli,
        'participants': 15,
        'winner1': 'Shiv Shakti Team',
        'winner2': 'Ganesh Mitra',
        'winner3': 'Saigaon Stars',
        'updatedAt': '2026-08-14T16:00:00.000',
        'createdAt': '2026-08-14T16:00:00.000',
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadGames());
  }

  Future<void> _loadGames() async {
    final l10n = context.l10n;
    await _hive.openBox(HiveBoxNames.games);
    final stored = _hive.getAll(HiveBoxNames.games);
    if (stored.isEmpty) {
      for (final game in _sampleGames(l10n)) {
        await _hive.put(
          HiveBoxNames.games,
          game['id']!.toString(),
          Map<String, dynamic>.from(game),
        );
      }
    }
    if (!mounted) return;
    setState(() {
      _games = RecordTimestamps.sortLatest(_hive.getAll(HiveBoxNames.games));
    });
  }

  Future<void> _saveGame(
    Map<String, dynamic> game, {
    Map<String, dynamic>? existing,
  }) async {
    await _hive.put(
      HiveBoxNames.games,
      game['id']!.toString(),
      RecordTimestamps.stamp(game, existing: existing),
    );
    await _loadGames();
  }

  List<String> _winnerLines(AppLocalizations l10n, Map<String, dynamic> game) {
    final lines = <String>[];
    final winner1 = game['winner1']?.toString().trim() ?? '';
    final winner2 = game['winner2']?.toString().trim() ?? '';
    final winner3 = game['winner3']?.toString().trim() ?? '';

    if (winner1.isNotEmpty) lines.add('${l10n.firstWinner}: $winner1');
    if (winner2.isNotEmpty) lines.add('${l10n.secondWinner}: $winner2');
    if (winner3.isNotEmpty) lines.add('${l10n.thirdWinner}: $winner3');
    return lines;
  }

  Future<Map<String, dynamic>?> _showGameFormDialog({
    required String title,
    Map<String, dynamic>? existing,
  }) async {
    final l10n = context.l10n;
    final nameController = TextEditingController(
      text: existing?['name']?.toString() ?? '',
    );
    final participantsController = TextEditingController(
      text: existing?['participants']?.toString() ?? '',
    );
    final winner1Controller = TextEditingController(
      text: existing?['winner1']?.toString() ?? '',
    );
    final winner2Controller = TextEditingController(
      text: existing?['winner2']?.toString() ?? '',
    );
    final winner3Controller = TextEditingController(
      text: existing?['winner3']?.toString() ?? '',
    );

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          scrollable: true,
          title: Text(title),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.gameName),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: participantsController,
                  decoration: InputDecoration(labelText: l10n.participants),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                NameTextField(
                  controller: winner1Controller,
                  decoration: InputDecoration(
                    labelText: l10n.firstWinner,
                    hintText: l10n.winnerOptionalHint,
                  ),
                ),
                const SizedBox(height: 12),
                NameTextField(
                  controller: winner2Controller,
                  decoration: InputDecoration(
                    labelText: l10n.secondWinner,
                    hintText: l10n.winnerOptionalHint,
                  ),
                ),
                const SizedBox(height: 12),
                NameTextField(
                  controller: winner3Controller,
                  decoration: InputDecoration(
                    labelText: l10n.thirdWinner,
                    hintText: l10n.winnerOptionalHint,
                  ),
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
                final name = nameController.text.trim();
                final participants =
                    int.tryParse(participantsController.text.trim());

                if (name.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(l10n.fieldRequired)),
                  );
                  return;
                }
                if (participants == null || participants <= 0) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text(l10n.invalidParticipants)),
                  );
                  return;
                }

                Navigator.pop(dialogContext, {
                  'id': existing?['id'] ?? _uuid.v4(),
                  'name': name,
                  'participants': participants,
                  'winner1': NameFormatter.format(winner1Controller.text),
                  'winner2': NameFormatter.format(winner2Controller.text),
                  'winner3': NameFormatter.format(winner3Controller.text),
                });
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddDialog() async {
    final l10n = context.l10n;
    final game = await _showGameFormDialog(title: l10n.addGame);
    if (game == null || !mounted) return;
    await _saveGame(game);
  }

  Future<void> _showEditDialog(Map<String, dynamic> existing) async {
    final l10n = context.l10n;
    final game = await _showGameFormDialog(
      title: l10n.editGame,
      existing: existing,
    );
    if (game == null || !mounted) return;
    await _saveGame(game, existing: existing);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canEdit = AuthController.instance.canEdit;

    return AppScaffold(
      title: l10n.games,
      actions: const [LanguageToggleButton()],
      body: _games.isEmpty && !canEdit
          ? EmptyState(
              icon: Icons.emoji_events_outlined,
              title: l10n.noGamesYet,
              message: l10n.addGamesMessage,
            )
          : Column(
              children: [
                if (canEdit)
                  TopAddButton(
                    label: l10n.addGame,
                    onPressed: _showAddDialog,
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    canEdit ? l10n.tapGameToEdit : l10n.readOnlyMode,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _games.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final game = _games[index];
                      final participants = game['participants'] as int? ??
                          int.tryParse(game['participants']?.toString() ?? '') ??
                          0;
                      final winnerLines = _winnerLines(l10n, game);

                      return Card(
                        child: ListTile(
                          onTap: canEdit ? () => _showEditDialog(game) : null,
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.emoji_events,
                              color: AppColors.secondary,
                            ),
                          ),
                          title: Text(game['name']?.toString() ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.participantsCount(participants)),
                              Text(formatRecordDateTime(context, game)),
                              for (final line in winnerLines) ...[
                                const SizedBox(height: 4),
                                Text(line),
                              ],
                            ],
                          ),
                          isThreeLine: winnerLines.isNotEmpty,
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
