import 'package:flutter/material.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _habitController = TextEditingController();
  Color selectedColor = Colors.amber; // Default color
  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};
  final Map<String, Color> _habitColors = {
    'Amber': Colors.amber,
    'Red Accent': Colors.redAccent,
    'Light Blue': Colors.lightBlue,
    'Light Green': Colors.lightGreen,
    'Purple Accent': Colors.purpleAccent,
    'Orange': Colors.orange,
    'Teal': Colors.teal,
    'Deep Purple': Colors.deepPurple,
  };
  String selectedColorName = 'Amber'; // Default color name

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    setState(() {
      // Hardcoded habits for demonstration
      selectedHabitsMap = {
        'Workout': 'FF5733', // Color in hex
        'Meditate': 'FF33A1',
        'Read a Book': '33FFA1',
        'Drink Water': '3380FF',
        'Practice Gratitude': 'FFC300'
      };
      completedHabitsMap = {
        'Wake Up Early': 'FF5733',
        'Journal': 'DAF7A6'
      };
    });
  }

  Future<void> _saveHabits() async {
    // This function intentionally left empty as no saving is needed
  }

  void _editHabit(String oldHabitName, String currentColorHex) {
    TextEditingController editController =
        TextEditingController(text: oldHabitName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Habit'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              labelText: 'Habit Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cancel edit
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newHabitName = editController.text.trim();
                if (newHabitName.isNotEmpty) {
                  setState(() {
                    // Update in selectedHabitsMap if exists, else in completedHabitsMap
                    if (selectedHabitsMap.containsKey(oldHabitName)) {
                      selectedHabitsMap.remove(oldHabitName);
                      selectedHabitsMap[newHabitName] = currentColorHex;
                    } else if (completedHabitsMap.containsKey(oldHabitName)) {
                      completedHabitsMap.remove(oldHabitName);
                      completedHabitsMap[newHabitName] = currentColorHex;
                    }
                  });
                  Navigator.pop(context); // Close dialog
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add opacity if not included.
    }
    return Color(int.parse('0x$hexColor'));
  }

  @override
  Widget build(BuildContext context) {
    // Combine both maps for display, ensuring no duplicates
    Map<String, String> allHabitsMap = {...selectedHabitsMap, ...completedHabitsMap};

    return Scaffold(
      // Top bar is now blue
      appBar: AppBar(
        backgroundColor: Colors.blue, // You can use Colors.blue.shade700 if desired
        title: const Text(
          'Configure Habits',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      // Body background is now white
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input field for habit name with enhanced styling
            TextField(
              controller: _habitController,
              decoration: InputDecoration(
                labelText: 'Habit Name',
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Color:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, // This was in your original code
              ),
            ),
            const SizedBox(height: 10),
            // Dropdown to choose a habit color
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
                color: Colors.white.withOpacity(0.2),
              ),
              child: DropdownButton<String>(
                value: selectedColorName,
                isExpanded: true,
                dropdownColor: Colors.blue.shade700, // Or keep deepPurple.shade700
                underline: const SizedBox(),
                items: _habitColors.keys.map((String colorName) {
                  return DropdownMenuItem<String>(
                    value: colorName,
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _habitColors[colorName],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        colorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedColorName = newValue!;
                    selectedColor = _habitColors[selectedColorName]!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            // Button to add a new habit
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_habitController.text.isNotEmpty) {
                    setState(() {
                      selectedHabitsMap[_habitController.text] =
                          selectedColor.value.toRadixString(16).toUpperCase();
                      _habitController.clear();
                      selectedColorName = 'Amber'; // Reset to default
                      selectedColor = _habitColors[selectedColorName]!;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Add Habit',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Habits:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // This was in your original code
              ),
            ),
            const SizedBox(height: 10),
            // Display all habits in a styled list with edit and delete actions
            Expanded(
              child: ListView(
                children: allHabitsMap.entries.map((entry) {
                  final habitName = entry.key;
                  final habitColor = _getColorFromHex(entry.value);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: habitColor,
                      ),
                      title: Text(
                        habitName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _editHabit(habitName, entry.value);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                selectedHabitsMap.remove(habitName);
                                completedHabitsMap.remove(habitName);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
