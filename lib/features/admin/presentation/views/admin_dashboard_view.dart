import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/app_settings.dart';
import '../../../../core/models/app_user.dart';
import '../../../../core/models/department.dart';
import '../../../../core/models/research_paper.dart';
import '../../../admin/domain/settings_providers.dart';
import '../../../auth/domain/auth_providers.dart';
import '../../../papers/domain/paper_providers.dart';
import '../../../shared/domain/department_providers.dart';
import '../../../shared/domain/user_providers.dart';
import '../../../shared/widgets/gradient_app_bar.dart';

class AdminDashboardView extends ConsumerStatefulWidget {
  const AdminDashboardView({super.key});

  @override
  ConsumerState<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends ConsumerState<AdminDashboardView> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(appSettingsStreamProvider);
    final List<({String label, IconData icon, Widget Function(WidgetRef) builder})> sections = [
      (label: 'Automation', icon: Icons.auto_awesome_outlined, builder: (WidgetRef ref) => _SettingsTab(settingsAsync: settingsAsync)),
      (label: 'Departments', icon: Icons.apartment_outlined, builder: (WidgetRef ref) => const _DepartmentsTab()),
      (label: 'Reviewers', icon: Icons.verified_user_outlined, builder: (WidgetRef ref) => const _ReviewersTab()),
      (label: 'Users', icon: Icons.people_alt_outlined, builder: (WidgetRef ref) => const _AdminsTab()),
      (label: 'Papers', icon: Icons.library_books_outlined, builder: (WidgetRef ref) => const _PapersTab()),
    ];



    final content = sections[_index].builder(ref);
    final isWide = MediaQuery.of(context).size.width >= 1100;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: GradientAppBar(
        userName: ref.read(authUserChangesProvider).valueOrNull?.fullName ?? 'Admin',
        onLogout: () => ref.read(authRepositoryProvider).signOut(),
        onNotifications: () {},
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isWide)
            _AdminNavPanel(
              sections: sections,
              selectedIndex: _index,
              onSelect: (value) => setState(() => _index = value),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: isWide ? 0 : 12, right: 16, top: 16, bottom: 24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: content,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: isWide
          ? null
          : NavigationBar(
              selectedIndex: _index,
              destinations: sections
                  .map((section) => NavigationDestination(icon: Icon(section.icon), label: section.label))
                  .toList(),
              onDestinationSelected: (value) => setState(() => _index = value),
            ),
    );
  }
}

class _AdminNavPanel extends StatelessWidget {
  const _AdminNavPanel({required this.sections, required this.selectedIndex, required this.onSelect});

  final List sections;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 20, 24),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 18)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            for (var i = 0; i < sections.length; i++)
              _AdminNavButton(
                label: sections[i].label,
                icon: sections[i].icon,
                isSelected: i == selectedIndex,
                onTap: () => onSelect(i),
                theme: theme,
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _AdminNavButton extends StatelessWidget {
  const _AdminNavButton({required this.label, required this.icon, required this.isSelected, required this.onTap, required this.theme});

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final foreground = isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant;
    final decoration = isSelected
        ? BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4338CA), Color(0xFF2563EB), Color(0xFF7C3AED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(color: Color(0x553138A6), blurRadius: 18, offset: Offset(0, 12)),
            ],
          )
        : BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.transparent,
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: decoration,
          child: Row(
            children: [
              Icon(icon, color: foreground),
              const SizedBox(width: 12),
              Text(label, style: theme.textTheme.labelLarge?.copyWith(color: foreground, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsTab extends ConsumerWidget {
  const _SettingsTab({required this.settingsAsync});

  final AsyncValue<AppSettings> settingsAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return settingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error loading settings: $error')),
      data: (settings) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Automation', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              title: const Text('Enable Gemini AI pre-review'),
              subtitle: const Text('Run Gemini analysis before assigning to reviewers.'),
              value: settings.aiReviewEnabled,
              onChanged: (value) => ref.read(settingsRepositoryProvider).updateAIReview(value),
            ),
          ],
        ),
      ),
    );
  }
}

