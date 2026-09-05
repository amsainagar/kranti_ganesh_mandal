import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kranti_ganesh_mandal/core/constants/app_colors.dart';
import 'package:kranti_ganesh_mandal/core/locale/l10n_extensions.dart';
import 'package:kranti_ganesh_mandal/core/widgets/app_widgets.dart';
import 'package:kranti_ganesh_mandal/core/widgets/language_toggle_button.dart';
import 'package:kranti_ganesh_mandal/l10n/app_localizations.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';
import 'package:kranti_ganesh_mandal/services/reports_service.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final _hive = HiveService.instance;
  List<Map<String, dynamic>> _pledges = [];
  List<Map<String, dynamic>> _cashbookEntries = [];
  List<Map<String, dynamic>> _volunteers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    await Future.wait([
      _hive.openBox(HiveBoxNames.pledges),
      _hive.openBox(HiveBoxNames.cashbook),
      _hive.openBox(HiveBoxNames.mankari),
    ]);

    if (!mounted) return;
    setState(() {
      _pledges = _hive.getAll(HiveBoxNames.pledges);
      _cashbookEntries = _hive.getAll(HiveBoxNames.cashbook);
      _volunteers = _hive.getAll(HiveBoxNames.mankari);
      _loading = false;
    });
  }

  List<_ReportItem> _buildReports(AppLocalizations l10n, NumberFormat currency) {
    final collected = ReportsService.pledgeCollected(_pledges);
    final pending = ReportsService.pledgePending(_pledges);
    final balance = ReportsService.cashbookBalance(_cashbookEntries);

    return [
      _ReportItem(
        title: l10n.pledgeSummary,
        description: l10n.pledgeSummaryDetail(
          currency.format(collected),
          currency.format(pending),
        ),
        value: currency.format(ReportsService.pledgeTotal(_pledges)),
        icon: Icons.menu_book_rounded,
      ),
      _ReportItem(
        title: l10n.cashbookBalance,
        description: l10n.cashbookBalanceDetail(
          currency.format(ReportsService.cashbookIncome(_cashbookEntries)),
          currency.format(ReportsService.cashbookExpense(_cashbookEntries)),
        ),
        value: currency.format(balance),
        icon: Icons.account_balance_wallet_rounded,
      ),
      _ReportItem(
        title: l10n.volunteerHours,
        description: l10n.volunteerHoursDesc,
        value: '${ReportsService.mankariShiftCount(_volunteers)}',
        icon: Icons.groups_rounded,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currency = NumberFormat.currency(
      locale: currencyLocaleFor(context),
      symbol: '₹',
    );
    final reports = _buildReports(l10n, currency);

    return AppScaffold(
      title: l10n.reports,
      actions: const [LanguageToggleButton()],
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: reports.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final report = reports[index];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              report.icon,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report.title,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(report.description),
                              ],
                            ),
                          ),
                          Text(
                            report.value,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
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

class _ReportItem {
  const _ReportItem({
    required this.title,
    required this.description,
    required this.value,
    required this.icon,
  });

  final String title;
  final String description;
  final String value;
  final IconData icon;
}
