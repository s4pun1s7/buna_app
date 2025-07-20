import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../navigation/route_constants.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart';
import '../common/index.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BunaDrawer extends ConsumerWidget {
  const BunaDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context, userAsync),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionTitle('Festival Features'),
                ...AppRoutes.drawerRoutes
                    .where((r) => r.isEnabled() && (r.name == AppRoutes.scheduleName || r.name == AppRoutes.artistsName))
                    .map((route) => _buildDrawerItem(context, icon: route.icon, title: route.title, route: route.path)),
                _buildSectionTitle('Interactive Features'),
                ...AppRoutes.drawerRoutes
                    .where((r) => r.isEnabled() && (r.name == AppRoutes.qrScannerName || r.name == AppRoutes.arName || r.name == AppRoutes.mapGalleryName || r.name == AppRoutes.socialName))
                    .map((route) => _buildDrawerItem(context, icon: route.icon, title: route.title, route: route.path)),
                _buildSectionTitle('Support Features'),
                ...AppRoutes.drawerRoutes
                    .where((r) => r.isEnabled() && r.name == AppRoutes.feedbackName)
                    .map((route) => _buildDrawerItem(context, icon: route.icon, title: route.title, route: route.path)),
              ],
            ),
          ),
          if (userAsync.value != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const AnimatedLoadingDialog(message: 'Signing out...'),
                  );
                  try {
                    await AuthService().signOut();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.of(context).pop(); // Close loading dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sign-out failed: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, AsyncValue<User?> userAsync) {
    final user = userAsync.value;
    final isGoogle =
        user != null &&
        user.providerData.any((p) => p.providerId == 'google.com');
    final displayName = isGoogle ? user.displayName ?? 'Google User' : 'Guest';
    final email = isGoogle ? user.email : null;
    final avatarUrl = isGoogle ? user.photoURL : null;
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: avatarUrl == null
                ? Icon(Icons.person, size: 32, semanticLabel: 'User avatar')
                : ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: avatarUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(strokeWidth: 2),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: 32,
                        semanticLabel: 'User avatar',
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (email != null)
                  Text(
                    email,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                if (!isGoogle)
                  Builder(
                    builder: (context) {
                      final scale = MediaQuery.textScalerOf(context).scale(1.0);
                      return Text(
                        'Guest',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14 * scale,
                        ),
                        semanticsLabel: 'Guest user',
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildSectionTitle(String title) {
    return Builder(
      builder: (context) {
        final textScaler = MediaQuery.textScalerOf(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: textScaler.scale(12),
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? route,
    VoidCallback? onTap,
  }) {
    final isSelected =
        route != null && GoRouterState.of(context).uri.path == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : null,
        semanticLabel: title,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (route != null) {
          context.go(route);
        } else if (onTap != null) {
          onTap();
        }
      },
    );
  }

}
