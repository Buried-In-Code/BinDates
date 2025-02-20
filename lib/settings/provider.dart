import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class DataConstants {
  static final List<Uri> dataUrls = [
    Uri.parse(
      "https://raw.githubusercontent.com/Buried-In-Code/BinData/main/output/Featherston.json",
    ),
    Uri.parse(
      "https://raw.githubusercontent.com/Buried-In-Code/BinData/main/output/Greytown.json",
    ),
    Uri.parse(
      "https://raw.githubusercontent.com/Buried-In-Code/BinData/main/output/Martinborough.json",
    ),
  ];
}

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Uri _dataUrl = DataConstants.dataUrls[0];
  ThemeMode get themeMode => _themeMode;
  Uri get dataUrl => _dataUrl;

  SettingsProvider() {
    _loadPreferences();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("themeMode", mode.index);
  }

  void setDataUrl(Uri dataUrl) async {
    _dataUrl = dataUrl;
    notifyListeners();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("dataUrl", DataConstants.dataUrls.indexOf(dataUrl));
  }

  Future<void> _loadPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    int? themeModeIndex = preferences.getInt("themeMode");
    if (themeModeIndex != null) {
      _themeMode = ThemeMode.values[themeModeIndex];
    }
    int? dataUrlIndex = preferences.getInt("dataUrl");
    if (dataUrlIndex != null &&
        dataUrlIndex >= 0 &&
        dataUrlIndex < DataConstants.dataUrls.length) {
      _dataUrl = DataConstants.dataUrls[dataUrlIndex];
    }

    notifyListeners();
  }
}
