import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/models/department.dart';

/// Animated filter toolbar for paper discovery with support for adaptive layouts.
class AnimatedFilterBar extends StatefulWidget {
  const AnimatedFilterBar({
    super.key,
    required this.departments,
    required this.departmentFilter,
    required this.subjectFilter,
    required this.visibilityFilter,
    required this.sortOption,
    required this.onlyConnections,
    required this.dateRange,
    required this.onDepartmentChanged,
    required this.onSubjectChanged,
    required this.onVisibilityChanged,
    required this.onSortChanged,
    required this.onToggleConnections,
    required this.onDateRangeSelected,
    required this.onClearFilters,
  });

  final List<Department> departments;
  final String? departmentFilter;
  final String? subjectFilter;
  final String? visibilityFilter;
  final String sortOption;
  final bool onlyConnections;
  final DateTimeRange? dateRange;
  final ValueChanged<String?> onDepartmentChanged;
  final ValueChanged<String?> onSubjectChanged;
  final ValueChanged<String?> onVisibilityChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<bool> onToggleConnections;
  final ValueChanged<DateTimeRange?> onDateRangeSelected;
  final VoidCallback onClearFilters;

  @override
  State<AnimatedFilterBar> createState() => _AnimatedFilterBarState();
}

class _AnimatedFilterBarState extends State<AnimatedFilterBar> {
  bool _showFilters = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: theme.colorScheme.surface.withOpacity(0.9),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.tune, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Discovery Filters',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                icon: AnimatedRotation(
                  turns: _showFilters ? 0.25 : 0,
                  duration: disableAnimations ? Duration.zero : const Duration(milliseconds: 200),
                  child: const Icon(Icons.chevron_right_rounded),
                ),
                onPressed: () => setState(() => _showFilters = !_showFilters),
                tooltip: 'Toggle filters',
              ),
            ],
          ),
          AnimatedCrossFade(
            crossFadeState: _showFilters ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: disableAnimations ? Duration.zero : const Duration(milliseconds: 250),
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 720;
                    final maxWidth = constraints.maxWidth;
                    final child = Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _DropdownFilter(
                          label: 'Department',
                          value: widget.departmentFilter ?? 'all',
                          maxWidth: maxWidth,
                          options: [
                            const (value: 'all', label: 'All Departments'),
                            ...widget.departments
                                .map((dept) => (value: dept.name, label: dept.name))
                                .toList(),
                          ],
                          onChanged: (value) => widget.onDepartmentChanged(value == 'all' ? null : value),
                        ),
                        _DropdownFilter(
                          label: 'Subject',
                          value: widget.subjectFilter ?? 'all',
                          maxWidth: maxWidth,
                          options: [
                            const (value: 'all', label: 'All Subjects'),
                            ..._subjects().map((subject) => (value: subject, label: subject)),
                          ],
                          onChanged: (value) => widget.onSubjectChanged(value == 'all' ? null : value),
                        ),
                        _DropdownFilter(
                          label: 'Visibility',
                          value: widget.visibilityFilter ?? 'all',
                          maxWidth: maxWidth,
                          options: const [
                            (value: 'all', label: 'Any Visibility'),
                            (value: 'public', label: 'Public'),
                            (value: 'connections', label: 'Connections Only'),
                          ],
                          onChanged: (value) => widget.onVisibilityChanged(value == 'all' ? null : value),
                        ),
                        _DropdownFilter(
                          label: 'Sort By',
                          value: widget.sortOption,
                          maxWidth: maxWidth,
                          options: const [
                            (value: 'recent', label: 'Most Recent'),
                            (value: 'popular', label: 'Most Popular'),
                            (value: 'trending', label: 'Trending'),
                            (value: 'oldest', label: 'Oldest First'),
                          ],
                          onChanged: (value) {
                            if (value != null) widget.onSortChanged(value);
                          },
                        ),
                        FilterChip(
                          label: Text(widget.onlyConnections ? 'Connections only' : 'All scholars'),
                          selected: widget.onlyConnections,
                          avatar: const Icon(Icons.people_alt_rounded, size: 18),
                          onSelected: widget.onToggleConnections,
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.calendar_month_rounded, size: 18),
                          label: Text(
                            widget.dateRange == null
                                ? 'Published anytime'
                                : '${DateFormat('MMM d').format(widget.dateRange!.start)} • ${DateFormat('MMM d').format(widget.dateRange!.end)}',
                          ),
                          onPressed: () async {
                            final now = DateTime.now();
                            final picked = await showDateRangePicker(
                              context: context,
                              initialDateRange: widget.dateRange,
                              firstDate: DateTime(now.year - 5),
                              lastDate: now,
                              saveText: 'Apply',
                            );
                            widget.onDateRangeSelected(picked);
                          },
                        ),
                      ],
                    );

                    if (isWide) return child;
                    return Align(alignment: Alignment.centerLeft, child: child);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _subjects() {
    if (widget.departmentFilter == null) {
      final allSubjects = widget.departments.expand((dept) => dept.subjects).toSet().toList();
      allSubjects.sort();
      return allSubjects;
    }
    final department = widget.departments.firstWhere(
      (dept) => dept.name == widget.departmentFilter,
      orElse: () => Department(id: '', name: '', subjects: const []),
    );
    return department.subjects;
  }
}

class _DropdownFilter extends StatelessWidget {
  const _DropdownFilter({
    required this.label,
    required this.value,
    required this.maxWidth,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final double maxWidth;
  final List<({String value, String label})> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double width;
    if (maxWidth >= 960) {
      width = 220;
    } else if (maxWidth >= 640) {
      width = maxWidth / 3 - 32;
    } else {
      width = maxWidth - 48;
    }
    if (width < 140) width = maxWidth - 32;
    if (width < 120) width = maxWidth * 0.9;
    if (width > 240) width = 240;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 6),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
              color: theme.colorScheme.surface,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  icon: const Icon(Icons.expand_more_rounded),
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(16),
                  onChanged: onChanged,
                  items: options
                      .map(
                        (option) => DropdownMenuItem<String>(
                          value: option.value,
                          child: Text(option.label),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
