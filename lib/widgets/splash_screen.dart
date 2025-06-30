import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../navigation/route_guards.dart';
import '../navigation/app_router.dart';
import '../navigation/route_constants.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _navigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    if (_navigated) return;
    final completed = await RouteGuards.hasCompletedOnboarding();
    if (!mounted) return;
    setState(() => _navigated = true);
    if (completed) {
      AppRouter.goToHome(context);
    } else {
      AppRouter.goToOnboarding(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
} 