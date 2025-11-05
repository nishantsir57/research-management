import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/app_user.dart';
import '../../../../../core/models/department.dart';
import '../../../../../core/models/paper_comment.dart';
import '../../../../../core/models/research_paper.dart';
import '../../../../../core/models/user_connection.dart';
import '../../../../shared/domain/department_providers.dart';
import '../../../domain/comment_providers.dart';
import '../../../domain/paper_providers.dart';
import '../../../../social/domain/connection_providers.dart';

class StudentDiscoverView extends ConsumerStatefulWidget {
  const StudentDiscoverView({super.key, required this.user});

  final AppUser user;

  @override
  ConsumerState<StudentDiscoverView> createState() => _StudentDiscoverViewState();
}

class _StudentDiscoverViewState extends ConsumerState<StudentDiscoverView> {
  String? _departmentFilter;
  String? _subjectFilter;
  bool _onlyConnections = false;
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    final papersAsync = ref.watch(allPapersProvider);
    final connectionsAsync = ref.watch(userConnectionsProvider(widget.user.uid));
    final departmentsAsync = ref.watch(departmentsStreamProvider);

    if (papersAsync.isLoading || connectionsAsync.isLoading || departmentsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final papers = papersAsync.value ?? [];
    final connections = connectionsAsync.value ?? [];
    final departments = departmentsAsync.value ?? [];

    final connectedUserIds = connections
        .where((connection) => connection.status == ConnectionStatus.connected)
        .map((connection) => connection.userA == widget.user.uid ? connection.userB : connection.userA)
        .toSet();

    final filtered = papers.where((paper) {
      if (paper.authorId == widget.user.uid) return false;
      if (paper.visibility == PaperVisibility.private) return false;
      if (paper.visibility == PaperVisibility.connections &&
          !connectedUserIds.contains(paper.authorId)) {
        return false;
      }
      if (_onlyConnections && !connectedUserIds.contains(paper.authorId)) {
        return false;
      }
      if (_departmentFilter != null && paper.department != _departmentFilter) {
        return false;
      }
      if (_subjectFilter != null && paper.subject != _subjectFilter) {
        return false;
      }
      if (_dateRange != null) {
        if (paper.createdAt.isBefore(_dateRange!.start) || paper.createdAt.isAfter(_dateRange!.end)) {
          return false;
        }
      }
      return true;
    }).toList();

    return Column(
      children: [
        _FiltersBar(
          departments: departments,
          departmentFilter: _departmentFilter,
          subjectFilter: _subjectFilter,
          onlyConnections: _onlyConnections,
          dateRange: _dateRange,
          onDepartmentChanged: (value) => setState(() {
            _departmentFilter = value;
            _subjectFilter = null;
          }),
          onSubjectChanged: (value) => setState(() => _subjectFilter = value),
          onToggleConnections: (value) => setState(() => _onlyConnections = value),
          onDateRangeSelected: (range) => setState(() => _dateRange = range),
          onClearFilters: () => setState(() {
            _departmentFilter = null;
            _subjectFilter = null;
            _onlyConnections = false;
            _dateRange = null;
          }),
        ),
        const Divider(height: 1),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('No papers match your filters yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemBuilder: (context, index) {
                    final paper = filtered[index];
                    return _DiscoverCard(paper: paper, currentUser: widget.user);
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemCount: filtered.length,
                ),
        ),
      ],
    );
  }
}

class _FiltersBar extends StatelessWidget {
  const _FiltersBar({
    required this.departments,
    required this.departmentFilter,
    required this.subjectFilter,
    required this.onlyConnections,
    required this.dateRange,
    required this.onDepartmentChanged,
    required this.onSubjectChanged,
    required this.onToggleConnections,
    required this.onDateRangeSelected,
    required this.onClearFilters,
  });

