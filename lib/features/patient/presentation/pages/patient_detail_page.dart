import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/core/responsive/responsive_helper.dart';
import 'package:meditrack/features/home/models/patient.dart';

class RecordDetailsPage extends StatelessWidget {
  const RecordDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);

    Patient? patient;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Details'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.note_add_outlined),
      ),

      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 560 : double.infinity,
            ),
            child: SingleChildScrollView(
              padding: ResponsiveDimensions.paddingSymmetricAdaptive(
                context,
                mobileHorizontal: 16,
                tabletHorizontal: 24,
                mobileVertical: 16,
                tabletVertical: 24,
              ),
              child: Column(
                spacing: context.sp16,
                children: [
                  _ProfileHeader(patient: patient!, context),
                  _ActionButtons(context),
                  _PersonalDetailsCard(context),
                  _HistorySummary(context),
                  _ClinicalNotes(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader(BuildContext context, {required this.patient});
  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.sp8,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: context.sp48,
              backgroundImage: const NetworkImage('https://i.pravatar.cc/300'),
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.green,
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
          ],
        ),

        Text(patient.name, style: AppTextStyle.bodySemiBold(context)),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: context.sp8,
          children: [
            Text('#MR-4092', style: TextStyle(color: Colors.blue)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.sp12,
                vertical: context.sp4,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Active Treatment',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons(this.context);
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: context.sp12,
      children: const [
        _ActionCard(icon: Icons.edit, label: 'Edit'),
        _ActionCard(icon: Icons.archive_outlined, label: 'Archive'),
        _ActionCard(icon: Icons.share_outlined, label: 'Export'),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(context.sp16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(.05)),
            ],
          ),
          child: Column(
            spacing: context.sp8,
            children: [Icon(icon), Text(label)],
          ),
        ),
      ),
    );
  }
}

class _PersonalDetailsCard extends StatelessWidget {
  const _PersonalDetailsCard(this.context);
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Personal Details',
      child: Column(
        spacing: context.sp12,
        children: [
          _InfoRow(label: 'Date of Birth', value: 'Jan 12, 1985'),
          _InfoRow(label: 'Gender', value: 'Female'),
          _InfoRow(label: 'Phone Number', value: '+1 (555) 012-3456'),
          _InfoRow(label: 'Policy Holder', value: 'BlueCross'),
          _InfoRow(label: 'Member ID', value: 'BC-99887766'),
        ],
      ),
    );
  }
}

class _HistorySummary extends StatelessWidget {
  const _HistorySummary(this.context);
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'History Summary',
      trailing: TextButton(onPressed: () {}, child: const Text('View All')),
      child: Column(
        spacing: context.sp12,
        children: const [
          _HistoryItem(
            title: 'Routine Checkup',
            subtitle: 'Dr. Emily Stone · General Practice',
            date: 'Oct 24',
          ),
          _HistoryItem(
            title: 'Lab Results',
            subtitle: 'Blood Work Panel · Complete',
            date: 'Aug 10',
          ),
        ],
      ),
    );
  }
}

class _ClinicalNotes extends StatelessWidget {
  const _ClinicalNotes(this.context);
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Clinical Notes',
      subtitle: 'Last updated today',
      backgroundColor: Colors.yellow.withOpacity(.15),
      child: const Text(
        'Patient reports mild improvements in sleep patterns '
        'since starting the new medication. Continued dosage '
        'recommended for another 2 weeks before reassessment.',
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;
  final Color? backgroundColor;

  const _SectionCard({
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.sp16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(.05)),
        ],
      ),
      child: Column(
        spacing: context.sp12,
        children: [
          Row(
            children: [
              Text(title),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          if (subtitle != null)
            Align(alignment: Alignment.centerLeft, child: Text(subtitle!)),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Text(value, textAlign: TextAlign.right)),
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;

  const _HistoryItem({
    required this.title,
    required this.subtitle,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.medical_services_outlined,
          size: context.sp20,
          color: Colors.blue,
        ),

        SizedBox(width: context.sp12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              SizedBox(height: context.sp4),
              Text(subtitle, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),

        Text(date, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
