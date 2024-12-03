import 'package:flutter/material.dart';
import 'quiz_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  SetupScreenState createState() => SetupScreenState();
}

class SetupScreenState extends State<SetupScreen> {
  List categories = [];
  String selectedCategory = '9'; // Default category: General Knowledge
  String selectedDifficulty = 'easy';
  String selectedType = 'multiple';
  int selectedQuestions = 5;
  bool isLoading = true; // To show a loader while fetching categories

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response =
          await http.get(Uri.parse('https://opentdb.com/api_category.php'));
      if (response.statusCode == 200) {
        setState(() {
          categories = json.decode(response.body)['trivia_categories'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showError('Failed to load categories.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('An error occurred: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void startQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          numberOfQuestions: selectedQuestions,
          category: selectedCategory,
          difficulty: selectedDifficulty,
          type: selectedType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Number of Questions:'),
            DropdownButton<int>(
              value: selectedQuestions,
              items: [5, 10, 15].map((value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedQuestions = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Select Category:'),
            DropdownButton<String>(
              value: selectedCategory,
              items: categories.isNotEmpty
                  ? categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['id'].toString(),
                        child: Text(category['name']),
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem(
                        value: '9',
                        child: Text('General Knowledge'),
                      )
                    ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Select Difficulty:'),
            DropdownButton<String>(
              value: selectedDifficulty,
              items: ['easy', 'medium', 'hard'].map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDifficulty = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Select Type:'),
            DropdownButton<String>(
              value: selectedType,
              items: ['multiple', 'boolean'].map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                      value == 'multiple' ? 'Multiple Choice' : 'True/False'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: startQuiz,
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

