import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/car_provider.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/floating_nav.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fsjnypyhwxmoqczohrsl.supabase.co',
    anonKey: 'sb_publishable_cfmBT6DkfdEpjIUtO5fC4Q_X8-PF9Ae',
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const CarCatApp());
}

class CarCatApp extends StatelessWidget {
  const CarCatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CarProvider()..init(),
      child: MaterialApp(
        title: 'CarCat - Katalog Mobil Indonesia',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const MainShell(),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _screens = [
    HomeScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: FloatingNav(
        currentIndex: _currentIndex,
        onChanged: (i) => setState(() => _currentIndex = i),
        items: const [
          FloatingNavItem(
            icon: Icons.grid_view_rounded,
            activeIcon: Icons.grid_view_rounded,
            label: 'Katalog',
          ),
          FloatingNavItem(
            icon: Icons.favorite_border_rounded,
            activeIcon: Icons.favorite_rounded,
            label: 'Favorit',
          ),
        ],
      ),
    );
  }
}
