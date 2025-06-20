import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allServices = [
    {
      'title': 'Tutoring',
      'description': 'Expert academic guidance and personalized learning support',
      'icon': Icons.school,
      'color': Colors.blue,
    },
    {
      'title': 'Sport Coach',
      'description': 'Professional sports training and performance enhancement',
      'icon': Icons.sports,
      'color': Colors.green,
    },
    {
      'title': 'Life Coach',
      'description': 'Personal development and life transformation guidance',
      'icon': Icons.self_improvement,
      'color': Colors.purple,
    },
    {
      'title': 'Health Trainer',
      'description': 'Holistic health and wellness coaching',
      'icon': Icons.health_and_safety,
      'color': Colors.red,
    },
    {
      'title': 'Spiritual Coach',
      'description': 'Spiritual growth and mindfulness guidance',
      'icon': Icons.spa,
      'color': Colors.indigo,
    },
    {
      'title': 'Business Coach',
      'description': 'Business strategy and entrepreneurial guidance',
      'icon': Icons.business,
      'color': Colors.orange,
    },
    {
      'title': 'Financial Advisor',
      'description': 'Financial planning and investment guidance',
      'icon': Icons.account_balance,
      'color': Colors.teal,
    },
    {
      'title': 'Personal Trainer',
      'description': 'Customized fitness and workout programs',
      'icon': Icons.fitness_center,
      'color': Colors.pink,
    },
    {
      'title': 'Fitness Coach',
      'description': 'Comprehensive fitness and exercise coaching',
      'icon': Icons.directions_run,
      'color': Colors.amber,
    },
    {
      'title': 'Career Coach',
      'description': 'Career development and professional growth guidance',
      'icon': Icons.work,
      'color': Colors.cyan,
    },
  ];

  List<Map<String, dynamic>> get _filteredServices {
    if (_searchQuery.isEmpty) {
      return _allServices;
    }
    return _allServices.where((service) {
      final title = service['title'].toString().toLowerCase();
      final description = service['description'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query) || description.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Our Services',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search services...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = _filteredServices[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          onTap: () {
                            // TODO: Navigate to service details
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: service['color'].withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    service['icon'],
                                    size: 28,
                                    color: service['color'],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  service['title'],
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  service['description'],
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
