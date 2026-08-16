import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/profile/presentation/providers/profile_notifier.dart';
import 'package:restaurants_system/features/profile/presentation/screens/about_us_screen.dart';
import 'package:restaurants_system/features/profile/presentation/screens/change_password_page.dart';
import 'package:restaurants_system/features/profile/presentation/screens/help_center_screen.dart';
import 'package:restaurants_system/features/profile/presentation/screens/manage_profile_page.dart';
import 'package:restaurants_system/features/profile/presentation/utils/settings_item_data.dart';
import 'package:restaurants_system/features/profile/presentation/widgets/profile_appbar.dart';
import 'package:restaurants_system/features/profile/presentation/widgets/section_title.dart';
import 'package:restaurants_system/features/profile/presentation/widgets/settings_group.dart';
import 'package:restaurants_system/features/profile/presentation/widgets/user_info_data.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});
  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      ref.read(profileProvider.notifier).refreshProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Padding(
          padding:const  EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const ProfileAppBar(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 8),
                    UserInfoCard(
                      name: profileState.profile?.name ?? '',
                      email: profileState.profile?.email ?? '',
                      imageUrl: '',
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'Account'),
                    const SizedBox(height: 8),
                    SettingsGroup(
                      items: [
                        SettingsItemData(
                          icon: Icons.person_outline,
                          label: 'Manage Profile',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const  ManageProfilePage(),
                              ),
                            );
                          },
                        ),
                        SettingsItemData(
                          icon: Icons.lock_outline,
                          label: 'Password & Security',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>const  ChangePasswordPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'Preferences'),
                    const SizedBox(height: 8),
                    SettingsGroup(
                      items: [
                        SettingsItemData(
                          icon: Icons.info_outline,
                          label: 'About Us',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AboutUsPage()),
                            );
                          },
                        ),
                        const SettingsItemData(
                          icon: Icons.brightness_6_outlined,
                          label: 'Theme',
                          trailingText: 'Light',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const SectionTitle(title: 'Support'),
                    const SizedBox(height: 8),
                    SettingsGroup(
                      items: [
                        SettingsItemData(
                          icon: Icons.help_outline,
                          label: 'Help Center',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>const  HelpCenterPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
