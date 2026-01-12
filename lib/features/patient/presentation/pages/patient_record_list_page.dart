import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/core/widgets/custom_text_field.dart';
import 'package:meditrack/features/patient/presentation/providers/patient_provider.dart';
import 'package:meditrack/features/patient/presentation/widgets/filter_chip_list.dart';
import 'package:meditrack/features/patient/presentation/widgets/patient_card.dart';
import 'package:provider/provider.dart';

class PatientRecordListPage extends StatefulWidget {
  const PatientRecordListPage({super.key});

  @override
  State<PatientRecordListPage> createState() => _PatientRecordListPageState();
}

class _PatientRecordListPageState extends State<PatientRecordListPage> {
  final TextEditingController _searchController = .new();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PatientProvider>().init(
        FirebaseAuth.instance.currentUser!.uid,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Records')),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveDimensions.paddingSymmetric(
            context,
            horizontal: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              spacing: context.sp20,
              children: [
                CustomTextField(
                  controller: _searchController,
                  onChanged: (value) {
                    context.read<PatientProvider>().search(value);
                  },
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search patients, records, appointments..",
                ),

                FilterChipList(),

                SizedBox(
                  height: ResponsiveDimensions.getResponsiveSize(
                    context,
                    size: 300,
                  ),
                  child: Consumer<PatientProvider>(
                    builder: (context, provider, child) {
                      final patients = provider.patients;
                      if (patients.isEmpty) {
                        return Center(child: Text('No patients data found.'));
                      }
                      return ListView.builder(
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          return PatientCard(patient: patients[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
