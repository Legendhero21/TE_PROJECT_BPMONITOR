import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController medicalHistoryController = TextEditingController();
  final TextEditingController bpProblemsController = TextEditingController();
  final TextEditingController emergencyContactController = TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController doctorClinicController = TextEditingController();
  final TextEditingController doctorContactController = TextEditingController();

  List<String> medicines = [];

  final TextEditingController medicineInputController = TextEditingController();

  String selectedPatientType = "Normal";

  final List<String> patientTypes = [
    "Normal",
    "Athlete / Sports Person",
    "Low BP Patient",
    "High BP Patient",
    "Other"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Basic Information", style: _sectionTitleStyle()),
            _buildTextField(nameController, "Name"),
            _buildTextField(ageController, "Age", keyboardType: TextInputType.number),

            SizedBox(height: 20),
            Text("Medical History", style: _sectionTitleStyle()),
            _buildTextField(medicalHistoryController, "Any major illnesses, surgeries, etc."),

            SizedBox(height: 20),
            Text("Blood Pressure Related Problems", style: _sectionTitleStyle()),
            _buildTextField(bpProblemsController, "Symptoms like dizziness, swelling, etc."),

            SizedBox(height: 20),
            Text("Emergency Contact", style: _sectionTitleStyle()),
            _buildTextField(emergencyContactController, "Phone number"),

            SizedBox(height: 20),
            Text("Doctor Details", style: _sectionTitleStyle()),
            _buildTextField(doctorNameController, "Doctor's Name"),
            _buildTextField(doctorClinicController, "Clinic/Hospital Name"),
            _buildTextField(doctorContactController, "Doctor's Contact Number"),

            SizedBox(height: 20),
            Text("Patient Type", style: _sectionTitleStyle()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: DropdownButton<String>(
                value: selectedPatientType,
                isExpanded: true,
                underline: SizedBox(),
                onChanged: (newValue) {
                  setState(() {
                    selectedPatientType = newValue!;
                  });
                },
                items: patientTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 20),
            Text("Medicines Prescribed", style: _sectionTitleStyle()),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(medicineInputController, "Enter medicine name"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (medicineInputController.text.isNotEmpty) {
                      setState(() {
                        medicines.add(medicineInputController.text.trim());
                        medicineInputController.clear();
                      });
                    }
                  },
                  child: Icon(Icons.add),
                )
              ],
            ),

            SizedBox(height: 10),
            ...medicines.map((medicine) => ListTile(
              title: Text(medicine),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    medicines.remove(medicine);
                  });
                },
              ),
            )),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _saveProfile();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text("Save Profile"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  TextStyle _sectionTitleStyle() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  }

  void _saveProfile() {
    // Here you can later save the data locally (ObjectBox, SQLite, SharedPreferences)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Profile Saved"),
        content: Text("Your profile information has been saved successfully."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }
}
