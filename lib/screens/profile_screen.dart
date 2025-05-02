import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final medicalHistoryController = TextEditingController();
  final bpProblemsController = TextEditingController();
  final emergencyContactController = TextEditingController();
  final doctorNameController = TextEditingController();
  final doctorClinicController = TextEditingController();
  final doctorContactController = TextEditingController();
  final medicineInputController = TextEditingController();

  List<String> medicines = [];
  String selectedPatientType = "Normal";

  final patientTypes = [
    "Normal",
    "Athlete / Sports Person",
    "Low BP Patient",
    "High BP Patient",
    "Other"
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), centerTitle: true),
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
                  return DropdownMenuItem(value: type, child: Text(type));
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
              onPressed: _saveProfile,
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

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", nameController.text);
    await prefs.setString("age", ageController.text);
    await prefs.setString("medicalHistory", medicalHistoryController.text);
    await prefs.setString("bpProblems", bpProblemsController.text);
    await prefs.setString("emergencyContact", emergencyContactController.text);
    await prefs.setString("doctorName", doctorNameController.text);
    await prefs.setString("doctorClinic", doctorClinicController.text);
    await prefs.setString("doctorContact", doctorContactController.text);
    await prefs.setString("patientType", selectedPatientType);
    await prefs.setStringList("medicines", medicines);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Profile Saved"),
        content: Text("Your profile information has been saved locally."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString("name") ?? '';
      ageController.text = prefs.getString("age") ?? '';
      medicalHistoryController.text = prefs.getString("medicalHistory") ?? '';
      bpProblemsController.text = prefs.getString("bpProblems") ?? '';
      emergencyContactController.text = prefs.getString("emergencyContact") ?? '';
      doctorNameController.text = prefs.getString("doctorName") ?? '';
      doctorClinicController.text = prefs.getString("doctorClinic") ?? '';
      doctorContactController.text = prefs.getString("doctorContact") ?? '';
      selectedPatientType = prefs.getString("patientType") ?? "Normal";
      medicines = prefs.getStringList("medicines") ?? [];
    });
  }
}
