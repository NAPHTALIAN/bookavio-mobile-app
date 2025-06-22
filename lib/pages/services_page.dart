import 'package:flutter/material.dart';
import 'provider_listing_page.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _expandedServiceTitle;

  final List<Map<String, dynamic>> _allServices = [
    {
      'title': 'Tutors',
      'description': 'Find the best tutors for your needs.',
      'icon': Icons.school,
      'color': Colors.blue.shade400,
      'subServices': [
        'Maths Tutors',
        'Chemisty Tutors',
        'Physics Tutors',
        'Languages',
      ],
    },
    {
      'title': 'Pet Sitters & Trainers',
      'description': 'Expert care for your pets.',
      'icon': Icons.pets,
      'color': Colors.green.shade400,
      'subServices': [
        'Dog Sitters',
        'Dog Trainers',
        'Cat Sitters',
      ],
    },
    {
      'title': 'Coaches',
      'description': 'Achieve your goals with our professional coaches.',
      'icon': Icons.sports,
      'color': Colors.orange.shade400,
      'subServices': [
        'Wellness Coaches',
        'Mental Health Coaches',
        'Life Coaches',
        'Psychologists (Licensed Therapists)',
      ],
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
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Find Your Expert',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How It Works',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _HowItWorksStep(
                          icon: Icons.search,
                          text: 'Find Service',
                        ),
                        _HowItWorksStep(
                          icon: Icons.calendar_today,
                          text: 'Book a Date',
                        ),
                        _HowItWorksStep(
                          icon: Icons.payment,
                          text: 'Pay Securely',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Services',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for services...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
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
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _filteredServices.length,
                itemBuilder: (context, index) {
                  final service = _filteredServices[index];
                  final bool hasSubServices =
                      service.containsKey('subServices');
                  final bool isExpanded =
                      _expandedServiceTitle == service['title'];

                  if (hasSubServices) {
                    return Card(
                      elevation: 4,
                      shadowColor: Colors.grey.withOpacity(0.2),
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(15.0),
                            onTap: () {
                              setState(() {
                                _expandedServiceTitle =
                                    isExpanded ? null : service['title'];
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                          service['color'].withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      service['icon'],
                                      size: 32,
                                      color: service['color'],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          service['title'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          service['description'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: Colors.grey[600],
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                          isExpanded
                                              ? Icons.remove
                                              : Icons.add,
                                          color: Colors.black54),
                                      onPressed: () {
                                        setState(() {
                                          _expandedServiceTitle = isExpanded
                                              ? null
                                              : service['title'];
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isExpanded)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Divider(height: 1),
                            ),
                          if (isExpanded)
                            Column(
                              children: (service['subServices'] as List<String>)
                                  .map((subService) {
                                return ListTile(
                                  title: Text(subService),
                                  trailing: const Icon(Icons.arrow_forward_ios,
                                      size: 14),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProviderListingPage(
                                          service: service['title'],
                                          subService: subService,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    );
                  }

                  return Card(
                    elevation: 4,
                    shadowColor: Colors.grey.withOpacity(0.2),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: service['color'].withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              service['icon'],
                              size: 32,
                              color: service['color'],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service['title'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  service['description'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add, color: Colors.black54),
                              onPressed: () {
                                // TODO: Implement action
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _HowItWorksStep extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HowItWorksStep({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blue.shade50,
          child: Icon(
            icon,
            size: 30,
            color: Colors.blue.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
