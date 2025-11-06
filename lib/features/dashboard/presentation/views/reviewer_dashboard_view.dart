import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/models/app_user.dart';
import '../../../../core/models/research_paper.dart';
import '../../../../core/models/reviewer_highlight.dart';
import '../../../auth/domain/auth_providers.dart';
import '../../../papers/domain/paper_providers.dart';
import '../../../reviewer/domain/reviewer_review_controller.dart';
import '../../../shared/widgets/gradient_app_bar.dart';

class ReviewerDashboardView extends ConsumerStatefulWidget {
  const ReviewerDashboardView({super.key});

  @override
  ConsumerState<ReviewerDashboardView> createState() => _ReviewerDashboardViewState();
}

class _ReviewerDashboardViewState extends ConsumerState<ReviewerDashboardView> {
  int _index = 0;
  ResearchPaper? _selectedPaper;

  @override
  Widget build(BuildContext context) {
    final reviewerAsync = ref.watch(authUserChangesProvider);

    return reviewerAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text('Error: $error'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text('Reviewer account missing.')));
        }
        return _buildDashboard(context, user);
      },
    );
  }

  Widget _buildDashboard(BuildContext context, AppUser reviewer) {
    final assignedAsync = ref.watch(reviewerAssignedPapersProvider(reviewer.uid));

    final navItems = _navItems();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: GradientAppBar(
        userName: reviewer.fullName,
        onLogout: () => ref.read(authRepositoryProvider).signOut(),
        onNotifications: () {},
      ),
      body: assignedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load papers: $error')),
        data: (assigned) {
          final reviewed = assigned.where((paper) => paper.status != PaperStatus.submitted && paper.status != PaperStatus.underReview).toList();
          final inReview = assigned.where((paper) => paper.status == PaperStatus.underReview || paper.status == PaperStatus.submitted).toList();
          _selectedPaper ??= inReview.isNotEmpty ? inReview.first : (assigned.isNotEmpty ? assigned.first : null);

          Widget buildContent() {
            switch (_index) {
              case 0:
                return _ReviewerWorkspace(
                  papers: inReview,
                  selected: _selectedPaper,
                  onSelected: (paper) => setState(() => _selectedPaper = paper),
                );
              case 1:
                return _ReviewedPapersList(papers: reviewed);
              case 2:
                return const _ReviewerCommunityPlaceholder();
              default:
                return const SizedBox.shrink();
            }
          }

          final isWide = MediaQuery.of(context).size.width >= 1024;
          final content = Padding(
            padding: EdgeInsets.only(right: isWide ? 16 : 0, bottom: 24, left: isWide ? 0 : 8, top: 16),
            child: buildContent(),
          );

          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isWide)
                _ReviewerNavRail(
                  items: navItems,
                  selectedIndex: _index,
                  onChanged: (value) => setState(() => _index = value),
                ),
              Expanded(child: content),
            ],
          );
        },
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width >= 1024
          ? null
          : NavigationBar(
              selectedIndex: _index,
              destinations: navItems.map((item) => NavigationDestination(icon: Icon(item.icon), label: item.label)).toList(),
              onDestinationSelected: (value) => setState(() => _index = value),
            ),
    );
  }

  List<_ReviewerNavItem> _navItems() {
    return const [
      _ReviewerNavItem(label: 'Workspace', icon: Icons.fact_check_outlined),
      _ReviewerNavItem(label: 'Reviewed', icon: Icons.history_edu_outlined),
      _ReviewerNavItem(label: 'Community', icon: Icons.forum_outlined),
    ];
  }
}

