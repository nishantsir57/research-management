import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/models/app_user.dart';
import '../../../../core/models/research_paper.dart';
import '../../../../core/models/user_connection.dart';
import '../../../shared/domain/department_providers.dart';
import '../../../shared/domain/user_providers.dart';
import '../../../social/domain/connection_providers.dart';
import '../../domain/paper_providers.dart';
import '../widgets/animated_filter_bar.dart';
import '../widgets/paper_card.dart';

class PaperListPage extends ConsumerStatefulWidget {
  const PaperListPage({super.key, this.currentUser, this.header, this.showFilters = true});

  final AppUser? currentUser;
  final Widget? header;
  final bool showFilters;

  @override
  ConsumerState<PaperListPage> createState() => _PaperListPageState();
}

class _PaperListPageState extends ConsumerState<PaperListPage> {
  String? _departmentFilter;
  String? _subjectFilter;
  bool _onlyConnections = false;
  DateTimeRange? _dateRange;
  String? _visibilityFilter;
  String _sortOption = 'recent';

  @override
  void didUpdateWidget(covariant PaperListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentUser?.uid != oldWidget.currentUser?.uid) {
      _onlyConnections = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final papersAsync = ref.watch(allPapersProvider);
    final departmentsAsync = ref.watch(departmentsStreamProvider);
    final connectionsAsync = widget.currentUser == null
        ? const AsyncLoading<List<UserConnection>>()
        : ref.watch(userConnectionsProvider(widget.currentUser!.uid));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: papersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Unable to load papers: $error')),
        data: (papers) {
          final departments = departmentsAsync.value ?? [];
          final connectedIds = _connectedUserIds(connectionsAsync.value ?? [], widget.currentUser);
          final filtered = _applyFilters(papers, connectedIds);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.header != null) widget.header!,
              if (widget.showFilters)
                AnimatedFilterBar(
                  departments: departments,
                  departmentFilter: _departmentFilter,
                  subjectFilter: _subjectFilter,
                  visibilityFilter: _visibilityFilter,
                  sortOption: _sortOption,
                  onlyConnections: _onlyConnections,
                  dateRange: _dateRange,
                  onDepartmentChanged: (value) => setState(() {
                    _departmentFilter = value;
                    _subjectFilter = null;
                  }),
                  onSubjectChanged: (value) => setState(() => _subjectFilter = value),
                  onVisibilityChanged: (value) => setState(() => _visibilityFilter = value),
                  onSortChanged: (value) => setState(() => _sortOption = value),
                  onToggleConnections: (value) => setState(() => _onlyConnections = value),
                  onDateRangeSelected: (range) => setState(() => _dateRange = range),
                  onClearFilters: () => setState(() {
                    _departmentFilter = null;
                    _subjectFilter = null;
                    _onlyConnections = false;
                    _dateRange = null;
                    _visibilityFilter = null;
                    _sortOption = 'recent';
                  }),
                ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: filtered.isEmpty
                      ? _EmptyState(onReset: () => setState(() {
                            _departmentFilter = null;
                            _subjectFilter = null;
                            _onlyConnections = false;
                            _dateRange = null;
                          }))
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final crossAxisCount = _responsiveColumnCount(constraints.maxWidth);
                            return MasonryGridView.count(
                              key: ValueKey(filtered.length),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: 24,
                              crossAxisSpacing: 24,
                              itemBuilder: (context, index) {
                                final paper = filtered[index];
                                final authorAsync = ref.watch(userDetailsProvider(paper.authorId));
                                final author = authorAsync.value;
                                return PaperCard(
                                  paper: paper,
                                  heroTag: 'paper-card-${paper.id}',
                                  author: author,
                                  onTap: () => _openPaper(context, paper.id),
                                  onShare: () => _sharePaper(context, paper),
                                );
                              },
                              itemCount: filtered.length,
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Set<String> _connectedUserIds(List<UserConnection> connections, AppUser? user) {
    if (user == null) return const {};
    return connections
        .where((connection) => connection.status == ConnectionStatus.connected)
        .map((connection) => connection.userA == user.uid ? connection.userB : connection.userA)
        .toSet();
  }

  List<ResearchPaper> _applyFilters(List<ResearchPaper> papers, Set<String> connectedUserIds) {
    final filtered = papers.where((paper) {
      if (widget.currentUser != null && paper.authorId == widget.currentUser!.uid) return false;
      if (paper.visibility == PaperVisibility.private) return false;
      if (paper.visibility == PaperVisibility.connections && !connectedUserIds.contains(paper.authorId)) {
        return false;
      }
      if (_onlyConnections && !connectedUserIds.contains(paper.authorId)) {
        return false;
      }
      if (_departmentFilter != null && paper.department != _departmentFilter) return false;
      if (_subjectFilter != null && paper.subject != _subjectFilter) return false;
      if (_visibilityFilter != null && _visibilityFilter != 'all') {
        if (_visibilityFilter == 'public' && paper.visibility != PaperVisibility.public) return false;
        if (_visibilityFilter == 'connections' && paper.visibility != PaperVisibility.connections) {
          return false;
        }
      }
      if (_dateRange != null) {
        if (paper.createdAt.isBefore(_dateRange!.start) || paper.createdAt.isAfter(_dateRange!.end)) {
          return false;
        }
      }
      return true;
    }).toList();

    return _sortPapers(filtered);
  }

  int _responsiveColumnCount(double maxWidth) {
    if (maxWidth >= 1400) return 5;
    if (maxWidth >= 1200) return 4;
    if (maxWidth >= 900) return 3;
    if (maxWidth >= 600) return 2;
    return 1;
  }

  void _openPaper(BuildContext context, String paperId) {
    if (!mounted) return;
    context.go('/paper/$paperId');
  }

  Future<void> _sharePaper(BuildContext context, ResearchPaper paper) async {
    final url = Uri.parse('https://researchhub.app/paper/${paper.id}');
    final shareText = url.toString();

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.ios_share_rounded),
                title: const Text('Share via apps'),
                onTap: () {
                  Navigator.of(context).pop();
                  Share.shareUri(url);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy_rounded),
                title: const Text('Copy link'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: shareText));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Shareable link copied to clipboard.')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<ResearchPaper> _sortPapers(List<ResearchPaper> papers) {
    switch (_sortOption) {
      case 'popular':
        final sorted = [...papers];
        sorted.sort((a, b) => _popularityScore(b).compareTo(_popularityScore(a)));
        return sorted;
      case 'trending':
        final sorted = [...papers];
        sorted.sort((a, b) => _trendingScore(b).compareTo(_trendingScore(a)));
        return sorted;
      case 'oldest':
        final sorted = [...papers];
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        return sorted;
      case 'recent':
      default:
        final sorted = [...papers];
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return sorted;
    }
  }

  double _popularityScore(ResearchPaper paper) {
    final base = paper.reviewerHighlights.length * 10 + paper.studentResubmissions.length * 6;
    return base + paper.updatedAt.difference(paper.createdAt).inHours * 0.4;
  }

  double _trendingScore(ResearchPaper paper) {
    final recency = DateTime.now().difference(paper.createdAt).inHours + 1;
    final popularity = _popularityScore(paper) + paper.updatedAt.millisecondsSinceEpoch % 50;
    return popularity / recency;
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 28, offset: const Offset(0, 18)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF4338CA), Color(0xFF2563EB), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.library_books_outlined, color: Colors.white, size: 42),
            ),
            const SizedBox(height: 20),
            Text(
              'No papers match your filters',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting the filters or reset them to explore more research.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reset filters'),
            ),
          ],
        ),
      ),
    );
  }
}
