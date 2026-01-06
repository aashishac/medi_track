import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/features/home/presentation/widgets/custom_hero_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Row(
          crossAxisAlignment: .start,
          children: [
            // SizedBox(height: 15),
            Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Text('Good Morning,'),
                    Text(
                      '  Dr. Alex',
                      style: TextStyle(color: AppColors.infoBlue),
                    ),
                  ],
                ),
                Text(
                  'Wesenday , Oct 24',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            Stack(
              children: [
                SizedBox(
                  height: 42,
                  width: 42,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profileimg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  right: 1,
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: AppColors.successGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(children: [SizedBox(height: 15), costumCard()]),
    );
  }
}
