import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/core/constants/app_colors.dart';
import 'package:kranti_ganesh_mandal/core/locale/l10n_extensions.dart';
import 'package:kranti_ganesh_mandal/core/utils/record_timestamps.dart';
import 'package:kranti_ganesh_mandal/core/widgets/app_widgets.dart';
import 'package:kranti_ganesh_mandal/core/widgets/language_toggle_button.dart';
import 'package:kranti_ganesh_mandal/l10n/app_localizations.dart';
import 'package:kranti_ganesh_mandal/services/gallery_service.dart';
import 'package:kranti_ganesh_mandal/services/hive_service.dart';
import 'package:uuid/uuid.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final _hive = HiveService.instance;
  final _galleryService = GalleryService.instance;
  final _uuid = const Uuid();

  static const _allTypesKey = 'all';
  static const _allYearsKey = 'all';
  static const _years = [2023, 2024, 2025, 2026];
  static const _typeKeys = [
    'visarjan2025',
    'aartiCeremony',
    'culturalNight',
    'pranPratishtha',
  ];

  List<Map<String, dynamic>> _photos = [];
  String _filterTypeKey = _allTypesKey;
  String _filterYearKey = _allYearsKey;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPhotos());
  }

  static String _typeLabel(AppLocalizations l10n, String key) {
    return switch (key) {
      'visarjan2025' => l10n.albumVisarjan2025,
      'aartiCeremony' => l10n.albumAartiCeremony,
      'culturalNight' => l10n.albumCulturalNight,
      'pranPratishtha' => l10n.albumPranPratishtha,
      _ => key,
    };
  }

  int _photoYear(Map<String, dynamic> photo) {
    final stored = photo['year'];
    if (stored is int) return stored;
    return int.tryParse(stored?.toString() ?? '') ?? _years.last;
  }

  String _photoCaption(AppLocalizations l10n, Map<String, dynamic> photo) {
    final type = _typeLabel(l10n, photo['typeKey']?.toString() ?? '');
    return '$type · ${_photoYear(photo)}';
  }

  String _photoDetails(BuildContext context, Map<String, dynamic> photo) {
    final l10n = context.l10n;
    return '${_photoCaption(l10n, photo)}\n${formatRecordDateTime(context, photo)}';
  }

  Future<void> _loadPhotos() async {
    await _hive.openBox(HiveBoxNames.gallery);
    const migrationKey = 'gallery_year_migrated';
    final migrationDone =
        _hive.get(HiveBoxNames.settings, migrationKey)?['done'] == true;

    if (!migrationDone) {
      final photos = _hive.getAll(HiveBoxNames.gallery);
      for (final photo in photos) {
        if (photo['year'] == null) {
          final id = photo['id']?.toString();
          if (id != null) {
            await _hive.put(
              HiveBoxNames.gallery,
              id,
              {...photo, 'year': _years.last},
            );
          }
        }
      }
      await _hive.put(HiveBoxNames.settings, migrationKey, {'done': true});
    }

    if (!mounted) return;
    setState(() {
      _photos = RecordTimestamps.sortLatest(_hive.getAll(HiveBoxNames.gallery));
      _loading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredPhotos {
    return _photos.where((photo) {
      final matchesType = _filterTypeKey == _allTypesKey ||
          photo['typeKey']?.toString() == _filterTypeKey;
      final matchesYear = _filterYearKey == _allYearsKey ||
          _photoYear(photo).toString() == _filterYearKey;
      return matchesType && matchesYear;
    }).toList();
  }

  Future<void> _uploadPhoto() async {
    final l10n = context.l10n;
    final picked = await _galleryService.pickImage();
    if (picked == null || !mounted) return;

    final saved = await _showUploadDialog(picked);
    if (saved == null || !mounted) return;

    try {
      final filePath = await _galleryService.saveImageFile(picked);
      await _hive.put(
        HiveBoxNames.gallery,
        saved['id']!.toString(),
        RecordTimestamps.stamp({
          ...saved,
          'filePath': filePath,
        }),
      );
      await _loadPhotos();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.uploadFailed)),
      );
    }
  }

  Future<Map<String, dynamic>?> _showUploadDialog(XFile picked) async {
    final l10n = context.l10n;
    var typeKey = _typeKeys.first;
    final currentYear = DateTime.now().year;
    var year = _years.contains(currentYear) ? currentYear : _years.last;

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              scrollable: true,
              title: Text(l10n.addPhoto),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.file(
                          File(picked.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      key: ValueKey('type-$typeKey'),
                      initialValue: typeKey,
                      decoration: InputDecoration(labelText: l10n.photoType),
                      items: _typeKeys
                          .map(
                            (key) => DropdownMenuItem(
                              value: key,
                              child: Text(_typeLabel(l10n, key)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => typeKey = value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      key: ValueKey('year-$year'),
                      initialValue: year,
                      decoration: InputDecoration(labelText: l10n.photoYear),
                      items: _years
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text('$value'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => year = value);
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
                    Navigator.pop(dialogContext, {
                      'id': _uuid.v4(),
                      'typeKey': typeKey,
                      'year': year,
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

  Future<void> _confirmDelete(Map<String, dynamic> photo) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.deletePhoto),
          content: Text(l10n.deletePhotoConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.deletePhoto),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    final id = photo['id']?.toString();
    final filePath = photo['filePath']?.toString();
    if (id != null) {
      await _hive.delete(HiveBoxNames.gallery, id);
    }
    if (filePath != null && filePath.isNotEmpty) {
      await _galleryService.deleteImageFile(filePath);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.photoDeleted)),
    );
    await _loadPhotos();
  }

  void _openPhotoViewer(Map<String, dynamic> photo, {required bool canEdit}) {
    final filePath = photo['filePath']?.toString();
    if (filePath == null || !File(filePath).existsSync()) return;

    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _photoCaption(l10n, photo),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: AppColors.primary,
                      onPressed: canEdit
                          ? () {
                              Navigator.pop(dialogContext);
                              _confirmDelete(photo);
                            }
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ],
                ),
              ),
              InteractiveViewer(
                child: Image.file(
                  File(filePath),
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterDropdown<T>({
    required Key key,
    required T value,
    required String label,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      key: key,
      isExpanded: true,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final photos = _filteredPhotos;
    final canEdit = AuthController.instance.canEdit;

    return AppScaffold(
      title: l10n.gallery,
      actions: const [LanguageToggleButton()],
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (canEdit)
                  TopAddButton(
                    label: l10n.addPhoto,
                    onPressed: _uploadPhoto,
                    icon: Icons.add_photo_alternate,
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown<String>(
                          key: ValueKey('filter-year-$_filterYearKey'),
                          value: _filterYearKey,
                          label: l10n.photoYear,
                          items: [
                            DropdownMenuItem(
                              value: _allYearsKey,
                              child: Text(l10n.allYears),
                            ),
                            ..._years.map(
                              (year) => DropdownMenuItem(
                                value: year.toString(),
                                child: Text('$year'),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _filterYearKey = value);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFilterDropdown<String>(
                          key: ValueKey('filter-type-$_filterTypeKey'),
                          value: _filterTypeKey,
                          label: l10n.photoType,
                          items: [
                            DropdownMenuItem(
                              value: _allTypesKey,
                              child: Text(l10n.allPhotoTypes),
                            ),
                            ..._typeKeys.map(
                              (key) => DropdownMenuItem(
                                value: key,
                                child: Text(_typeLabel(l10n, key)),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() => _filterTypeKey = value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: photos.isEmpty
                      ? EmptyState(
                          icon: Icons.photo_library_outlined,
                          title: l10n.noPhotosYet,
                          message: l10n.addPhotosMessage,
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.82,
                          ),
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            final photo = photos[index];
                            final filePath =
                                photo['filePath']?.toString() ?? '';
                            final file = File(filePath);
                            final hasFile = filePath.isNotEmpty && file.existsSync();
                            final cacheWidth = (MediaQuery.sizeOf(context).width /
                                    2 *
                                    MediaQuery.devicePixelRatioOf(context))
                                .round();

                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: hasFile
                                    ? () => _openPhotoViewer(
                                          photo,
                                          canEdit: canEdit,
                                        )
                                    : null,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          if (hasFile)
                                            Image.file(
                                              file,
                                              fit: BoxFit.cover,
                                              cacheWidth: cacheWidth,
                                            )
                                          else
                                            Container(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.08),
                                              child: const Icon(
                                                Icons.broken_image_outlined,
                                                size: 40,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          if (canEdit)
                                            Positioned(
                                              top: 6,
                                              right: 6,
                                              child: Material(
                                                color: Colors.black54,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  onTap: () =>
                                                      _confirmDelete(photo),
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(6),
                                                    child: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        _photoDetails(context, photo),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
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
