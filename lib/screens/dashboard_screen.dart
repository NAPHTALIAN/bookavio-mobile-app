import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};
  City _selectedCity = City.schweinfurt;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadSampleEvents();
  }

  void _loadSampleEvents() {
    final now = DateTime.now();
    _events = {
      now: [
        Event(
          title: 'Pet Training Session',
          description: 'Basic obedience training',
          startTime: now,
          endTime: now.add(const Duration(hours: 1)),
          category: EventCategory.petTrainersAndSitters,
          city: _selectedCity,
        ),
        Event(
          title: 'Career Development Session',
          description: 'Career path planning and goal setting',
          startTime: now.add(const Duration(hours: 2)),
          endTime: now.add(const Duration(hours: 3)),
          category: EventCategory.coaches,
          coachSubCategory: CoachSubCategory.life,
          city: _selectedCity,
        ),
      ],
      now.add(const Duration(days: 1)): [
        Event(
          title: 'Math Tutoring',
          description: 'Algebra review session',
          startTime: now.add(const Duration(days: 1)),
          endTime: now.add(const Duration(days: 1, hours: 1)),
          category: EventCategory.tutors,
          city: _selectedCity,
        ),
        Event(
          title: 'Productivity Workshop',
          description: 'Time management and efficiency techniques',
          startTime: now.add(const Duration(days: 1, hours: 2)),
          endTime: now.add(const Duration(days: 1, hours: 3)),
          category: EventCategory.coaches,
          coachSubCategory: CoachSubCategory.wellness,
          city: _selectedCity,
        ),
      ],
    };
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  List<Event> _getRecentEvents() {
    final allEvents = _events.values.expand((events) => events).toList();
    allEvents.sort((a, b) => b.startTime.compareTo(a.startTime));
    return allEvents.take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<City>(
              value: _selectedCity,
              underline: const SizedBox(),
              items: City.values.map((city) {
                final event = Event(
                  title: '',
                  description: '',
                  startTime: DateTime.now(),
                  endTime: DateTime.now(),
                  category: EventCategory.petTrainersAndSitters,
                  city: city,
                );
                return DropdownMenuItem(
                  value: city,
                  child: Text(
                    event.cityName,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }).toList(),
              onChanged: (City? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCity = newValue;
                    _loadSampleEvents(); // Reload events for the new city
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Section
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(26),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Your Appointments in ${_selectedCity == City.schweinfurt ? 'Schweinfurt' : 'Würzburg'}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TableCalendar(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2025, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    eventLoader: _getEventsForDay,
                    calendarStyle: CalendarStyle(
                      markersMaxCount: 3,
                      markerDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withAlpha(77),
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: const TextStyle(color: Colors.red),
                      outsideDaysVisible: false,
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                  ),
                  if (_selectedDay != null) ...[
                    const Divider(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Events for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._getEventsForDay(_selectedDay!).map(
                      (event) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withAlpha(26),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          leading: CircleAvatar(
                            backgroundColor: event.categoryColor.withAlpha(51),
                            radius: 24,
                            child: Icon(event.categoryIcon, color: event.categoryColor, size: 24),
                          ),
                          title: Text(
                            event.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          subtitle: Text(
                            '${event.startTime.hour}:${event.startTime.minute.toString().padLeft(2, '0')} - ${event.endTime.hour}:${event.endTime.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          isThreeLine: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),

            // Recent Activities Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Activities',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._getRecentEvents().map(
                    (event) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: event.categoryColor.withAlpha(51),
                          child: Icon(event.categoryIcon, color: event.categoryColor),
                        ),
                        title: Text(event.title),
                        subtitle: Text(
                          '${event.categoryName} - ${event.startTime.toString().split('.')[0]}',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: Navigate to event details
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 