import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trends/core/errors/trends_error_handler.dart';
import 'package:trends/app/bloc/app_bloc.dart';
import 'package:trends/app/router/app_router.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const TrendsAppBar(title: 'Profile'),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state.status == AppStatus.unknown) {
            return const Center(child: TrendsLoader(message: 'Loading profile…'));
          }

          final user = state.user;
          if (user == null) {
            return TrendsEmptyState(
              title: 'Not signed in',
              subtitle: 'Sign in to view your account.',
              icon: Icons.person_outline,
              action: TrendsButton(
                label: 'Sign in',
                expand: false,
                onPressed: () => context.go(AppRoutes.login),
              ),
            );
          }

          final initials = _initials(user.displayName ?? user.email ?? 'U');

          return ListView(
            padding: const EdgeInsets.all(TrendsSpacing.marginMobile),
            children: [
              const SizedBox(height: TrendsSpacing.lg),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? Text(
                          initials,
                          style: TrendsTypography.headlineMedium(
                            colorScheme.onSurface,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: TrendsSpacing.md),
              Text(
                user.displayName ?? 'Trends Member',
                style: TrendsTypography.headlineSmall(colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
              if (user.email != null) ...[
                const SizedBox(height: TrendsSpacing.xs),
                Text(
                  user.email!,
                  style: TrendsTypography.bodyMedium(
                    colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: TrendsSpacing.xl),
              _ProfileTile(
                icon: Icons.shopping_bag_outlined,
                label: 'Orders',
                value: '${user.orderCount}',
              ),
              if (user.phone != null)
                _ProfileTile(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: user.phone!,
                ),
              _ProfileTile(
                icon: Icons.notifications_outlined,
                label: 'Marketing emails',
                value: user.preferences.marketingOptIn ? 'On' : 'Off',
              ),
              const SizedBox(height: TrendsSpacing.xl),
              TrendsButton(
                label: 'Edit profile',
                variant: TrendsButtonVariant.secondary,
                onPressed: () => context.push(
                  '${AppRoutes.onboarding}?edit=true',
                ),
              ),
              const SizedBox(height: TrendsSpacing.md),
              TrendsButton(
                label: 'Production & integrations',
                variant: TrendsButtonVariant.secondary,
                onPressed: () => TrendsErrorHandler.showContactSupport(context),
              ),
              const SizedBox(height: TrendsSpacing.md),
              TrendsButton(
                label: 'Sign out',
                variant: TrendsButtonVariant.secondary,
                onPressed: () => context.read<AppBloc>().add(
                  const AppSignOutRequested(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _initials(String value) {
    final parts = value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'T';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: TrendsSpacing.md),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: TrendsSpacing.md),
          Expanded(
            child: Text(
              label,
              style: TrendsTypography.bodyMedium(colorScheme.onSurface),
            ),
          ),
          Text(
            value,
            style: TrendsTypography.labelMedium(colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
