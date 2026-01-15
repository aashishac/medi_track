import 'package:flutter/material.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/core/responsive/responsive_helper.dart';
import 'package:meditrack/features/home/data/quick_navigation_list.dart';
import 'package:meditrack/features/home/presentation/widgets/quick_action_card.dart';

class QuickGridList extends StatelessWidget {
  const QuickGridList({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gridConfig = ResponsiveGridConfig();
        final isTablet = ResponsiveHelper.isTablet(context);
        return SizedBox(
          height: ResponsiveDimensions.getResponsiveSize(context, size: 330),
          child: GridView.builder(
            itemCount: quickNavigationList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridConfig.getCrossAxisCount(context),
              crossAxisSpacing: gridConfig.getSpacing(context),
              mainAxisSpacing: gridConfig.getSpacing(context),
              childAspectRatio: isTablet ? 1.2 : 1.0,
            ),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                quickNavigationList[index].onTap(context);
              },
              child: QuickActionCard(quickAction: quickNavigationList[index]),
            ),
          ),
        );
      },
    );
  }
}
