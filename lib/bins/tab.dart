import "dart:convert";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:http/http.dart" as http;
import "package:provider/provider.dart";
import "../settings/provider.dart";
import "../utils.dart";

class BinsTab extends StatefulWidget {
  const BinsTab({super.key});

  @override
  _BinsTabState createState() => _BinsTabState();
}

class _BinsTabState extends State<BinsTab> {
  static final DateFormat formatter = DateFormat("yyyy-MM-dd");

  String? nextBinDate;
  List<String> binTypes = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final provider = Provider.of<SettingsProvider>(context);
    _loadBinData(provider.dataUrl);
  }

  Future<void> _loadBinData(Uri url) async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> binData = json.decode(response.body);

        final today = DateTime.now();
        for (int i = 0; i < 30; i++) {
          final nextDate = today.add(Duration(days: i));
          final nextDateStr = formatter.format(nextDate);
          if (binData.containsKey(nextDateStr)) {
            setState(() {
              nextBinDate = nextDateStr;
              binTypes = List<String>.from(binData[nextDateStr]);
              isLoading = false;
            });
            return;
          }
        }
      } else {
        print("Error fetching BinData: ${response.statusCode}");
      }
    } catch (err) {
      print("Network error: $err");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SettingsProvider>(context);
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (nextBinDate == null || binTypes.isEmpty) {
      return const Center(
        child: Text(
          "Unable to find next Bin Date",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    final today = DateTime.now();
    final tomorrow = today.add(Duration(days: 1));
    String localized = "";
    if (nextBinDate == formatter.format(today)) {
      localized = "Today";
    } else if (nextBinDate == formatter.format(tomorrow)) {
      localized = "Tomorrow";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${capitalize(provider.dataUrl.toString().split('/').last.split('.').first)} Bins",
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatDate(nextBinDate),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            localized,
            style: TextStyle(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          ...binTypes.map((type) => _buildBinCard(type)).toList(),
        ],
      ),
    );
  }

  Widget _buildBinCard(String type) {
    Color cardColour;
    switch (type.toLowerCase()) {
      case "rubbish":
        cardColour = Colors.red.shade100;
        break;
      case "recycling":
        cardColour = Colors.yellow.shade100;
        break;
      case "glass":
        cardColour = Colors.blue.shade100;
        break;
      default:
        cardColour = Colors.transparent;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColour,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              capitalize(type),
              style: const TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
