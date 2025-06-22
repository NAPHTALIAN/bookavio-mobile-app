import 'package:flutter/material.dart';
import '../models/provider.dart';
import '../pages/provider_detail_page.dart';

class ProviderListingPage extends StatefulWidget {
  final String service;
  final String subService;

  const ProviderListingPage({
    super.key,
    required this.service,
    required this.subService,
  });

  @override
  State<ProviderListingPage> createState() => _ProviderListingPageState();
}

class _ProviderListingPageState extends State<ProviderListingPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  // Mock data - in a real app, this would come from an API
  late List<Provider> _providers;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  void _loadProviders() {
    _providers = _getMockProviders();
  }

  List<Provider> _getMockProviders() {
    return [
      Provider(
        id: '1',
        name: 'Dr. Sarah Johnson',
        service: widget.service,
        subService: widget.subService,
        image: 'assets/logo.png',
        rating: 4.8,
        reviewCount: 127,
        location: 'New York, NY',
        hourlyRate: 75.0,
        availability: ['Monday', 'Wednesday', 'Friday'],
        description: 'Experienced professional with 5+ years in the field.',
        specializations: ['Advanced Level', 'Test Preparation'],
        isAvailable: true,
      ),
      Provider(
        id: '2',
        name: 'Prof. Michael Chen',
        service: widget.service,
        subService: widget.subService,
        image: 'assets/logo.png',
        rating: 4.9,
        reviewCount: 89,
        location: 'Los Angeles, CA',
        hourlyRate: 85.0,
        availability: ['Tuesday', 'Thursday', 'Saturday'],
        description: 'University professor with extensive teaching experience.',
        specializations: ['College Level', 'Research Methods'],
        isAvailable: true,
      ),
      Provider(
        id: '3',
        name: 'Ms. Emily Rodriguez',
        service: widget.service,
        subService: widget.subService,
        image: 'assets/logo.png',
        rating: 4.7,
        reviewCount: 156,
        location: 'Chicago, IL',
        hourlyRate: 65.0,
        availability: ['Monday', 'Tuesday', 'Thursday', 'Friday'],
        description: 'Certified professional with a passion for teaching.',
        specializations: ['High School', 'Beginner Friendly'],
        isAvailable: false,
      ),
    ];
  }

  List<Provider> get _filteredProviders {
    List<Provider> filtered = _providers;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((provider) {
        final name = provider.name.toLowerCase();
        final location = provider.location.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || location.contains(query);
      }).toList();
    }

    // Filter by availability
    if (_selectedFilter == 'Available') {
      filtered = filtered.where((provider) => provider.isAvailable).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('${widget.subService} Providers'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search providers...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Filter: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedFilter == 'All',
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = 'All';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Available'),
                      selected: _selectedFilter == 'Available',
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = 'Available';
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Provider List
          Expanded(
            child: _filteredProviders.isEmpty
                ? const Center(
                    child: Text(
                      'No providers found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredProviders.length,
                    itemBuilder: (context, index) {
                      final provider = _filteredProviders[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProviderDetailPage(
                                  provider: provider,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Provider Image
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(provider.image),
                                ),
                                const SizedBox(width: 16),
                                // Provider Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Name and Availability Status
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              provider.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (!provider.isAvailable)
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.red[100],
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                'Unavailable',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      // Ratings
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 16,
                                            color: Colors.amber[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${provider.rating} (${provider.reviewCount} reviews)',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      // Location
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 16,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              provider.location,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      // Charges
                                      Text(
                                        '\$${provider.hourlyRate.toStringAsFixed(0)}/hour',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Availability
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.schedule,
                                            size: 16,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              'Available: ${provider.availability.join(', ')}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
} 