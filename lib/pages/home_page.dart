import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event.dart';
import 'services_page.dart';
import 'profile_page.dart';
import '../screens/dashboard_screen.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const ServicesPage(),
    const ChatPage(),
    const DashboardScreen(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.miscellaneous_services), label: 'Services'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chats',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  late AnimationController _bounceAnimation;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Event> _events = [];
  int _unreadNotifications = 5;
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Messages', 'Appointments', 'Payments', 'Services', 'Promotions', 'System'];
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: 'New Message',
      message: 'You have a new message from John',
      icon: Icons.message,
      color: Colors.blue,
      category: 'Messages',
      time: DateTime.now().subtract(const Duration(minutes: 2)),
      isUnread: true,
      action: NotificationAction(
        label: 'Reply',
        onTap: () {
          // Handle reply action
        },
      ),
    ),
    NotificationItem(
      title: 'Appointment Reminder',
      message: 'Your appointment with Dr. Smith is tomorrow at 10:00 AM',
      icon: Icons.event,
      color: Colors.orange,
      category: 'Appointments',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      isUnread: true,
      action: NotificationAction(
        label: 'View Details',
        onTap: () {
          // Handle view details action
        },
      ),
    ),
    NotificationItem(
      title: 'Payment Successful',
      message: 'Your payment of \$50 has been processed',
      icon: Icons.payment,
      color: Colors.green,
      category: 'Payments',
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isUnread: true,
      action: NotificationAction(
        label: 'View Receipt',
        onTap: () {
          // Handle view receipt action
        },
      ),
    ),
    NotificationItem(
      title: 'Service Update',
      message: 'New services available in your area',
      icon: Icons.new_releases,
      color: Colors.purple,
      category: 'Services',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isUnread: false,
    ),
    NotificationItem(
      title: 'Special Offer',
      message: 'Get 20% off on your next booking',
      icon: Icons.local_offer,
      color: Colors.red,
      category: 'Promotions',
      time: DateTime.now().subtract(const Duration(hours: 5)),
      isUnread: true,
      action: NotificationAction(
        label: 'View Offer',
        onTap: () {
          // Handle view offer action
        },
      ),
    ),
    NotificationItem(
      title: 'System Update',
      message: 'New features have been added to the app',
      icon: Icons.system_update,
      color: Colors.teal,
      category: 'System',
      time: DateTime.now().subtract(const Duration(days: 2)),
      isUnread: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Add some sample events
    _events = [
      Event(
        title: 'Dog Training',
        description: 'Basic obedience training with certified trainer',
        startTime: DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day, 10, 0),
        endTime: DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day, 11, 0),
        category: EventCategory.petTrainersAndSitters,
        city: City.schweinfurt,
        hasReminder: true,
        reminderTime: DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day, 9, 45),
      ),
      Event(
        title: 'Math Tutoring',
        description: 'Advanced calculus preparation',
        startTime: DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day, 15, 0),
        endTime: DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day, 16, 0),
        category: EventCategory.tutors,
        city: City.schweinfurt,
      ),
    ];

    // Initialize bounce animation
    _bounceAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _bounceAnimation.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceAnimation.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events.where((event) => isSameDay(event.startTime, day)).toList();
  }

  void _addEvent(Event event) {
    setState(() {
      _events.add(event);
    });
  }

  void _showAddEventDialog() {
    final formKey = GlobalKey<FormState>();
    String title = '';
    String description = '';
    DateTime startTime = _selectedDay ?? DateTime.now();
    DateTime endTime = (_selectedDay ?? DateTime.now()).add(const Duration(hours: 1));
    EventCategory category = EventCategory.tutors;
    CoachSubCategory? coachSubCategory;
    City city = City.schweinfurt;
    bool hasReminder = false;
    DateTime? reminderTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.event_note, color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Text('Add New Event', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: 24),
                Flexible(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Enter Your Full Name',
                              prefixIcon: const Icon(Icons.title),
                              filled: true,
                              fillColor: Colors.grey[50],
                                hintText: 'Enter your full name',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                              validator: (value) => value?.isEmpty ?? true ? 'Enter your full name' : null,
                            onChanged: (value) => title = value,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Enter Email',
                                prefixIcon: const Icon(Icons.email),
                              filled: true,
                              fillColor: Colors.grey[50],
                                hintText: 'Enter your email address',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            onChanged: (value) => description = value,
                          ),
                          const SizedBox(height: 16),
                          Text('City', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: DropdownButtonFormField<City>(
                              value: city,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
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
                                  child: Text(event.cityName),
                                );
                              }).toList(),
                              onChanged: (newCity) => newCity != null ? city = newCity : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Category', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: DropdownButtonFormField<EventCategory>(
                              value: category,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                              isExpanded: true,
                              items: [
                                EventCategory.tutors,
                                EventCategory.petTrainersAndSitters,
                                EventCategory.coaches,
                              ].map((cat) {
                                final event = Event(
                                  title: '',
                                  description: '',
                                  startTime: DateTime.now(),
                                  endTime: DateTime.now(),
                                  category: cat,
                                  city: city,
                                );
                                return DropdownMenuItem(
                                  value: cat,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(event.categoryIcon, color: event.categoryColor),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: Text(
                                          event.categoryName,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (cat) {
                                if (cat != null) {
                                  setState(() {
                                    category = cat;
                                    if (cat != EventCategory.coaches) {
                                      coachSubCategory = null;
                                    }
                                  });
                                }
                              },
                            ),
                          ),
                          if (category == EventCategory.coaches) ...[
                            const SizedBox(height: 16),
                            Text('Select Coaching Service', 
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: DropdownButtonFormField<CoachSubCategory>(
                                value: coachSubCategory,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                                ),
                                isExpanded: true,
                                hint: const Text('Click to select'),
                                items: CoachSubCategory.values.map((subCat) {
                                  final event = Event(
                                    title: '',
                                    description: '',
                                    startTime: DateTime.now(),
                                    endTime: DateTime.now(),
                                    category: EventCategory.coaches,
                                    coachSubCategory: subCat,
                                    city: city,
                                  );
                                  return DropdownMenuItem(
                                    value: subCat,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(event.categoryIcon, color: event.categoryColor),
                                        const SizedBox(width: 12),
                                        Flexible(
                                          child: Text(
                                            event.categoryName,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (subCat) {
                                  if (subCat != null) {
                                    setState(() {
                                      coachSubCategory = subCat;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Text('Select Date', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: startTime,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                setState(() {
                                  startTime = DateTime(
                                    picked.year,
                                    picked.month,
                                    picked.day,
                                    startTime.hour,
                                    startTime.minute,
                                  );
                                  endTime = DateTime(
                                    picked.year,
                                    picked.month,
                                    picked.day,
                                    endTime.hour,
                                    endTime.minute,
                                  );
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${startTime.day}/${startTime.month}/${startTime.year}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Start Time', style: Theme.of(context).textTheme.titleMedium),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: () async {
                                        final picked = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(startTime),
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            startTime = DateTime(
                                              startTime.year,
                                              startTime.month,
                                              startTime.day,
                                              picked.hour,
                                              picked.minute,
                                            );
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey[200]!),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary),
                                            const SizedBox(width: 8),
                                            Text('${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('End Time', style: Theme.of(context).textTheme.titleMedium),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: () async {
                                        final picked = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(endTime),
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            endTime = DateTime(
                                              endTime.year,
                                              endTime.month,
                                              endTime.day,
                                              picked.hour,
                                              picked.minute,
                                            );
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey[200]!),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary),
                                            const SizedBox(width: 8),
                                            Text('${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                            const SizedBox(height: 16),
                            Text('Set Price (€)', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Enter Price',
                                prefixIcon: const Icon(Icons.euro),
                                filled: true,
                                fillColor: Colors.grey[50],
                                hintText: 'Enter price in euros',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                suffixText: '€',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Enter a price';
                                }
                                if (double.tryParse(value!) == null) {
                                  return 'Enter a valid number';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                // Store the price value
                                if (value.isNotEmpty) {
                                  final price = double.tryParse(value);
                                  if (price != null) {
                                    // You can store this in a variable or use it as needed
                                  }
                                }
                              },
                            ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: SwitchListTile(
                              title: Text('Set Reminder', style: Theme.of(context).textTheme.titleMedium),
                              value: hasReminder,
                              onChanged: (val) => setState(() => hasReminder = val),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            ),
                            if (hasReminder) ...[
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(reminderTime ?? startTime),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      reminderTime = DateTime(
                                        startTime.year,
                                        startTime.month,
                                        startTime.day,
                                        picked.hour,
                                        picked.minute,
                                      );
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.alarm, color: Theme.of(context).colorScheme.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                        reminderTime != null
                                            ? 'Reminder at ${reminderTime!.hour.toString().padLeft(2, '0')}:${reminderTime!.minute.toString().padLeft(2, '0')}'
                                            : 'Set Reminder Time',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                            if (category == EventCategory.coaches && coachSubCategory == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please select a coaching type')),
                              );
                              return;
                            }
                          _addEvent(Event(
                            title: title,
                            description: description,
                            startTime: startTime,
                            endTime: endTime,
                            category: category,
                              coachSubCategory: coachSubCategory,
                            city: city,
                            hasReminder: hasReminder,
                            reminderTime: reminderTime,
                          ));
                          Navigator.pop(context);
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text('Successfully booked: $title'),
                                ],
                              ),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(10),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEventDetails(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(event.categoryIcon, color: event.categoryColor),
            const SizedBox(width: 8),
            Text(event.title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${event.categoryName}'),
            const SizedBox(height: 8),
            Text('Description: ${event.description}'),
            const SizedBox(height: 8),
            Text('Start: ${event.startTime}'),
            Text('End: ${event.endTime}'),
            if (event.hasReminder && event.reminderTime != null)
              Text('Reminder: ${event.reminderTime}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      if (_unreadNotifications > 0)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _unreadNotifications = 0;
                              for (var notification in _notifications) {
                                notification.isUnread = false;
                              }
                            });
                          },
                          child: const Text('Mark all as read'),
                        ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () => _showFilterDialog(context, setState),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Category filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      checkmarkColor: Theme.of(context).colorScheme.primary,
                    ),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: _getFilteredNotifications().map((notification) => 
                    _buildNotificationItem(notification, setState)
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<NotificationItem> _getFilteredNotifications() {
    if (_selectedCategory == 'All') {
      return _notifications;
    }
    return _notifications.where((n) => n.category == _selectedCategory).toList();
  }

  void _showFilterDialog(BuildContext context, StateSetter setState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Show all notifications'),
              leading: Radio<String>(
                value: 'all',
                groupValue: 'all',
                onChanged: (value) {
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Show unread only'),
              leading: Radio<String>(
                value: 'unread',
                groupValue: 'all',
                onChanged: (value) {
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('Show read only'),
              leading: Radio<String>(
                value: 'read',
                groupValue: 'all',
                onChanged: (value) {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification, StateSetter setState) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isUnread ? notification.color.withOpacity(0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isUnread ? notification.color.withOpacity(0.3) : Colors.grey[200]!,
        ),
        boxShadow: notification.isUnread ? [
          BoxShadow(
            color: notification.color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: notification.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(notification.icon, color: notification.color),
            ),
            title: Text(
              notification.title,
              style: TextStyle(
                fontWeight: notification.isUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(notification.message),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _getTimeAgo(notification.time),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (notification.isUnread)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: notification.color,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            onTap: () {
              if (notification.isUnread) {
                setState(() {
                  notification.isUnread = false;
                  _unreadNotifications--;
                });
              }
              if (notification.action != null) {
                notification.action!.onTap();
              }
            },
          ),
          if (notification.action != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: notification.color.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: notification.action!.onTap,
                    child: Text(
                      notification.action!.label,
                      style: TextStyle(
                        color: notification.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 100,
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: _showNotifications,
                        ),
                        if (_unreadNotifications > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                _unreadNotifications.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              // Popular Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Popular Categories',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryCard(
                      context,
                      'Tutors',
                      Icons.school,
                      Theme.of(context).colorScheme.primary,
                    ),
                    _buildCategoryCard(
                      context,
                      'Coaches',
                      Icons.sports,
                      Theme.of(context).colorScheme.secondary,
                    ),
                    _buildCategoryCard(
                      context,
                      'Pet Trainers & Sitters',
                      Icons.pets,
                      Colors.orange,
                    ),
                    _buildCategoryCard(
                      context,
                      'Others',
                      Icons.event,
                      Colors.green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Calendar Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TableCalendar<Event>(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          eventLoader: _getEventsForDay,
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
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                          calendarStyle: CalendarStyle(
                            markersMaxCount: 3,
                            markerDecoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: true,
                            titleCentered: true,
                            formatButtonShowsNext: false,
                            formatButtonDecoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            formatButtonTextStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            leftChevronIcon: Icon(
                              Icons.chevron_left,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          calendarBuilders: CalendarBuilders<Event>(
                            markerBuilder: (context, date, events) {
                              if (events.isNotEmpty) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: events.take(3).map((event) => Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      color: event.categoryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  )).toList(),
                                );
                              }
                              return null;
                            },
                          ),
                          availableCalendarFormats: const {
                            CalendarFormat.week: 'Week',
                            CalendarFormat.twoWeeks: '2 Weeks',
                            CalendarFormat.month: 'Month',
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_selectedDay != null && _getEventsForDay(_selectedDay!).isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Events for ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              ..._getEventsForDay(_selectedDay!).map((event) => Card(
                                    child: ListTile(
                                      leading: Icon(event.categoryIcon, color: event.categoryColor),
                                      title: Text(
                                        event.title,
                                        style: TextStyle(
                                          color: (_selectedDay!.day == 18 && 
                                                 _selectedDay!.month == 6 && 
                                                 _selectedDay!.year == 2025) 
                                            ? Colors.orange 
                                            : null,
                                        ),
                                      ),
                                      subtitle: Text(event.description),
                                      trailing: event.hasReminder ? const Icon(Icons.alarm, color: Colors.red) : null,
                                      onTap: () => _showEventDetails(event),
                                    ),
                                  )),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Special Deals
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Special Deals',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 12),
              FlutterCarousel(
                options: CarouselOptions(
                  height: 200,
                  viewportFraction: 0.9,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  padEnds: true,
                ),
                items: [
                  _buildDealCard(
                    context,
                    'Free Session',
                    'New clients',
                    'assets/deals/free_session.jpg',
                  ),
                  _buildDealCard(
                    context,
                    'Group Class',
                    'Save 20%',
                    'assets/deals/group_class.jpg',
                  ),
                  _buildDealCard(
                    context,
                    'Wellness Pack',
                    '3 sessions',
                    'assets/deals/wellness_pack.jpg',
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          right: 30,
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 1.1).animate(
              CurvedAnimation(
                parent: _bounceAnimation,
                curve: Curves.easeInOut,
              ),
            ),
            child: FloatingActionButton(
              onPressed: _showAddEventDialog,
              tooltip: 'Add Event',
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealCard(
    BuildContext context,
    String title,
    String subtitle,
    String imagePath,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isAttaching = false;
  bool _isSearching = false;
  String _searchQuery = '';
  bool _hasText = false;
  bool _showScrollButton = false;

  @override
  void initState() {
    super.initState();
    // Add some sample messages
    _messages.addAll([
      ChatMessage(
        text: "Hello! How can I help you today?",
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        text: "I'd like to book an appointment",
        isMe: true,
        time: DateTime.now().subtract(const Duration(minutes: 4)),
        status: MessageStatus.read,
      ),
      ChatMessage(
        text: "Sure! What type of service are you looking for?",
        isMe: false,
        time: DateTime.now().subtract(const Duration(minutes: 3)),
        status: MessageStatus.read,
      ),
    ]);

    // Add listener to text controller
    _messageController.addListener(() {
      setState(() {
        _hasText = _messageController.text.trim().isNotEmpty;
      });
    });

    // Add scroll listener
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    final delta = MediaQuery.of(context).size.height * 0.2;
    
    setState(() {
      _showScrollButton = currentScroll < maxScroll - delta;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      setState(() => _isAttaching = true);
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name;
        
        // Add message with attachment
        _addMessage(
          text: "Sent an attachment",
          attachmentPath: file.path,
          attachmentName: fileName,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    } finally {
      setState(() => _isAttaching = false);
    }
  }

  void _addMessage({
    required String text,
    String? attachmentPath,
    String? attachmentName,
  }) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isMe: true,
          time: DateTime.now(),
          status: MessageStatus.sending,
          attachmentPath: attachmentPath,
          attachmentName: attachmentName,
        ),
      );
    });

    // Simulate message status changes
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages.last = ChatMessage(
            text: _messages.last.text,
            isMe: _messages.last.isMe,
            time: _messages.last.time,
            status: MessageStatus.sent,
            attachmentPath: _messages.last.attachmentPath,
            attachmentName: _messages.last.attachmentName,
          );
        });
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.last = ChatMessage(
            text: _messages.last.text,
            isMe: _messages.last.isMe,
            time: _messages.last.time,
            status: MessageStatus.delivered,
            attachmentPath: _messages.last.attachmentPath,
            attachmentName: _messages.last.attachmentName,
          );
        });
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messages.last = ChatMessage(
            text: _messages.last.text,
            isMe: _messages.last.isMe,
            time: _messages.last.time,
            status: MessageStatus.read,
            attachmentPath: _messages.last.attachmentPath,
            attachmentName: _messages.last.attachmentName,
          );
        });
      }
    });

    // Scroll to bottom
    _scrollToBottom();

    // Simulate reply after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: "Thanks for your message! I'll get back to you soon.",
              isMe: false,
              time: DateTime.now(),
              status: MessageStatus.read,
            ),
          );
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    // Add a subtle animation when sending
    setState(() {
      _addMessage(text: _messageController.text);
      _messageController.clear();
      _hasText = false;
    });
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search Messages'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _isSearching = true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Clear Chat'),
              onTap: () {
                Navigator.pop(context);
                _showClearChatConfirmation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Settings'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show notification settings
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearChatConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  List<ChatMessage> _getFilteredMessages() {
    if (_searchQuery.isEmpty) return _messages;
    return _messages.where((message) => 
      message.text.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search messages...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Text(
                'Chats',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchQuery = '';
                });
              },
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.videocam_outlined),
              onPressed: () {
                // TODO: Implement video call
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Video call coming soon!')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.call_outlined),
              onPressed: () {
                // TODO: Implement audio call
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Audio call coming soon!')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _showChatOptions,
            ),
          ],
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 120,
                  ),
                  itemCount: _getFilteredMessages().length,
                  itemBuilder: (context, index) {
                    final message = _getFilteredMessages()[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
              if (!_isSearching) _buildMessageInput(),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 140,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 200),
              offset: Offset(0, _showScrollButton ? 0 : 2),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _showScrollButton ? 1 : 0,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: _scrollToBottom,
                  child: const Icon(Icons.arrow_downward, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: () => _showMessageOptions(message),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isMe 
                    ? Theme.of(context).colorScheme.primary 
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.attachmentPath != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.attach_file, size: 16),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              message.attachmentName ?? 'Attachment',
                              style: TextStyle(
                                color: message.isMe ? Colors.white : Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.time),
                        style: TextStyle(
                          fontSize: 12,
                          color: message.isMe 
                              ? Colors.white.withOpacity(0.7) 
                              : Colors.black.withOpacity(0.5),
                        ),
                      ),
                      if (message.isMe) ...[
                        const SizedBox(width: 4),
                        _buildStatusIcon(message.status),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (message.reactions.isNotEmpty) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: message.reactions.map((reaction) => Text(
                  reaction,
                  style: const TextStyle(fontSize: 16),
                )).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showMessageOptions(ChatMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Message'),
              onTap: () {
                Navigator.pop(context);
                _copyMessage(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.forward),
              title: const Text('Forward Message'),
              onTap: () {
                Navigator.pop(context);
                _forwardMessage(message);
              },
            ),
            if (message.isMe)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete Message'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteMessage(message);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _copyMessage(ChatMessage message) {
    Clipboard.setData(ClipboardData(text: message.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message copied to clipboard')),
    );
  }

  void _forwardMessage(ChatMessage message) {
    // TODO: Implement message forwarding to other chats
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message forwarding coming soon!')),
    );
  }

  void _deleteMessage(ChatMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.remove(message);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    IconData icon;
    double size = 14;

    switch (status) {
      case MessageStatus.sending:
        icon = Icons.schedule;
        break;
      case MessageStatus.sent:
        icon = Icons.check;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        break;
    }

    return Icon(
      icon,
      size: size,
      color: status == MessageStatus.read 
          ? Colors.blue 
          : Colors.white.withOpacity(0.7),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.attach_file,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: _isAttaching ? null : _pickFile,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: _showEmojiPicker,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                        child: IconButton(
                          key: ValueKey<bool>(_hasText),
                          icon: Icon(
                            Icons.send_rounded,
                            color: _hasText
                                ? Colors.orange
                                : Colors.grey[400],
                          ),
                          onPressed: _hasText ? _sendMessage : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmojiPicker() {
    final Map<String, List<String>> emojiCategories = {
      'Frequently Used': ['👍', '❤️', '😂', '😮', '😢', '🙏'],
      'Smileys': ['😀', '😃', '😄', '😁', '😅', '😂', '🤣', '😊', '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰'],
      'Gestures': ['👋', '🤚', '🖐️', '✋', '🖖', '👌', '🤌', '🤏', '✌️', '🤞', '🤟', '🤘', '🤙', '👈', '👉'],
      'Hearts': ['❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎', '💔', '❤️‍🔥', '❤️‍🩹', '💖', '💗', '💓'],
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Reaction',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DefaultTabController(
                length: emojiCategories.length,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: TabBar(
                        isScrollable: true,
                        labelColor: Theme.of(context).colorScheme.primary,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        tabs: emojiCategories.keys.map((category) => 
                          Tab(text: category)
                        ).toList(),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: emojiCategories.values.map((emojis) => 
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                              itemCount: emojis.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  if (_messages.isNotEmpty) {
                                    setState(() {
                                      final lastMessage = _messages.last;
                                      _messages[_messages.length - 1] = ChatMessage(
                                        text: lastMessage.text,
                                        isMe: lastMessage.isMe,
                                        time: lastMessage.time,
                                        status: lastMessage.status,
                                        attachmentPath: lastMessage.attachmentPath,
                                        attachmentName: lastMessage.attachmentName,
                                        reactions: [...lastMessage.reactions, emojis[index]],
                                      );
                                    });
                                    // Scroll immediately
                                    _scrollToBottom();
                                  }
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      emojis[index],
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;
  final MessageStatus status;
  final String? attachmentPath;
  final String? attachmentName;
  final List<String> reactions;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.status = MessageStatus.sending,
    this.attachmentPath,
    this.attachmentName,
    this.reactions = const [],
  });
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read
}

class NotificationItem {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final String category;
  final DateTime time;
  bool isUnread;
  final NotificationAction? action;

  NotificationItem({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.category,
    required this.time,
    this.isUnread = false,
    this.action,
  });
}

class NotificationAction {
  final String label;
  final VoidCallback onTap;

  NotificationAction({
    required this.label,
    required this.onTap,
  });
} 