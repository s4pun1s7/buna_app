import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/festival_data_provider.dart';
import '../../services/analytics_service.dart';
import '../../utils/debouncer.dart';

class SearchWidget extends ConsumerStatefulWidget {
  final String? initialQuery;
  final Function(String)? onSearch;
  final String hintText;

  const SearchWidget({
    super.key,
    this.initialQuery,
    this.onSearch,
    this.hintText = 'Search...',
  });

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  late TextEditingController _controller;
  final SearchDebouncer _searchDebouncer = SearchDebouncer();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _performSearch(widget.initialQuery!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      ref.read(searchStateProvider.notifier).clearSearch();
      return;
    }
    try {
      // Track search analytics
      AnalyticsService.logSearch(query: query);
      // Perform search
      ref.read(searchStateProvider.notifier).search(query);
      // Call callback if provided
      widget.onSearch?.call(query);
    } catch (e, stack) {
      debugPrint('[SearchWidget] Error during search: \\${e.toString()}');
      debugPrint('[SearchWidget] Stack: \\${stack.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error performing search: \\${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onSearchChanged(String query) {
    // Use the debouncer for search
    _searchDebouncer.call(() => _performSearch(query));
  }

  void _clearSearch() {
    _controller.clear();
    _searchDebouncer.cancel(); // Cancel any pending search
    ref.read(searchStateProvider.notifier).clearSearch();
    widget.onSearch?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
