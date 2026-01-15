import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/core/responsive/responsive_helper.dart';
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    final isTablet = ResponsiveHelper.isTablet(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Patient Records'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveDimensions.paddingSymmetricAdaptive(
            context,
            mobileHorizontal: 16,
            tabletHorizontal: 48,
            mobileVertical: 16,
            tabletVertical: 24,
          ),
          child: Column(
            spacing: isTablet ? 24 : context.sp16,
            children: [
              /// 🔍 Search Field
              CustomTextField(
                controller: _searchController,
                onChanged: (value) {
                  context.read<PatientProvider>().search(value);
                },
                prefixIcon: const Icon(Icons.search),
                hintText: "Search patients, records, appointments..",
                fontSize: ResponsiveHelper.getResponsiveValue(
                  context: context,
                  mobile: 14,
                  tablet: 16,
                ),
                height: ResponsiveHelper.getResponsiveValue(
                  context: context,
                  mobile: 48,
                  tablet: 56,
                ),
              ),

              /// 🏷 Filter Chips
              const FilterChipList(),

              /// 📋 Patient List (Responsive)
              Expanded(
                child: Consumer<PatientProvider>(
                  builder: (context, provider, _) {
                    final patients = provider.patients;

                    if (patients.isEmpty) {
                      return Center(
                        child: Text(
                          'No patients data found.',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getResponsiveValue(
                              context: context,
                              mobile: 14,
                              tablet: 16,
                            ),
                          ),
                        ),
                      );
                    }

                    /// Use grid for tablets
                    if (isTablet) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: context.sp16,
                          crossAxisSpacing: context.sp16,
                          childAspectRatio: 3.5,
                        ),
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          return PatientCard(patient: patients[index]);
                        },
                      );
                    }

                    /// ListView for mobile
                    return ListView.separated(
                      padding: EdgeInsets.only(top: context.sp8),
                      itemCount: patients.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: context.sp12),
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
    );
  }
}
