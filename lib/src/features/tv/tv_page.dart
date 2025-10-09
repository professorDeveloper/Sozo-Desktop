import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sozodesktop/src/core/constants/app_color.dart';

import '../../core/constants/app_images.dart';
import '../../core/constants/app_style.dart';
import '../../core/model/forui/Tv.dart';
import 'package:google_fonts/google_fonts.dart';


class TvScreen extends StatefulWidget {
  const TvScreen({super.key});

  @override
  State<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends State<TvScreen> {
  var currentIndex = 0;
  var tabs = [
    "USA",
    "China",
    "Japan",
    "Korea",
    "Russia",
    "UK",
    "France",
    "Germany",
    "Italy",
    "Spain",
    "India",
    "Canada",
    "Australia",
    "Brazil",
    "Mexico",
    "Argentina",
    "South Africa",
    "Egypt",
    "Turkey",
    "Saudi Arabia",
  ];
  var tvlist = [
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedOpacity(
              opacity:  1,
              duration: const Duration(milliseconds: 200),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'TV Channels',
                    style: GoogleFonts.daysOne(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              width: double.infinity,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          color: index == currentIndex
                              ? AppColors.Red
                              : Color(0x1AFFFFFF),
                          borderRadius: BorderRadius.circular(20)),
                      margin: index == 0
                          ? EdgeInsets.only(left: 12, right: 4)
                          : EdgeInsets.symmetric(horizontal: 5),
                      child: Center(
                          child: Text(
                            tabs[index],
                            style: AppStyle.rubik14White,
                          )),
                    ),
                  );
                },
                itemCount: tabs.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 9,
                ),
                itemBuilder: (context, index) {
                  return liveTvItem(tvlist[index].name,tvlist[index].iamgeurl);
                },
                itemCount: tvlist.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget liveTvItem(String name,String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      child: Column(
        children: [
          SizedBox(
            child: Card(
              elevation: 1,
              shadowColor: AppColors.black.withOpacity(1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            width: 70,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppStyle.rubik12White,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