  final List<Department> departments;
  final String? departmentFilter;
  final String? subjectFilter;
  final bool onlyConnections;
  final DateTimeRange? dateRange;
  final ValueChanged<String?> onDepartmentChanged;
  final ValueChanged<String?> onSubjectChanged;
  final ValueChanged<bool> onToggleConnections;
  final ValueChanged<DateTimeRange?> onDateRangeSelected;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          DropdownButton<String?>(
            value: departmentFilter,
            hint: const Text('Department'),
            items: <DropdownMenuItem<String?>>[
              const DropdownMenuItem(value: null, child: Text('All Departments')),
              ...departments.map((dept) => DropdownMenuItem(value: dept.name, child: Text(dept.name))),
            ],
            onChanged: onDepartmentChanged,
          ),
          DropdownButton<String?>(
            value: subjectFilter,
            hint: const Text('Subject'),
            items: <DropdownMenuItem<String?>>[
              const DropdownMenuItem(value: null, child: Text('All Subjects')),
              ..._subjectOptions().map((subject) => DropdownMenuItem(value: subject, child: Text(subject))),
            ],
            onChanged: onSubjectChanged,
          ),
          FilterChip(
            label: const Text('Connections Only'),
            selected: onlyConnections,
            onSelected: onToggleConnections,
          ),
          OutlinedButton.icon(
            onPressed: () async {
              final now = DateTime.now();
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(now.year - 5),
                lastDate: now,
              );
              onDateRangeSelected(picked);
            },
            icon: const Icon(Icons.filter_alt_outlined),
            label: Text(
              dateRange == null
                  ? 'Published Date'
                  : '${DateFormat('MMM d, y').format(dateRange!.start)} - ${DateFormat('MMM d, y').format(dateRange!.end)}',
            ),
          ),
          TextButton(onPressed: onClearFilters, child: const Text('Reset')),
        ],
      ),
    );
  }
}

extension on _FiltersBar {
  List<String> _subjectOptions() {
    if (departmentFilter == null) {
      return departments.expand((dept) => dept.subjects).toSet().toList()..sort();
    }
    final department = departments.firstWhere(
      (dept) => dept.name == departmentFilter,
      orElse: () => Department(id: '', name: '', subjects: const []),
    );
    return department.subjects;
  }
}

class _DiscoverCard extends StatelessWidget {
  const _DiscoverCard({required this.paper, required this.currentUser});

  final ResearchPaper paper;
  final AppUser currentUser;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM d, y');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              paper.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Department: ${paper.department} • Subject: ${paper.subject}'),
            const SizedBox(height: 4),
            Text('Visibility: ${paper.visibility.name} • Published ${formatter.format(paper.createdAt)}'),
            const SizedBox(height: 12),
            if (paper.contentText != null && paper.contentText!.isNotEmpty)
              Text(
                paper.contentText!.length > 240
                    ? '${paper.contentText!.substring(0, 240)}...'
                    : paper.contentText!,
              ),
            if (paper.contentText == null || paper.contentText!.isEmpty)
              const Text('File submission. Download to read.'),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _showDetails(context),
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDetails(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => _PaperDetailsView(user: currentUser, paper: paper),
    );
  }
}

class _PaperDetailsView extends ConsumerStatefulWidget {
  const _PaperDetailsView({required this.user, required this.paper});

  final AppUser user;
  final ResearchPaper paper;

  @override
  ConsumerState<_PaperDetailsView> createState() => _PaperDetailsViewState();
}

class _PaperDetailsViewState extends ConsumerState<_PaperDetailsView> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(paperCommentsProvider(widget.paper.id));

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.paper.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text('Department: ${widget.paper.department} • Subject: ${widget.paper.subject}'),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.paper.contentText != null && widget.paper.contentText!.isNotEmpty)
                    Text(widget.paper.contentText!)
                  else
                    const Text('This paper was submitted as a file. Download to read the full content.'),
                  const SizedBox(height: 24),
                  Text('Comments', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  commentsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Text('Unable to load comments: $error'),
                    data: (comments) => Column(
                      children: comments
                          .map(
                            (comment) => ListTile(
                              leading: const Icon(Icons.person_outline),
                              title: Text(comment.commentText),
                              subtitle: Text(comment.createdAt.toString()),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Leave a comment…',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _postComment,
                child: const Text('Post'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _postComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    await ref.read(paperCommentRepositoryProvider).addComment(
          PaperComment(
            id: '',
            paperId: widget.paper.id,
            authorId: widget.user.uid,
            commentText: text,
            createdAt: DateTime.now(),
          ),
        );
    _commentController.clear();
  }
}
