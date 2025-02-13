import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "provider.dart";
import "../utils.dart";

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            title: Text("Theme Mode"),
            trailing: DropdownButton<ThemeMode>(
              value: provider.themeMode,
              onChanged: (newMode) {
                if (newMode != null) {
                  provider.setThemeMode(newMode);
                }
              },
              items: ThemeMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(capitalize(mode.toString().split(".").last)),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text("Data Url"),
            trailing: DropdownButton<Uri>(
              value: provider.dataUrl,
              onChanged: (newDataUrl) {
                if (newDataUrl != null) {
                  provider.setDataUrl(newDataUrl);
                }
              },
              items: DataConstants.dataUrls.map((x) {
                return DropdownMenuItem(
                    value: x,
                    child: Text(capitalize(
                        x.toString().split("/").last.split(".").first)));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
