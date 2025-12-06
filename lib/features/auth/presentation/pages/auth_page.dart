import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nvs/meatup_core.dart';
import 'package:nvs/features/auth/presentation/widgets/auth_form.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn(String email, String password) async {
    setState(() => _isLoading = true);

    try {
      await AuthService.signInWithEmail(email, password);

      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSignUp(
    String email,
    String password,
    String username,
    String fullName,
  ) async {
    setState(() => _isLoading = true);

    try {
      await AuthService.signUpWithEmail(email, password);

      if (mounted) {
        context.go('/onboarding');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              AppTheme.backgroundColor,
              AppTheme.backgroundColor.withValues(alpha: 0.85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // Logo and title section
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // App logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              AppTheme.primaryColor,
                              AppTheme.primaryColor.withValues(alpha: 0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppTheme.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 60,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // App title
                      Text(
                        'YO BRO',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'Connect with your community',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.secondaryTextColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              // Auth form section
              Expanded(
                flex: 3,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      // Tab bar
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelColor: Colors.black,
                          unselectedLabelColor: AppTheme.secondaryTextColor,
                          tabs: const <Widget>[
                            Tab(text: 'Sign In'),
                            Tab(text: 'Sign Up'),
                          ],
                        ),
                      ),

                      // Tab content
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            // Sign In Tab
                            AuthForm(
                              isSignIn: true,
                              isLoading: _isLoading,
                              onSubmit: (String email, String password, [_, __]) =>
                                  _handleSignIn(email, password),
                            ),

                            // Sign Up Tab
                            AuthForm(
                              isSignIn: false,
                              isLoading: _isLoading,
                              onSubmit: (
                                String email,
                                String password, [
                                String? username,
                                String? fullName,
                              ]) {
                                _handleSignUp(
                                  email,
                                  password,
                                  username ?? '',
                                  fullName ?? '',
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
