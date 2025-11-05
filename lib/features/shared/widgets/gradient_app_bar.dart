import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GradientAppBar({
    super.key,
    required this.userName,
    required this.onLogout,
    this.onNotifications,
    this.onProfile,
  });

  final String userName;
  final VoidCallback onLogout;
  final VoidCallback? onNotifications;
  final VoidCallback? onProfile;

  @override
  Size get preferredSize => const Size.fromHeight(92);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Color(0xFF1E1B4B), blurRadius: 24, offset: Offset(0, 10)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 720;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF67E8F9), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 14, offset: Offset(0, 8)),
                          ],
                        ),
                        child: const Center(
                          child: Text('R', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ResearchHub', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                          Text(
                            'Academic Research Platform',
                            style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withOpacity(0.72)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 18),
                  if (!isCompact)
                    Expanded(
                      child: _SearchField(),
                    )
                  else
                    const Spacer(),
                  Row(
                    children: [
                      if (isCompact)
                        IconButton(
                          onPressed: () {},
                          color: Colors.white,
                          icon: const Icon(Icons.search_rounded),
                          tooltip: 'Search',
                        ),
                      IconButton(
                        onPressed: onNotifications,
                        color: Colors.white,
                        icon: const Icon(Icons.notifications_none_rounded),
                        tooltip: 'Notifications',
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: onProfile,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: const Color(0xFF6366F1),
                                child: Text(
                                  userName.isEmpty ? 'U' : userName.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (!isCompact)
                                Text(
                                  userName,
                                  style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: onLogout,
                        color: Colors.white,
                        tooltip: 'Sign out',
                        icon: const Icon(Icons.logout_rounded),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.95),
        prefixIcon: const Icon(Icons.search_rounded),
        hintText: 'Search papers, authors, topics…',
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
      ),
    );
  }
}
