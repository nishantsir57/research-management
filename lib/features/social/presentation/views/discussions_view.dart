import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/app_user.dart';
import '../../domain/discussion_providers.dart';

class DiscussionsView extends ConsumerStatefulWidget {
  const DiscussionsView({super.key, required this.user});

  final AppUser user;

  @override
  ConsumerState<DiscussionsView> createState() => _DiscussionsViewState();
}

class _DiscussionsViewState extends ConsumerState<DiscussionsView> {
  String? _selectedDiscussionId;
  String? _selectedDiscussionTitle;

  @override
  Widget build(BuildContext context) {
    final discussionsAsync = ref.watch(discussionsStreamProvider);

    return Row(
      children: [
        SizedBox(
          width: 320,
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Community Discussions'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_comment_outlined),
                    onPressed: () => _showCreateDiscussionDialog(context),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: discussionsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text('Error: $error')),
                    data: (discussions) {
                      if (discussions.isEmpty) {
                        return const Center(child: Text('No discussions yet. Create the first one!'));
                      }
                      return ListView.separated(
                        itemCount: discussions.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final discussion = discussions[index];
                          final selected = discussion.id == _selectedDiscussionId;
                          return ListTile(
                            title: Text(discussion.title),
                            selected: selected,
                            onTap: () => setState(() {
                              _selectedDiscussionId = discussion.id;
                              _selectedDiscussionTitle = discussion.title;
                            }),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: _selectedDiscussionId == null
                ? const Center(child: Text('Select a discussion to view messages.'))
                : _DiscussionThread(
                    user: widget.user,
                    discussionId: _selectedDiscussionId!,
                    title: _selectedDiscussionTitle ?? 'Discussion',
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateDiscussionDialog(BuildContext context) async {
    final controller = TextEditingController();
    final repo = ref.read(discussionRepositoryProvider);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Discussion'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Topic title'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (controller.text.trim().isEmpty) return;
              final navigator = Navigator.of(context);
              await repo.createDiscussion(title: controller.text.trim(), createdBy: widget.user.uid);
              if (mounted) {
                navigator.pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _DiscussionThread extends ConsumerStatefulWidget {
  const _DiscussionThread({required this.user, required this.discussionId, required this.title});

  final AppUser user;
  final String discussionId;
  final String title;

  @override
  ConsumerState<_DiscussionThread> createState() => _DiscussionThreadState();
}

class _DiscussionThreadState extends ConsumerState<_DiscussionThread> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(discussionMessagesProvider(widget.discussionId));

    return Column(
      children: [
        ListTile(title: Text(widget.title)),
        const Divider(height: 1),
        Expanded(
          child: messagesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
            data: (messages) => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMine = message.createdBy == widget.user.uid;
                return Align(
                  alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMine
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha((0.15 * 255).round())
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(message.text),
                  ),
                );
              },
            ),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Share your thoughts...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                label: const Text('Send'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final repo = ref.read(discussionRepositoryProvider);
    await repo.postMessage(
      discussionId: widget.discussionId,
      text: text,
      createdBy: widget.user.uid,
    );
    _messageController.clear();
  }
}
