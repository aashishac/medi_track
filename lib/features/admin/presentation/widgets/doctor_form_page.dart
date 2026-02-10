import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorFormPage extends StatefulWidget {
  final String? doctorId;
  final Map<String, dynamic>? existingData;

  const DoctorFormPage({super.key, this.doctorId, this.existingData});

  @override
  State<DoctorFormPage> createState() => _DoctorFormPageState();
}

class _DoctorFormPageState extends State<DoctorFormPage> {
  final nameCtrl = TextEditingController();
  final deptCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // ✅ EDIT MODE: prefill data
    if (widget.existingData != null) {
      nameCtrl.text = widget.existingData!['doctorname'] ?? '';
      deptCtrl.text = widget.existingData!['department'] ?? '';
      phoneCtrl.text = widget.existingData!['phone'] ?? '';
      emailCtrl.text = widget.existingData!['email'] ?? '';
    }
  }

  Future<void> saveDoctor() async {
    final ref = FirebaseFirestore.instance.collection('doctors');

    if (widget.doctorId == null) {
      // ADD
      final docRef = await ref.add({
        'doctorname': nameCtrl.text.trim(),
        'department': deptCtrl.text.trim(),
        'phone': phoneCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
      });

      // save doctorId inside document (optional but useful)
      await docRef.update({'doctorId': docRef.id});
    } else {
      // ✏️ UPDATE
      await ref.doc(widget.doctorId).update({
        'doctorname': nameCtrl.text.trim(),
        'department': deptCtrl.text.trim(),
        'phone': phoneCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
      });
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.doctorId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Doctor' : 'Add Doctor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Doctor Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: deptCtrl,
              decoration: const InputDecoration(labelText: 'Department'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveDoctor,
              child: Text(isEdit ? 'Update Doctor' : 'Add Doctor'),
            ),
          ],
        ),
      ),
    );
  }
}
