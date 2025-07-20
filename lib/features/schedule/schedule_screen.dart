import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/festival_data.dart';
import '../../services/api_service.dart';
import '../../widgets/common/index.dart';
import '../../widgets/venue_event/index.dart';
import '../../widgets/navigation/buna_app_bar.dart';
import 'package:go_router/go_router.dart';
import '../../navigation/route_constants.dart';

/// Schedule screen showing all festival events in a timeline
class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDate = '';
  List<FestivalEvent> _allEvents = [];
  List<FestivalEvent> _filteredEvents = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final events = await ApiService.fetchEvents();

      setState(() {
        _allEvents = events;
        _filteredEvents = events;
        _isLoading = false;
      });

      // Set initial selected date to today or first event date
      if (events.isNotEmpty) {
        final today = DateTime.now();
        final todayEvents = events
            .where(
              (event) =>
                  event.startDate != null &&
                  event.startDate!.year == today.year &&
                  event.startDate!.month == today.month &&
                  event.startDate!.day == today.day,
            )
            .toList();

        if (todayEvents.isNotEmpty) {
          _selectedDate = _formatDate(today);
        } else {
          _selectedDate = _formatDate(events.first.startDate!);
        }
        _filterEventsByDate(_selectedDate);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterEventsByDate(String date) {
    setState(() {
      _selectedDate = date;
      _filteredEvents = _allEvents.where((event) {
        if (event.startDate == null) return false;
        return _formatDate(event.startDate!) == date;
      }).toList();

      // Sort by start time
      _filteredEvents.sort((a, b) {
        if (a.startTime == null || b.startTime == null) return 0;
        return a.startTime!.compareTo(b.startTime!);
      });
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDisplayDate(String date) {
    final dateTime = DateTime.parse(date);
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    if (dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day) {
      return 'Today';
    } else if (dateTime.year == tomorrow.year &&
        dateTime.month == tomorrow.month &&
        dateTime.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  List<String> _getUniqueDates() {
    final dates = _allEvents
        .where((event) => event.startDate != null)
        .map((event) => _formatDate(event.startDate!))
        .toSet()
        .toList();
    dates.sort();
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BunaAppBar(
        title: 'Festival Schedule',
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'About Schedule',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator();
    }

    if (_error != null) {
      return AppErrorWidget(message: _error, onRetry: _loadEvents);
    }

    if (_allEvents.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildDateSelector(),
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTimelineView(),
              _buildListView(),
              _buildCalendarView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    final dates = _getUniqueDates();

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date == _selectedDate;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(_formatDisplayDate(date)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _filterEventsByDate(date);
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(icon: Icon(Icons.timeline), text: 'Timeline'),
        Tab(icon: Icon(Icons.list), text: 'List'),
        Tab(icon: Icon(Icons.calendar_today), text: 'Calendar'),
      ],
    );
  }

  Widget _buildTimelineView() {
    if (_filteredEvents.isEmpty) {
      return _buildNoEventsForDate();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredEvents.length,
      itemBuilder: (context, index) {
        final event = _filteredEvents[index];
        final isLast = index == _filteredEvents.length - 1;

        return Row(
          children: [
            // Timeline line
            Column(
              children: [
                Container(
                  width: 2,
                  height: 20,
                  color: Theme.of(context).primaryColor,
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 80,
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.3),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Event card
            Expanded(
              child: ScheduleCard(
                event: event,
                onTap: () => _showEventDetails(event),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListView() {
    if (_filteredEvents.isEmpty) {
      return _buildNoEventsForDate();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredEvents.length,
      itemBuilder: (context, index) {
        final event = _filteredEvents[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(_getEventIcon(event.category), color: Colors.white),
            ),
            title: Text(
              event.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.startTime != null) Text('Time: ${event.startTime}'),
                if (event.venue != null) Text('Venue: ${event.venue}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showEventDetails(event),
          ),
        );
      },
    );
  }

  Widget _buildCalendarView() {
    // Simple calendar view - could be enhanced with a proper calendar widget
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Calendar View',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Calendar view coming soon...'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
            semanticLabel: 'No events',
          ),
          const SizedBox(height: 16),
          Text(
            'No events scheduled',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for updates.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildNoEventsForDate() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Events for ${_formatDisplayDate(_selectedDate)}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('Select a different date to view events'),
        ],
      ),
    );
  }

  IconData _getEventIcon(String? category) {
    switch (category?.toLowerCase()) {
      case 'music':
        return Icons.music_note;
      case 'art':
      case 'exhibition':
        return Icons.palette;
      case 'performance':
        return Icons.theater_comedy;
      case 'workshop':
        return Icons.school;
      case 'ceremony':
        return Icons.celebration;
      case 'digital art':
        return Icons.computer;
      case 'environmental art':
        return Icons.eco;
      default:
        return Icons.event;
    }
  }

  void _showEventDetails(FestivalEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Venue: ${event.venue ?? 'Unknown'}'),
            Text('Time: ${event.startTime ?? 'Unknown'}'),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Description: ${event.description}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRoutes.eventDetailsPath(event.title));
            },
            child: const Text('Full Details'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About the Schedule'),
        content: const Text(
          'This is a simple schedule viewer. It shows events in a timeline, list, and calendar view. You can filter events by date and view details about each event. The data is fetched from an API and may not be accurate or complete.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
