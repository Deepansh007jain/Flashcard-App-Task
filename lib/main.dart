// lib/main.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'models/flashcard.dart';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const FlashcardScreen(),
    );
  }
}

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final List<Flashcard> _flashcards = [];
  final _uuid = const Uuid();

  void _addFlashcard(String question, String answer) {
    setState(() {
      _flashcards.add(
        Flashcard(id: _uuid.v4(), question: question, answer: answer),
      );
    });
  }

  void _editFlashcard(String id, String question, String answer) {
    setState(() {
      final index = _flashcards.indexWhere((card) => card.id == id);
      if (index != -1) {
        _flashcards[index] = Flashcard(
          id: id,
          question: question,
          answer: answer,
        );
      }
    });
  }

  void _deleteFlashcard(String id) {
    setState(() {
      _flashcards.removeWhere((card) => card.id == id);
    });
  }

  void _toggleAnswer(String id) {
    setState(() {
      final index = _flashcards.indexWhere((card) => card.id == id);
      if (index != -1) {
        _flashcards[index].isAnswerVisible =
            !_flashcards[index].isAnswerVisible;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body:
          _flashcards.isEmpty
              ? const Center(child: Text('No flashcards yet. Add some!'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _flashcards.length,
                itemBuilder: (context, index) {
                  final card = _flashcards[index];
                  return FlashcardWidget(
                    flashcard: card,
                    onToggle: () => _toggleAnswer(card.id),
                    onEdit: () => _showEditDialog(card),
                    onDelete: () => _showDeleteDialog(card),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog() async {
    final questionController = TextEditingController();
    final answerController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Flashcard'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: questionController,
                    decoration: const InputDecoration(labelText: 'Question'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a question';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: answerController,
                    decoration: const InputDecoration(labelText: 'Answer'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an answer';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _addFlashcard(
                      questionController.text,
                      answerController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  Future<void> _showEditDialog(Flashcard card) async {
    final questionController = TextEditingController(text: card.question);
    final answerController = TextEditingController(text: card.answer);
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Flashcard'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: questionController,
                    decoration: const InputDecoration(labelText: 'Question'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a question';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: answerController,
                    decoration: const InputDecoration(labelText: 'Answer'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an answer';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _editFlashcard(
                      card.id,
                      questionController.text,
                      answerController.text,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  Future<void> _showDeleteDialog(Flashcard card) async {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Flashcard'),
            content: const Text(
              'Are you sure you want to delete this flashcard?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _deleteFlashcard(card.id);
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

class FlashcardWidget extends StatelessWidget {
  final Flashcard flashcard;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FlashcardWidget({
    super.key,
    required this.flashcard,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                flashcard.question,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (flashcard.isAnswerVisible) ...[
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  flashcard.answer,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
