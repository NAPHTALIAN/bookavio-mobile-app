import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        // Navigate to home page
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and Welcome Text
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png',
                    width: 48,
                    height: 48,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Welcome to Bookavio',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign in to continue',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 28),
                // Login Form
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            style: Theme.of(context).textTheme.bodyLarge,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _passwordController,
                            style: Theme.of(context).textTheme.bodyLarge,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Reset Password'),
                                    content: const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Enter your email to receive a password reset link.'),
                                        SizedBox(height: 16),
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            prefixIcon: Icon(Icons.email_outlined),
                                          ),
                                          keyboardType: TextInputType.emailAddress,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // TODO: Implement actual password reset logic
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Password reset link sent to your email')),
                                          );
                                        },
                                        child: const Text('Send Link'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Forgot Password?',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 40,
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: _isSubmitting 
                                  ? Colors.green 
                                  : Theme.of(context).colorScheme.primary,
                              ),
                              child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Login',
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Google Sign-In Button
                ElevatedButton.icon(
                  icon: Image.asset(
                    'assets/logo.png', // You can use a Google logo asset if you have one
                    width: 24,
                    height: 24,
                  ),
                  label: const Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  onPressed: _handleGoogleSignIn,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
      // clientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com', // Uncomment and set if needed
    );
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        // You can use account.email, account.displayName, etc.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed in as: \\${account.email}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: \\${error.toString()}')),
      );
    }
  }
} 