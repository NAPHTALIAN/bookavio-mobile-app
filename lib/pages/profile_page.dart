import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';
  final String _profileImageUrl = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Notification settings
  bool _enablePushNotifications = true;
  bool _enableEmailNotifications = true;
  bool _enableAppointmentReminders = true;
  bool _enablePromotionalNotifications = true;
  bool _enableSystemNotifications = true;

  // Add these variables to the state class
  bool _isTwoFactorEnabled = false;
  bool _isBiometricEnabled = false;
  bool _isProfileVisible = true;
  bool _isLocationEnabled = true;
  bool _isDataUsageEnabled = false;

  // Add these variables to the state class
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String _selectedGender = 'Male';
  DateTime? _selectedDate;
  final bool _isEditing = true;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward();

    // Initialize controllers with user data
    _nameController.text = 'John Doe';
    _emailController.text = 'john.doe@example.com';
    _phoneController.text = '+1 234 567 8900';
    _addressController.text = '123 Main St, City, Country';
    _bioController.text = 'Passionate about technology and innovation.';
    _selectedDate = DateTime(1990, 1, 1);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _editProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    controller: TextEditingController(text: _name),
                    onChanged: (value) => _name = value,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    controller: TextEditingController(text: _email),
                    onChanged: (value) => _email = value,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Save Changes'),
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

  void _showSettingsDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('This feature is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Settings',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                        color: Theme.of(context).colorScheme.primary,
                        iconSize: 20,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _enablePushNotifications = true;
                                    _enableEmailNotifications = true;
                                    _enableAppointmentReminders = true;
                                    _enablePromotionalNotifications = true;
                                    _enableSystemNotifications = true;
                                  });
                                },
                                icon: const Icon(Icons.check_circle_outline, size: 18),
                                label: const Text('Enable All'),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  textStyle: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildNotificationSetting(
                            'Push Notifications',
                            'Receive notifications on your device',
                            _enablePushNotifications,
                            (value) => setState(() => _enablePushNotifications = value),
                          ),
                          _buildNotificationSetting(
                            'Email Notifications',
                            'Receive notifications via email',
                            _enableEmailNotifications,
                            (value) => setState(() => _enableEmailNotifications = value),
                          ),
                          _buildNotificationSetting(
                            'Appointment Reminders',
                            'Get reminded about your appointments',
                            _enableAppointmentReminders,
                            (value) => setState(() => _enableAppointmentReminders = value),
                          ),
                          _buildNotificationSetting(
                            'Promotional Notifications',
                            'Receive offers and promotions',
                            _enablePromotionalNotifications,
                            (value) => setState(() => _enablePromotionalNotifications = value),
                          ),
                          _buildNotificationSetting(
                            'System Notifications',
                            'Receive updates about the app',
                            _enableSystemNotifications,
                            (value) => setState(() => _enableSystemNotifications = value),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            textStyle: const TextStyle(fontSize: 13),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Settings saved')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(fontSize: 13),
                          ),
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentSettings() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Methods',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: Theme.of(context).colorScheme.primary,
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPaymentMethod(
                          'Visa ending in 4242',
                          'Expires 12/25',
                          Icons.credit_card,
                          Colors.blue,
                          true,
                        ),
                        _buildPaymentMethod(
                          'Mastercard ending in 8888',
                          'Expires 09/24',
                          Icons.credit_card,
                          Colors.orange,
                          false,
                        ),
                        const SizedBox(height: 16),
                        TextButton.icon(
                          onPressed: () {
                            // TODO: Implement add new payment method
                          },
                          icon: const Icon(Icons.add_circle_outline, size: 18),
                          label: const Text('Add New Payment Method'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: const TextStyle(fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Payment History',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildPaymentHistoryItem(
                          'Haircut Appointment',
                          'March 15, 2024',
                          '\$45.00',
                          true,
                        ),
                        _buildPaymentHistoryItem(
                          'Facial Treatment',
                          'March 10, 2024',
                          '\$75.00',
                          true,
                        ),
                        _buildPaymentHistoryItem(
                          'Manicure & Pedicure',
                          'March 5, 2024',
                          '\$60.00',
                          false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(fontSize: 13),
                        ),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Payment settings updated')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontSize: 13),
                        ),
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacySecuritySettings() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Privacy & Security',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: Theme.of(context).colorScheme.primary,
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSecuritySection(
                          'Account Security',
                          [
                            _buildSecurityItem(
                              'Two-Factor Authentication',
                              '',
                              Icons.security,
                              Colors.blue,
                              _isTwoFactorEnabled,
                              _handleTwoFactorAuth,
                            ),
                            _buildSecurityItem(
                              'Biometric Authentication',
                              '',
                              Icons.fingerprint,
                              Colors.green,
                              _isBiometricEnabled,
                              _handleBiometricAuth,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSecuritySection(
                          'Privacy Settings',
                          [
                            _buildSecurityItem(
                              'Profile Visibility',
                              '',
                              Icons.visibility,
                              Colors.purple,
                              _isProfileVisible,
                              _handleProfileVisibility,
                            ),
                            _buildSecurityItem(
                              'Location Services',
                              '',
                              Icons.location_on,
                              Colors.orange,
                              _isLocationEnabled,
                              _handleLocationServices,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSecuritySection(
                          'Data & Privacy',
                          [
                            _buildSecurityItem(
                              'Data Usage',
                              '',
                              Icons.data_usage,
                              Colors.teal,
                              _isDataUsageEnabled,
                              _handleDataUsage,
                            ),
                            _buildSecurityItem(
                              'Download My Data',
                              '',
                              Icons.download,
                              Colors.indigo,
                              false,
                              _handleDownloadData,
                            ),
                            _buildSecurityItem(
                              'Delete Account',
                              '',
                              Icons.delete_forever,
                              Colors.red,
                              false,
                              _handleDeleteAccount,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(fontSize: 13),
                        ),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Privacy settings updated')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontSize: 13),
                        ),
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecuritySection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildSecurityItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isEnabled,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isEnabled 
            ? color.withAlpha(13)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEnabled 
              ? color
              : Colors.grey[300]!,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(13),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isEnabled ? FontWeight.w600 : FontWeight.normal,
            color: isEnabled ? color : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Switch(
          value: isEnabled,
          onChanged: (value) => onTap(),
          activeColor: color,
          inactiveTrackColor: Colors.red[200],
          inactiveThumbColor: Colors.red,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        dense: true,
        onTap: onTap,
      ),
    );
  }

  Widget _buildNotificationSetting(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: value 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: value ? FontWeight.w600 : FontWeight.normal,
            color: value 
                ? Theme.of(context).colorScheme.primary
                : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveTrackColor: Colors.red[200],
        inactiveThumbColor: Colors.red,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        dense: true,
      ),
    );
  }

  Widget _buildPaymentMethod(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isDefault,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDefault 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDefault 
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[300]!,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isDefault ? FontWeight.w600 : FontWeight.normal,
            color: isDefault 
                ? Theme.of(context).colorScheme.primary
                : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: isDefault
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Default',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () {
                  // TODO: Show payment method options
                },
              ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        dense: true,
      ),
    );
  }

  Widget _buildPaymentHistoryItem(
    String title,
    String date,
    String amount,
    bool isCompleted,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          date,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isCompleted ? Colors.green : Colors.orange,
              ),
            ),
            Text(
              isCompleted ? 'Completed' : 'Pending',
              style: TextStyle(
                fontSize: 12,
                color: isCompleted ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        dense: true,
      ),
    );
  }

  Future<void> _handleTwoFactorAuth() async {
    final context = this.context;
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Two-Factor Authentication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isTwoFactorEnabled
                  ? 'Are you sure you want to disable two-factor authentication?'
                  : 'Enable two-factor authentication for enhanced security?',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isTwoFactorEnabled ? Colors.red : null,
            ),
            child: Text(_isTwoFactorEnabled ? 'Disable' : 'Enable'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      setState(() => _isTwoFactorEnabled = !_isTwoFactorEnabled);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isTwoFactorEnabled
                ? 'Two-factor authentication enabled'
                : 'Two-factor authentication disabled',
          ),
        ),
      );
    }
  }

  Future<void> _handleBiometricAuth() async {
    final context = this.context;
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Biometric Authentication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isBiometricEnabled
                  ? 'Are you sure you want to disable biometric authentication?'
                  : 'Enable biometric authentication for quick and secure login?',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isBiometricEnabled ? Colors.red : null,
            ),
            child: Text(_isBiometricEnabled ? 'Disable' : 'Enable'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      setState(() => _isBiometricEnabled = !_isBiometricEnabled);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isBiometricEnabled
                ? 'Biometric authentication enabled'
                : 'Biometric authentication disabled',
          ),
        ),
      );
    }
  }

  Future<void> _handleProfileVisibility() async {
    final context = this.context;
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Visibility'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isProfileVisible
                  ? 'Are you sure you want to make your profile private?'
                  : 'Make your profile visible to other users?',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isProfileVisible ? Colors.red : null,
            ),
            child: Text(_isProfileVisible ? 'Make Private' : 'Make Public'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      setState(() => _isProfileVisible = !_isProfileVisible);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isProfileVisible
                ? 'Profile is now public'
                : 'Profile is now private',
          ),
        ),
      );
    }
  }

  Future<void> _handleLocationServices() async {
    final context = this.context;
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isLocationEnabled
                  ? 'Are you sure you want to disable location services?'
                  : 'Enable location services for better service recommendations?',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isLocationEnabled ? Colors.red : null,
            ),
            child: Text(_isLocationEnabled ? 'Disable' : 'Enable'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      setState(() => _isLocationEnabled = !_isLocationEnabled);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isLocationEnabled
                ? 'Location services enabled'
                : 'Location services disabled',
          ),
        ),
      );
    }
  }

  Future<void> _handleDataUsage() async {
    final context = this.context;
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Usage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isDataUsageEnabled
                  ? 'Are you sure you want to disable data usage?'
                  : 'Enable data usage for personalized experience?',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isDataUsageEnabled ? Colors.red : null,
            ),
            child: Text(_isDataUsageEnabled ? 'Disable' : 'Enable'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      setState(() => _isDataUsageEnabled = !_isDataUsageEnabled);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isDataUsageEnabled
                ? 'Data usage enabled'
                : 'Data usage disabled',
          ),
        ),
      );
    }
  }

  Future<void> _handleDownloadData() async {
    final context = this.context;
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate data download
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context); // Remove loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your data has been downloaded successfully'),
        ),
      );
    }
  }

  Future<void> _handleDeleteAccount() async {
    final context = this.context;
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Simulate account deletion
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pop(context); // Remove loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your account has been deleted successfully'),
          ),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void _showPersonalInfo() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bio',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                        iconSize: 20,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Basic Information Section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      color: Theme.of(context).colorScheme.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Basic Information',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildInfoField(
                                  'Full Name',
                                  _nameController,
                                  Icons.person,
                                  enabled: true,
                                ),
                                _buildInfoField(
                                  'Email',
                                  _emailController,
                                  Icons.email,
                                  enabled: true,
                                ),
                                _buildInfoField(
                                  'Phone',
                                  _phoneController,
                                  Icons.phone,
                                  enabled: true,
                                ),
                                _buildDatePicker(
                                  'Date of Birth',
                                  _selectedDate,
                                  enabled: true,
                                  onChanged: (date) => setState(() => _selectedDate = date),
                                ),
                                _buildGenderSelector(
                                  enabled: true,
                                  onChanged: (value) => setState(() => _selectedGender = value!),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Additional Information Section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Theme.of(context).colorScheme.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'More Details',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildInfoField(
                                  'Address',
                                  _addressController,
                                  Icons.location_on,
                                  enabled: true,
                                  maxLines: 2,
                                ),
                                _buildInfoField(
                                  'Bio',
                                  _bioController,
                                  Icons.description,
                                  enabled: true,
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              // Reset controllers to original values
                              _nameController.text = 'John Doe';
                              _emailController.text = 'john.doe@example.com';
                              _phoneController.text = '+1 234 567 8900';
                              _addressController.text = '123 Main St, City, Country';
                              _bioController.text = 'Passionate about technology and innovation.';
                              _selectedDate = DateTime(1990, 1, 1);
                              _selectedGender = 'Male';
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile updated successfully')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                          child: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = false,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, size: 20, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    String label,
    DateTime? selectedDate, {
    bool enabled = false,
    required Function(DateTime?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? Colors.grey[300]! : Colors.grey[200]!,
        ),
      ),
      child: ListTile(
        enabled: enabled,
        leading: const Icon(Icons.calendar_today, size: 20),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          selectedDate != null
              ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
              : 'Not set',
          style: const TextStyle(fontSize: 16),
        ),
        onTap: enabled
            ? () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  onChanged(picked);
                }
              }
            : null,
      ),
    );
  }

  Widget _buildGenderSelector({
    bool enabled = false,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? Colors.grey[300]! : Colors.grey[200]!,
        ),
      ),
      child: ListTile(
        enabled: enabled,
        leading: const Icon(Icons.person_outline, size: 20),
        title: const Text(
          'Gender',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        subtitle: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          underline: const SizedBox(),
          items: ['Male', 'Female', 'Other']
              .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
              .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'About Bookavio',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: Theme.of(context).colorScheme.primary,
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // App Logo and Version
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    'assets/logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Bookavio',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Version 1.0.0',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // App Description
                        _buildAboutSection(
                          'About',
                          'Bookavio is a Flutter-based booking application that provides users with a seamless learning experience. The app features various categories, and functionalities, and a user-friendly interface for easy navigation.',
                        ),

                        // Features
                        _buildAboutSection(
                          'Features',
                          '• Booking & Search\n'
                          '• Unforgettable Offers\n'
                          '• Secure Payment Processing\n'
                          '• Real-time Communication\n'
                          '• Good Time Management',
                        ),

                        // Legal Information
                        _buildAboutSection(
                          'Legal',
                          '© 2025 Bookavio. All rights reserved.',
                        ),
                        Center(
                          child: Text(
                            'Made with ❤️ for you',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 0),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () => _editProfile(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: _profileImage == null
                                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                : ClipOval(
                                    child: Image.file(
                                      _profileImage!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsItem(
                      context,
                      'Bio',
                      Icons.person_outline,
                      _showPersonalInfo,
                    ),
                    _buildSettingsItem(
                      context,
                      'Payment Methods',
                      Icons.payment,
                      _showPaymentSettings,
                    ),
                    _buildSettingsItem(
                      context,
                      'Notifications',
                      Icons.notifications_outlined,
                      _showNotificationSettings,
                    ),
                    _buildSettingsItem(
                      context,
                      'Privacy & Security',
                      Icons.security,
                      _showPrivacySecuritySettings,
                    ),
                    _buildSettingsItem(
                      context,
                      'About',
                      Icons.info_outline,
                      _showAboutDialog,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushReplacementNamed(context, '/login');
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
} 