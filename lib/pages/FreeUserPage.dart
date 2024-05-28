import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FreeUserPage extends StatefulWidget {
  const FreeUserPage({super.key});

  @override
  _FreeUserPageState createState() => _FreeUserPageState();
}

class _FreeUserPageState extends State<FreeUserPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  String _error = '';

  Future<void> _sendMessage() async {
    final message = _controller.text;
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"user": message});
      _controller.clear();
      _isLoading = true;
      _error = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://13.60.63.216/recipe_free_version'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'description': message}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          _messages.add({"bot": responseBody['message']});
        });
      } else {
        setState(() {
          _error = 'Failed to load recipe: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Free User Recipes'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              context.push('/food_history');
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[100]!, Colors.teal[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome to the Free User Page',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message.containsKey('user');
                  return Container(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.values.first,
                          style: TextStyle(color: isUser ? Colors.blue[800] : Colors.green[800]),
                        ),
                        SizedBox(height: 5),
                        Text(
                          isUser ? "You" : "Bot",
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_isLoading) CircularProgressIndicator(),
            if (_error.isNotEmpty) Text(_error, style: TextStyle(color: Colors.red)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Enter your request here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.teal),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
