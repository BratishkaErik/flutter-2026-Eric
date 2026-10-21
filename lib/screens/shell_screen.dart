import 'package:flutter/material.dart';

import '../data/seed_data.dart';
import '../models/app_item.dart';
import '../models/profile.dart';
import '../routes/routes.dart';
import '../widgets/app_drawer.dart';
import 'tabs/apps_list_tab.dart';
import 'tabs/favourites_tab.dart';
import 'tabs/profile_tab.dart';

class ShellScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const ShellScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _currentTabIndex = 0;
  List<AppItem> _apps = generateSeedApps();
  Profile _profile = const Profile.empty();

  void _handleTabChange(int index) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() {
      _currentTabIndex = index;
    });
  }

  void _updateApp(AppItem updatedApp) {
    setState(() {
      _apps = _apps.map((a) => a.id == updatedApp.id ? updatedApp : a).toList();
    });
  }

  void _deleteApp(String appId) {
    setState(() {
      _apps = _apps.where((a) => a.id != appId).toList();
    });
  }

  void _toggleFavourite(AppItem targetApp) {
    final toggled = targetApp.copyWith(isFavourite: !targetApp.isFavourite);
    setState(() {
      _apps = _apps.map((a) => a.id == targetApp.id ? toggled : a).toList();
    });
  }

  void _updateProfile(Profile newProfile) {
    setState(() {
      _profile = newProfile;
    });
  }

  void _resetData() {
    setState(() {
      _apps = generateSeedApps();
      _profile = const Profile.empty();
    });
  }

  void _openAppDetail(AppItem app) {
    Navigator.of(context).pushNamed(
      Routes.detail,
      arguments: DetailArguments(
        app: app,
        profile: _profile,
        onUpdateApp: _updateApp,
        onDeleteApp: _deleteApp,
        onSwitchToProfileTab: () => _handleTabChange(2),
      ),
    );
  }

  Future<void> _openNewAppForm() async {
    final createdApp = await Navigator.of(context)
        .pushNamed<AppItem>(Routes.form, arguments: const FormArguments());

    if (!mounted) return;
    if (createdApp != null) {
      setState(() {
        _apps = [createdApp, ..._apps];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String appBarTitle = switch (_currentTabIndex) {
      0 => 'ByteStore',
      1 => 'Wishlist',
      2 => 'Tester Profile',
      _ => 'ByteStore',
    };

    final List<Widget> tabs = [
      AppsListTab(
        apps: _apps,
        onOpenDetail: _openAppDetail,
        onToggleFavourite: _toggleFavourite,
        onOpenForm: _openNewAppForm,
      ),
      FavouritesTab(
        apps: _apps,
        onOpenDetail: _openAppDetail,
        onToggleFavourite: _toggleFavourite,
        onExploreApps: () => _handleTabChange(0),
      ),
      ProfileTab(
        profile: _profile,
        apps: _apps,
        onUpdateProfile: _updateProfile,
        themeMode: widget.themeMode,
        onThemeModeChanged: widget.onThemeModeChanged,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
      drawer: AppDrawer(
        profile: _profile,
        apps: _apps,
        onResetData: _resetData,
      ),
      body: IndexedStack(index: _currentTabIndex, children: tabs),
      floatingActionButton: _currentTabIndex == 0
          ? FloatingActionButton(
              onPressed: _openNewAppForm,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: _handleTabChange,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Store',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
