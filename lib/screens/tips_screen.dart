import 'package:flutter/material.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  String _selectedCategory = "Normal BP"; // Default category

  final Map<String, List<String>> _tips = {
    "Low BP": [
      "🧂 Increase salt intake (consult doctor first).",
      "💧 Drink more water to prevent dehydration.",
      "🚫 Avoid alcohol as it lowers blood pressure.",
      "🍴 Eat small, frequent meals to prevent sudden drops."
    ],
    "Normal BP": [
      "🥗 Maintain a balanced diet with fruits and vegetables.",
      "🏃‍♂️ Exercise regularly to keep BP stable.",
      "🧘‍♂️ Reduce stress through meditation or deep breathing.",
      "🧂 Limit sodium intake to prevent future issues."
    ],
    "High BP": [
      "🧂 Reduce salt intake in your diet.",
      "🏃‍♀️ Exercise regularly, at least 30 minutes daily.",
      "🥦 Avoid processed foods and excess sugar.",
      "🩺 Monitor BP regularly and take prescribed medication."
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Tips"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Category:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                underline: SizedBox(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: _tips.keys.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tips[_selectedCategory]!.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.lightBlue.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _tips[_selectedCategory]![index],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
