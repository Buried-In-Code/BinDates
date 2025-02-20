import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "settings/provider.dart";
import "settings/tab.dart";
import "bins/tab.dart";

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: const BinDates(),
    ),
  );
}

class BinDates extends StatelessWidget {
  const BinDates({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: "Bin Dates",
      themeMode: provider.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    BinsTab(),
    SettingsTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.recycling), label: "Bins"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