class _DepartmentsTab extends ConsumerStatefulWidget {
  const _DepartmentsTab();

  @override
  ConsumerState<_DepartmentsTab> createState() => _DepartmentsTabState();
}

class _DepartmentsTabState extends ConsumerState<_DepartmentsTab> {
  final _departmentController = TextEditingController();
  final _subjectController = TextEditingController();
  Department? _selectedDepartment;

  @override
  void dispose() {
    _departmentController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final departmentsAsync = ref.watch(departmentsStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _departmentController,
                  decoration: const InputDecoration(labelText: 'New department'),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: () async {
                  if (_departmentController.text.trim().isEmpty) return;
                  await ref.read(departmentRepositoryProvider).addDepartment(
                        Department(id: '', name: _departmentController.text.trim(), subjects: const []),
                      );
                  _departmentController.clear();
                },
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: departmentsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (departments) {
                if (departments.isEmpty) {
                  return const Center(child: Text('No departments configured yet.'));
                }

                _selectedDepartment ??= departments.first;

                return Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: departments.length,
                        itemBuilder: (context, index) {
                          final dept = departments[index];
                          final selected = _selectedDepartment?.id == dept.id;
                          return ListTile(
                            title: Text(dept.name),
                            selected: selected,
                            onTap: () => setState(() => _selectedDepartment = dept),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => ref.read(departmentRepositoryProvider).deleteDepartment(dept.id),
                            ),
                          );
                        },
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: _selectedDepartment == null
                          ? const SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Subjects in ${_selectedDepartment!.name}',
                                    style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  children: _selectedDepartment!.subjects
                                      .map(
                                        (subject) => Chip(
                                          label: Text(subject),
                                          onDeleted: () => ref
                                              .read(departmentRepositoryProvider)
                                              .removeSubject(_selectedDepartment!.id, subject),
                                        ),
                                      )
                                      .toList(),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _subjectController,
                                        decoration: const InputDecoration(labelText: 'Add subject'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    FilledButton(
                                      onPressed: () async {
                                        if (_subjectController.text.trim().isEmpty) return;
                                        await ref.read(departmentRepositoryProvider).addSubject(
                                              _selectedDepartment!.id,
                                              _subjectController.text.trim(),
                                            );
                                        _subjectController.clear();
                                      },
                                      child: const Text('Add'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewersTab extends ConsumerWidget {
  const _ReviewersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewersAsync = ref.watch(reviewersStreamProvider);

    return reviewersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (reviewers) {
        final pending = reviewers.where((reviewer) => !reviewer.approvedReviewer).toList();
        final approved = reviewers.where((reviewer) => reviewer.approvedReviewer).toList();

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _ReviewerList(title: 'Pending approval', reviewers: pending, pending: true)),
              const SizedBox(width: 24),
              Expanded(child: _ReviewerList(title: 'Active reviewers', reviewers: approved, pending: false)),
            ],
          ),
        );
      },
    );
  }
}

class _AdminsTab extends ConsumerWidget {
  const _AdminsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminsAsync = ref.watch(adminsStreamProvider);
    final currentUser = ref.watch(authUserChangesProvider).valueOrNull;