class _ReviewerNavItem {
  const _ReviewerNavItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class _ReviewerNavRail extends StatelessWidget {
  const _ReviewerNavRail({required this.items, required this.selectedIndex, required this.onChanged});

  final List<_ReviewerNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 20, 24),
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 18)),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            for (var i = 0; i < items.length; i++)
              _ReviewerNavButton(
                item: items[i],
                isSelected: selectedIndex == i,
                onTap: () => onChanged(i),
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _ReviewerNavButton extends StatelessWidget {
  const _ReviewerNavButton({required this.item, required this.isSelected, required this.onTap});

  final _ReviewerNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: decoration,
          child: Row(
            children: [
              Icon(item.icon, color: foreground),
              const SizedBox(width: 12),
              Text(item.label, style: theme.textTheme.labelLarge?.copyWith(color: foreground, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewerWorkspace extends StatefulWidget {
  const _ReviewerWorkspace({required this.papers, required this.selected, required this.onSelected});

  final List<ResearchPaper> papers;
  final ResearchPaper? selected;
  final ValueChanged<ResearchPaper> onSelected;

  @override
  State<_ReviewerWorkspace> createState() => _ReviewerWorkspaceState();
}

class _ReviewerWorkspaceState extends State<_ReviewerWorkspace> {
  @override
  Widget build(BuildContext context) {
    if (widget.papers.isEmpty) {
      return const Center(child: Text('No papers awaiting review right now.'));
    }

    final selected = widget.selected ?? widget.papers.first;

    return Row(
      children: [
        SizedBox(
          width: 320,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: widget.papers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final paper = widget.papers[index];
              final isSelected = selected.id == paper.id;
              return ListTile(
                selected: isSelected,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                tileColor: isSelected ? const Color(0xFFEFF2FF) : Colors.white,
                title: Text(paper.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text('Status: ${paper.status.name}'),
                onTap: () => widget.onSelected(paper),
              );
            },
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(child: _ReviewerPaperDetail(paper: selected)),
      ],
    );
  }
}

class _ReviewedPapersList extends StatelessWidget {
  const _ReviewedPapersList({required this.papers});

  final List<ResearchPaper> papers;

  @override
  Widget build(BuildContext context) {
    if (papers.isEmpty) {
      return const Center(child: Text('No completed reviews yet.')); 
    }
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: papers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final paper = papers[index];
        return ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          title: Text(paper.title),
          subtitle: Text('Final status: ${paper.status.name}'),
        );
      },
    );
  }
}

class _ReviewerCommunityPlaceholder extends StatelessWidget {
  const _ReviewerCommunityPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 26, offset: const Offset(0, 18)),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.forum_outlined, size: 42, color: Color(0xFF4338CA)),
            SizedBox(height: 12),
            Text('Community discussions coming soon', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Text('Public reviewer discussions will appear here once configured.'),
          ],
        ),
      ),
    );
  }
}

class _ReviewerPaperDetail extends ConsumerStatefulWidget {
  const _ReviewerPaperDetail({required this.paper});

  final ResearchPaper paper;

  @override
  ConsumerState<_ReviewerPaperDetail> createState() => _ReviewerPaperDetailState();
}

class _ReviewerPaperDetailState extends ConsumerState<_ReviewerPaperDetail> {
  final _commentsController = TextEditingController();
  final List<ReviewerHighlight> _highlights = [];

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewerReviewControllerProvider);
    final formatter = DateFormat('MMM d, y h:mm a');

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.paper.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('Assigned ${formatter.format(widget.paper.createdAt)}'),
          const SizedBox(height: 12),
          if (widget.paper.contentText != null && widget.paper.contentText!.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Text(widget.paper.contentText!),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  widget.paper.fileUrl == null
                      ? 'No content provided.'
                      : 'This submission is a file upload. Download to review the content.',
                ),
              ),
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: _addHighlight,
                icon: const Icon(Icons.highlight_alt_outlined),
                label: const Text('Add Highlight'),
              ),
              FilledButton.icon(
                onPressed: reviewState.isLoading ? null : () => _approve(),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Approve'),
              ),
              FilledButton.tonalIcon(
                onPressed: reviewState.isLoading ? null : () => _revert(),
                icon: const Icon(Icons.undo),
                label: const Text('Request Changes'),
              ),
              if (reviewState.isLoading)
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentsController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Reviewer comments (required for revert)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          if (_highlights.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Highlights to share with the student'),
                const SizedBox(height: 8),
                ..._highlights.map((highlight) => ListTile(
                      title: Text(highlight.text ?? 'Highlight ${highlight.id}'),
                      subtitle: Text(highlight.comment),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => setState(() => _highlights.remove(highlight)),
                      ),
                    )),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _addHighlight() async {
    final textController = TextEditingController();
    final noteController = TextEditingController();
    final result = await showDialog<ReviewerHighlight>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Highlight'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Excerpt / Section',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Comment'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (noteController.text.trim().isEmpty) {
                return;
              }
              Navigator.of(context).pop(
                ReviewerHighlight(
                  id: const Uuid().v4(),
                  startIndex: 0,
                  endIndex: 0,
                  comment: noteController.text.trim(),
                  text: textController.text.trim().isEmpty ? null : textController.text.trim(),
                ),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      setState(() => _highlights.add(result));
    }
  }

  Future<void> _approve() async {
    await ref.read(reviewerReviewControllerProvider.notifier).approvePaper(
          paper: widget.paper,
          comments: _commentsController.text.trim().isEmpty ? null : _commentsController.text.trim(),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paper approved.')),
      );
    }
  }

  Future<void> _revert() async {
    final comments = _commentsController.text.trim();
    if (comments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comments required to request changes.')),
      );
      return;
    }

    await ref.read(reviewerReviewControllerProvider.notifier).revertPaper(
          paper: widget.paper,
          comments: comments,
          highlights: _highlights,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revert request sent to student.')),
      );
    }
  }
}
