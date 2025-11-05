import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/models/app_user.dart';
import '../../../../core/models/paper_comment.dart';
import '../../../../core/models/research_paper.dart';
import '../../../auth/domain/auth_providers.dart';
import '../../../shared/domain/user_providers.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../../social/presentation/widgets/animated_discussion_tile.dart';
import '../../domain/comment_providers.dart';
import '../../domain/paper_providers.dart';
import '../widgets/status_badge.dart';

class PaperViewPage extends ConsumerStatefulWidget {
  const PaperViewPage({super.key, required this.paperId});

  final String paperId;

  @override
  ConsumerState<PaperViewPage> createState() => _PaperViewPageState();
}

class _PaperViewPageState extends ConsumerState<PaperViewPage> {
  final _commentController = TextEditingController();
  late final ConfettiController _confettiController;
  PaperStatus? _lastStatus;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _commentController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paperAsync = ref.watch(paperDetailsProvider(widget.paperId));

    ref.listen(paperDetailsProvider(widget.paperId), (previous, next) {
      final previousStatus = previous?.valueOrNull?.status ?? _lastStatus;
      final status = next.valueOrNull?.status;
      final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      if (!disableAnimations && status == PaperStatus.published && status != previousStatus) {
        _confettiController.play();
      }
      _lastStatus = status;
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share paper',
            onPressed: paperAsync.hasValue && paperAsync.value != null
                ? () => _sharePaper(context, paperAsync.value!)
                : null,
          ),
        ],
      ),
      body: Stack(
        children: [
          paperAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Unable to load paper: $error')),
            data: (paper) {
              if (paper == null) {
                return const Center(child: Text('Paper not found or no longer available.'));
              }
              return _PaperDetailContent(
                paper: paper,
                commentController: _commentController,
                paperId: widget.paperId,
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 18,
              maxBlastForce: 40,
              minBlastForce: 10,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sharePaper(BuildContext context, ResearchPaper paper) async {
    final url = Uri.parse('https://researchhub.app/paper/${paper.id}');
    final shareText = url.toString();

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
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
                      const SnackBar(content: Text('Paper link copied. Share it anywhere!')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PaperDetailContent extends ConsumerWidget {
  const _PaperDetailContent({
    required this.paper,
    required this.commentController,
    required this.paperId,
  });

  final ResearchPaper paper;
  final TextEditingController commentController;
  final String paperId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradients = Theme.of(context).extension<AppGradients>();
    final authorAsync = ref.watch(userDetailsProvider(paper.authorId));
    final commentsAsync = ref.watch(paperCommentsProvider(paper.id));
    final userAsync = ref.watch(authUserChangesProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: gradients?.hero,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'paper-card-${paper.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: Colors.white.withOpacity(0.92),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 32,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StatusBadge(status: paper.status),
                              Chip(
                                avatar: const Icon(Icons.visibility_outlined, size: 18),
                                label: Text(paper.visibility.name.toUpperCase()),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            paper.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                _InfoPill(icon: Icons.school_outlined, label: paper.department),
                                _InfoPill(icon: Icons.category_outlined, label: paper.subject),
                                _InfoPill(icon: Icons.calendar_today_outlined, label: _dateString(paper.createdAt)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: authorAsync.when(
                              data: (author) => _AuthorBanner(paper: paper, author: author),
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (error, _) => Text('Unable to load author: $error'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.white.withOpacity(0.95),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Abstract',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          paper.contentText ??
                              'This paper includes a rich document. Open it on your preferred device to explore the findings.',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (paper.fileUrl != null) ...[
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: () => _openPaperFile(context, paper.fileUrl!),
                          icon: const Icon(Icons.picture_as_pdf_outlined),
                          label: const Text('Open attached document'),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _FeedbackSection(paper: paper),
                const SizedBox(height: 32),
                _CommentsSection(
                  commentsAsync: commentsAsync,
                  commentController: commentController,
                  currentUserAsync: userAsync,
                  paperId: paperId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _dateString(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Future<void> _openPaperFile(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Unable to open the paper file.')),
      );
    }
  }
}

class _AuthorBanner extends StatelessWidget {
  const _AuthorBanner({required this.paper, required this.author});

  final ResearchPaper paper;
  final AppUser? author;

  @override
  Widget build(BuildContext context) {
    final name = author?.fullName ?? 'Unknown Scholar';
    final reputation = (author?.subjects.length ?? 1) * 12;
    final connections = author?.subjects.length ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withOpacity(0.82),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(heroTag: 'paper-avatar-${paper.id}', initials: name, size: 56),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      paper.department,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _InfoPill(icon: Icons.stars_rounded, label: 'Reputation $reputation'),
              _InfoPill(icon: Icons.people_outline, label: 'Connections $connections'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeedbackSection extends StatelessWidget {
  const _FeedbackSection({required this.paper});

  final ResearchPaper paper;

  @override
  Widget build(BuildContext context) {
    final hasFeedback = paper.aiFeedback != null ||
        (paper.reviewerComments != null && paper.reviewerComments!.isNotEmpty);
    if (!hasFeedback) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withOpacity(0.88),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reviews & Highlights', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          if (paper.aiFeedback != null) ...[
            ExpansionTile(
              leading: const Icon(Icons.auto_awesome_outlined),
              title: const Text('AI Feedback Summary'),
              children: [
                ListTile(title: Text(paper.aiFeedback!.summary)),
                if (paper.aiFeedback!.suggestions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Suggestions'),
                        const SizedBox(height: 8),
                        ...paper.aiFeedback!.suggestions.map((suggestion) => Text('• $suggestion')),
                      ],
                    ),
                  ),
              ],
            ),
          ],
          if (paper.reviewerComments != null && paper.reviewerComments!.isNotEmpty)
            ExpansionTile(
              leading: const Icon(Icons.rate_review_outlined),
              title: const Text('Reviewer Feedback'),
              children: [
                ListTile(title: Text(paper.reviewerComments!)),
              ],
            ),
        ],
      ),
    );
  }
}

class _CommentsSection extends ConsumerWidget {
  const _CommentsSection({
    required this.commentsAsync,
    required this.commentController,
    required this.currentUserAsync,
    required this.paperId,
  });

  final AsyncValue<List<PaperComment>> commentsAsync;
  final TextEditingController commentController;
  final AsyncValue<AppUser?> currentUserAsync;
  final String paperId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withOpacity(0.96),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Discussion', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          commentsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Unable to load comments: $error'),
            data: (comments) {
              if (comments.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Be the first to share feedback on this paper.'),
                );
              }
              return Column(
                children: comments
                    .map(
                      (comment) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: _CommentTile(comment: comment),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          _CommentComposer(
            commentController: commentController,
            currentUserAsync: currentUserAsync,
            paperId: paperId,
          ),
        ],
      ),
    );
  }
}

class _CommentTile extends ConsumerWidget {
  const _CommentTile({required this.comment});

  final PaperComment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authorAsync = ref.watch(userDetailsProvider(comment.authorId));
    return authorAsync.when(
      data: (author) => AnimatedDiscussionTile(
        author: author,
        message: comment.commentText,
        publishedAt: comment.createdAt,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 18),
            onPressed: () => Clipboard.setData(ClipboardData(text: comment.commentText)),
          ),
        ],
      ),
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => Text('Error loading comment author: $error'),
    );
  }
}

class _CommentComposer extends ConsumerWidget {
  const _CommentComposer({
    required this.commentController,
    required this.currentUserAsync,
    required this.paperId,
  });

  final TextEditingController commentController;
  final AsyncValue<AppUser?> currentUserAsync;
  final String paperId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: commentController,
          decoration: InputDecoration(
            hintText: 'Share your thoughts…',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send_rounded),
              onPressed: () => _postComment(context, ref),
            ),
          ),
          minLines: 1,
          maxLines: 4,
        ),
        const SizedBox(height: 8),
        currentUserAsync.maybeWhen(
          data: (user) => user == null
              ? const Text('Sign in to join the discussion.', style: TextStyle(fontStyle: FontStyle.italic))
              : Text('Posting as ${user.fullName}', style: Theme.of(context).textTheme.bodySmall),
          orElse: () => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Future<void> _postComment(BuildContext context, WidgetRef ref) async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    final user = ref.read(authUserChangesProvider).valueOrNull;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to comment.')),
      );
      return;
    }

    await ref.read(paperCommentRepositoryProvider).addComment(
          PaperComment(
            id: '',
            paperId: paperId,
            authorId: user.uid,
            commentText: text,
            createdAt: DateTime.now(),
          ),
        );
    commentController.clear();
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
    );
  }
}
