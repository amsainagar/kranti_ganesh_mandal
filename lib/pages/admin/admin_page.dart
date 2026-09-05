import 'package:flutter/material.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/core/constants/app_colors.dart';
import 'package:kranti_ganesh_mandal/core/locale/l10n_extensions.dart';
import 'package:kranti_ganesh_mandal/core/widgets/app_widgets.dart';
import 'package:kranti_ganesh_mandal/core/widgets/language_toggle_button.dart';
import 'package:kranti_ganesh_mandal/core/widgets/name_text_field.dart';
import 'package:kranti_ganesh_mandal/l10n/app_localizations.dart';
import 'package:kranti_ganesh_mandal/core/utils/name_formatter.dart';
import 'package:kranti_ganesh_mandal/core/utils/record_timestamps.dart';
import 'package:kranti_ganesh_mandal/models/app_role.dart';
import 'package:kranti_ganesh_mandal/models/user_status.dart';
import 'package:kranti_ganesh_mandal/services/user_service.dart';
import 'package:kranti_ganesh_mandal/services/whatsapp_service.dart';
import 'package:uuid/uuid.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _userService = UserService.instance;
  final _uuid = const Uuid();
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUsers());
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;
    setState(() {
      _users = RecordTimestamps.sortLatest(_userService.getAllUsers());
    });
  }

  static String _roleLabel(AppLocalizations l10n, String role) {
    return switch (role) {
      AppRole.superAdmin => l10n.roleSuperAdmin,
      AppRole.admin => l10n.roleAdmin,
      AppRole.member => l10n.roleMember,
      AppRole.user => l10n.roleUser,
      _ => role,
    };
  }

  Future<Map<String, dynamic>?> _showUserFormDialog({
    required String title,
    Map<String, dynamic>? existing,
  }) async {
    final l10n = context.l10n;
    final nameController = TextEditingController(
      text: existing?['name']?.toString() ?? '',
    );
    final mobileController = TextEditingController(
      text: existing?['mobile']?.toString() ?? '',
    );
    final passwordController = TextEditingController(
      text: existing?['password']?.toString() ?? '',
    );
    var role = existing?['role']?.toString() ?? AppRole.user;
    final isDefaultSuperAdmin =
        UserService.isDefaultSuperAdmin(existing?['id']?.toString());
    if (isDefaultSuperAdmin) {
      role = AppRole.superAdmin;
    }
    var isActive = existing == null
        ? true
        : UserStatus.isActive(existing);

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
                    TextField(
                      controller: mobileController,
                      decoration: InputDecoration(labelText: l10n.mobileNumber),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: l10n.password),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      obscureText: true,
                      obscuringCharacter: '*',
                    ),
                    const SizedBox(height: 12),
                    if (isDefaultSuperAdmin)
                      InputDecorator(
                        decoration: InputDecoration(labelText: l10n.userRole),
                        child: Text(_roleLabel(l10n, AppRole.superAdmin)),
                      )
                    else
                      DropdownButtonFormField<String>(
                        key: ValueKey(role),
                        initialValue: role,
                        decoration: InputDecoration(labelText: l10n.userRole),
                        items: AppRole.assignable
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(_roleLabel(l10n, value)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() => role = value);
                          }
                        },
                      ),
                    if (!isDefaultSuperAdmin) ...[
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.userStatus),
                        subtitle: Text(
                          isActive ? l10n.userActive : l10n.userInactive,
                        ),
                        value: isActive,
                        onChanged: (value) {
                          setDialogState(() => isActive = value);
                        },
                      ),
                    ],
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
                    final mobile = AuthController.normalizeMobile(
                      mobileController.text.trim(),
                    );
                    final password = passwordController.text.trim();

                    if (name.isEmpty) {
                      _showError(dialogContext, l10n.fieldRequired);
                      return;
                    }
                    if (!AuthController.isValidMobile(mobile)) {
                      _showError(dialogContext, l10n.invalidMobile);
                      return;
                    }
                    if (!AuthController.isValidPassword(password)) {
                      _showError(dialogContext, l10n.invalidPassword);
                      return;
                    }

                    final duplicate = _userService.findByMobile(mobile);
                    final existingId = existing?['id']?.toString();
                    if (duplicate != null && duplicate['id'] != existingId) {
                      _showError(dialogContext, l10n.mobileAlreadyExists);
                      return;
                    }

                    Navigator.pop(dialogContext, {
                      'id': existingId ?? _uuid.v4(),
                      'name': name,
                      'mobile': mobile,
                      'password': password,
                      'role': isDefaultSuperAdmin ? AppRole.superAdmin : role,
                      'status':
                          isActive ? UserStatus.active : UserStatus.inactive,
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

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _saveUser(
    Map<String, dynamic> user, {
    Map<String, dynamic>? existing,
  }) async {
    await _userService.saveUser(
      RecordTimestamps.stamp(user, existing: existing),
    );
    await _loadUsers();
  }

  Future<void> _showAddUserDialog() async {
    final user = await _showUserFormDialog(title: context.l10n.addUser);
    if (user == null || !mounted) return;
    await _saveUser(user);
    await _offerRegistrationWhatsApp(user);
  }

  Future<void> _offerRegistrationWhatsApp(Map<String, dynamic> user) async {
    final l10n = context.l10n;
    final name = user['name']?.toString() ?? '';
    final mobile = user['mobile']?.toString() ?? '';
    final password = user['password']?.toString() ?? '';

    final shouldSend = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.sendRegistrationWhatsApp),
        content: Text(l10n.sendRegistrationWhatsAppMessage(name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.skipForNow),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.sendViaWhatsApp),
          ),
        ],
      ),
    );

    if (shouldSend != true || !mounted) return;

    final message = l10n.registrationWhatsAppBody(
      name,
      l10n.appName,
      mobile,
      password,
    );
    final opened = await WhatsAppService.instance.openRegistrationMessage(
      mobile: mobile,
      message: message,
    );

    if (!opened && mounted) {
      _showError(context, l10n.whatsAppNotAvailable);
    }
  }

  Future<void> _showEditUserDialog(Map<String, dynamic> existing) async {
    final user = await _showUserFormDialog(
      title: context.l10n.editUser,
      existing: existing,
    );
    if (user == null || !mounted) return;
    await _saveUser(user, existing: existing);
  }

  Future<void> _confirmDelete(Map<String, dynamic> user) async {
    final l10n = context.l10n;
    final userId = user['id']?.toString();
    if (userId == null) return;

    if (UserService.isDefaultSuperAdmin(userId)) {
      _showError(context, l10n.cannotDeleteSuperAdmin);
      return;
    }
    if (userId == AuthController.instance.userId) {
      _showError(context, l10n.cannotDeleteSelf);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteUser),
        content: Text(l10n.deleteUserConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.deleteUser),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await _userService.deleteUser(userId);
    await _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      title: l10n.admin,
      actions: const [LanguageToggleButton()],
      body: Column(
        children: [
          TopAddButton(
            label: l10n.addUser,
            onPressed: _showAddUserDialog,
            icon: Icons.person_add,
          ),
          Expanded(
            child: _users.isEmpty
                ? EmptyState(
                    icon: Icons.admin_panel_settings_outlined,
                    title: l10n.noUsersYet,
                    message: l10n.addUsersMessage,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _users.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      final isDefaultSuperAdmin =
                          UserService.isDefaultSuperAdmin(
                        user['id']?.toString(),
                      );

                      return Card(
                        child: ListTile(
                          onTap: () => _showEditUserDialog(user),
                          leading: CircleAvatar(
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.12),
                            child: Text(
                              (user['name']?.toString().isNotEmpty == true
                                      ? user['name']!.toString()[0]
                                      : '?')
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(user['name']?.toString() ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user['mobile']} · ${_roleLabel(l10n, user['role']?.toString() ?? '')}',
                              ),
                              const SizedBox(height: 4),
                              StatusBadge(
                                label: UserStatus.isActive(user)
                                    ? l10n.userActive
                                    : l10n.userInactive,
                                isCompleted: UserStatus.isActive(user),
                              ),
                              Text(formatRecordDateTime(context, user)),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: isDefaultSuperAdmin
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  color: AppColors.primary,
                                  onPressed: () => _confirmDelete(user),
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
