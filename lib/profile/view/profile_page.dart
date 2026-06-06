import 'package:flutter/material.dart';
import 'package:trends/profile/view/profile_view.dart';

/// Profile route entry.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}
