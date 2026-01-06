import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';

Widget costumCard() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      color: Color(0xFFFDFDFE),
      child: SizedBox(
        height: 250,
        width: 390,
        child: Row(
          children: [
            Container(
              color: Color(0xFFEBF1FB),
              child: SizedBox(
                height: 55,
                width: 55,
                child: Icon(Icons.folder, color: AppColors.iconBackground),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