    return adminsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (admins) {
        final pending = admins.where((admin) => !admin.approvedAdmin).toList();
        final active = admins.where((admin) => admin.approvedAdmin).toList();

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _AdminList(
                  title: 'Pending admins',
                  admins: pending,
                  pending: true,
                  currentUserId: currentUser?.uid,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _AdminList(
                  title: 'Active admins',
                  admins: active,
                  pending: false,
                  currentUserId: currentUser?.uid,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AdminList extends ConsumerWidget {
  const _AdminList({
    required this.title,
    required this.admins,
    required this.pending,
    required this.currentUserId,
  });

  final String title;
  final List<AppUser> admins;
  final bool pending;
  final String? currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRepo = ref.read(userRepositoryProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Expanded(
              child: admins.isEmpty
                  ? const Center(child: Text('No admins in this list.'))
                  : ListView.separated(
                      itemCount: admins.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final admin = admins[index];
                        final isSelf = admin.uid == currentUserId;
                        return ListTile(
                          leading: const Icon(Icons.shield_outlined),
                          title: Text(admin.fullName),
                          subtitle: Text(admin.email),
                          trailing: pending
                              ? IconButton(
                                  icon: const Icon(Icons.check_circle_outline),
                                  onPressed: () => userRepo.setAdminApproval(
                                    uid: admin.uid,
                                    approved: true,
                                  ),
                                )
                              : Switch(
                                  value: admin.approvedAdmin && !admin.blocked,
                                  onChanged: isSelf
                                      ? null
                                      : (value) async {
                                          await userRepo.setAdminApproval(
                                            uid: admin.uid,
                                            approved: value,
                                          );
                                          await userRepo.setUserBlocked(
                                            uid: admin.uid,
                                            blocked: !value,
                                          );
                                        },
                                ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewerList extends ConsumerWidget {
  const _ReviewerList({
    required this.title,
    required this.reviewers,
    required this.pending,
  });

  final String title;
  final List<AppUser> reviewers;
  final bool pending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRepo = ref.read(userRepositoryProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Expanded(
              child: reviewers.isEmpty
                  ? const Center(child: Text('No reviewers here yet.'))
                  : ListView.separated(
                      itemCount: reviewers.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final reviewer = reviewers[index];
                        return ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(reviewer.fullName),
                          subtitle: Text(
                              '${reviewer.department ?? 'No department'} • ${reviewer.subjects.isEmpty ? 'No subjects' : reviewer.subjects.join(', ')}'),
                          trailing: pending
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.block),
                                      onPressed: () => userRepo.setUserBlocked(uid: reviewer.uid, blocked: true),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.check_circle_outline),
                                      onPressed: () => userRepo.setReviewerApproval(uid: reviewer.uid, approved: true),
                                    ),
                                  ],
                                )
                              : Switch(
                                  value: !reviewer.blocked,
                                  onChanged: (value) => userRepo.setUserBlocked(
                                    uid: reviewer.uid,
                                    blocked: !value,
                                  ),
                                ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PapersTab extends ConsumerWidget {
  const _PapersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final papersAsync = ref.watch(allPapersProvider);
    final reviewersAsync = ref.watch(reviewersStreamProvider);

    return papersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error loading papers: $error')),
      data: (papers) => reviewersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error loading reviewers: $error')),
        data: (reviewers) => ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: papers.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final paper = papers[index];
            return ListTile(
              title: Text(paper.title),
              subtitle: Text('Status: ${paper.status.name} • Reviewer: ${paper.assignedReviewerId ?? 'Unassigned'}'),
              trailing: TextButton(
                onPressed: () => _showReassignDialog(context, ref, paper, reviewers),
                child: const Text('Reassign'),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showReassignDialog(
    BuildContext context,
    WidgetRef ref,
    ResearchPaper paper,
    List<AppUser> reviewers,
  ) async {
    String? selected = paper.assignedReviewerId;
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Assign reviewer for "${paper.title}"'),
          content: DropdownButton<String>(
            value: selected,
            isExpanded: true,
            items: reviewers
                .map(
                  (reviewer) => DropdownMenuItem(
                    value: reviewer.uid,
                    child: Text(reviewer.fullName),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => selected = value),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                if (selected == null) return;
                final navigator = Navigator.of(context);
                await ref.read(researchPaperRepositoryProvider).assignReviewer(
                      paperId: paper.id,
                      reviewerId: selected!,
                    );
                navigator.pop();
              },
              child: const Text('Assign'),
            ),
          ],
        ),
      ),
    );
  }
}
