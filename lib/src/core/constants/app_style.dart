import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';

class AppStyle {
  AppStyle._();

  static TextStyle rubik20MediumWHite = GoogleFonts.rubik(
    fontSize: 20,
    color: AppColors.White,
  );
  static TextStyle rubik16White = GoogleFonts.rubik(
      fontSize: 16, color: AppColors.White);
  static TextStyle rubik16Gray2 = GoogleFonts.rubik(
    color: AppColors.Gray2,
    fontSize: 16,
  );
  static TextStyle rubik15Black = GoogleFonts.rubik(
      fontSize: 15, color: AppColors.black);

  static TextStyle rubik15White = GoogleFonts.rubik(
      fontSize: 15, color: AppColors.White);
  static TextStyle rubik14Gray2 =
      GoogleFonts.rubik(color: AppColors.Gray2, fontSize: 14);
  static TextStyle rubik14White =
      GoogleFonts.rubik(color: Colors.white, fontSize: 14);
  static TextStyle rubik14WhiteBold = GoogleFonts.rubik(
      color: AppColors.White, fontWeight: FontWeight.w900, fontSize: 14);
  static TextStyle rubik13White =
  GoogleFonts.rubik(color: Colors.white, fontSize: 13);

  static TextStyle rubik13Gray2 =
      GoogleFonts.rubik(fontSize: 13, color: AppColors.Gray2);
  static TextStyle rubik12Gray2 =
      GoogleFonts.rubik(fontSize: 12, color: AppColors.Gray2);
  static TextStyle rubik12White =
      GoogleFonts.rubik(fontSize: 12, color: AppColors.White);
  static TextStyle rubik11White =
  GoogleFonts.rubik(fontSize: 11, color: AppColors.White);
  static TextStyle rubik11Gray1 =
  GoogleFonts.rubik(fontSize: 11, color: AppColors.Gray2);

  static TextStyle rubik12Red =
  GoogleFonts.rubik(fontSize: 12, color: AppColors.Red);
  static TextStyle daysOne25White =
  GoogleFonts.daysOne(fontSize: 25, color: Colors.white);
  static TextStyle daysOne24White =
  GoogleFonts.daysOne(fontSize: 24, color: Colors.white);
  static TextStyle daysOne22White =
  GoogleFonts.daysOne(fontSize: 22, color: Colors.white);

  static TextStyle daysOne20White =
      GoogleFonts.daysOne(fontSize: 20, color: Colors.white);
  static TextStyle daysOne18White =
  GoogleFonts.daysOne(fontSize: 18, color: Colors.white);
  static TextStyle dayOne16White =
  GoogleFonts.daysOne(fontSize: 16, color: Colors.white);

  static TextStyle dayOne15White =
      GoogleFonts.daysOne(fontSize: 15, color: Colors.white);
  static TextStyle dayOne14White = GoogleFonts.daysOne(
    color: Colors.white,
    fontSize: 14,
  );
  static TextStyle dayOne12White = GoogleFonts.rubik(
    color: Colors.white,
    fontWeight: FontWeight.w700,
    fontSize: 13,
  );

  static TextStyle dayOne12Red = GoogleFonts.rubik(
    color: AppColors.Red2,
    fontSize: 12,
  );

  static TextStyle styleRed4Sp20W600Zen = GoogleFonts.zenMaruGothic(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.Red2,
    height: 1.2,
    letterSpacing: 0.3,
  );

  static TextStyle styleRed4Sp16W900Zen = GoogleFonts.zenMaruGothic(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: AppColors.Red2,
    height: 1.2,
    letterSpacing: 0.3,
  );
  static TextStyle styleGreen4Sp16W900Zen = GoogleFonts.zenMaruGothic(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: Colors.green,
    height: 1.2,
    letterSpacing: 0.3,
  );

}
