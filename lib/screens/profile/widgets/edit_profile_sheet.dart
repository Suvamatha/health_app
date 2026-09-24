import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/profile/profile_prefs.dart';
import '../../../core/theme/app_radius.dart';

/// Opens the edit sheet and returns true if anything was saved, so the
/// caller knows to reload the profile it's displaying.
Future<bool?> showEditProfileSheet(
  BuildContext context, {
  required ProfileData current,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => _EditProfileSheet(current: current),
  );
}

class _EditProfileSheet extends StatefulWidget {
  final ProfileData current;
  const _EditProfileSheet({required this.current});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nameController;
  late String? _avatarPath;
  late Set<WellnessGoal> _selectedGoals;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.current.name);
    _avatarPath = widget.current.avatarPath;
    _selectedGoals = widget.current.goals.toSet();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 85, maxWidth: 800);
    if (picked == null) return;

    // Save under a fresh, timestamped filename (rather than overwriting the
    // same path) so Flutter's image cache never shows a stale photo after
    // the user picks a new one.
    final directory = await getApplicationDocumentsDirectory();
    final newPath =
        '${directory.path}/profile_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(picked.path).copy(newPath);

    final oldPath = _avatarPath;
    setState(() => _avatarPath = newPath);

    if (oldPath != null && oldPath != newPath) {
      final oldFile = File(oldPath);
      if (await oldFile.exists()) await oldFile.delete();
    }
  }

  Future<void> _showPhotoSourceSheet() async {
    final theme = Theme.of(context);
    await showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_camera_outlined, color: theme.colorScheme.primary),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined, color: theme.colorScheme.primary),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_avatarPath != null)
              ListTile(
                leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                title: const Text('Remove photo'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  setState(() => _avatarPath = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final name = _nameController.text.trim();
    await ProfilePrefs.saveName(name.isEmpty ? 'there' : name);
    await ProfilePrefs.saveAvatarPath(_avatarPath);
    await ProfilePrefs.saveGoals(_selectedGoals.toList());
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit profile', style: theme.textTheme.displayLarge),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _showPhotoSourceSheet,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor: theme.colorScheme.surface,
                        backgroundImage: _avatarPath != null ? FileImage(File(_avatarPath!)) : null,
                        child: _avatarPath == null
                            ? Icon(Icons.person_outline, size: 36, color: theme.colorScheme.primary)
                            : null,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                          border: Border.all(color: theme.colorScheme.surface, width: 2),
                        ),
                        child: Icon(Icons.edit, size: 14, color: theme.colorScheme.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Your name', style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Your Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
              ),
            ),
            const SizedBox(height: 20),
            Text('Wellness goals', style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: WellnessGoal.values.map((goal) {
                final isSelected = _selectedGoals.contains(goal);
                return FilterChip(
                  label: Text('${goal.emoji} ${goal.label}'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedGoals.add(goal);
                      } else {
                        _selectedGoals.remove(goal);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
