import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final response = await http.get(Uri.parse('http://13.60.63.216/food_history'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _history = List<Map<String, dynamic>>.from(data.map((item) => Map<String, dynamic>.from(item)));
        _isLoading = false;
      });
    } else {
      // Handle error
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food History'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final historyItem = _history[index];
                return ListTile(
                  leading: Text('${index + 1}.'),
                  title: Text(historyItem['description'] ?? 'No description'),
                  subtitle: Text('Date: ${historyItem['date'] ?? 'N/A'}'),
                );
              },
            ),
    );
  }
}
