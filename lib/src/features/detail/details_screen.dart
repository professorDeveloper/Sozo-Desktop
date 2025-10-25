import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sozodesktop/src/core/constants/app_color.dart';
import 'package:sozodesktop/src/features/detail/about_screen.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 800,
                floating: false,
                automaticallyImplyLeading: false, // remove default back button
                pinned: true,
                backgroundColor: AppColors.backgroundColor,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final bool collapsed =
                        constraints.biggest.height <= kToolbarHeight + 40;
                    return FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding:  EdgeInsets.symmetric(horizontal: 18, vertical:collapsed?15:0),
                      title: collapsed
                          ? Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 18,
                                ),

                                SizedBox(width: 8,),
                                Text(
                                  "Joker",
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : null,
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/joker.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 300,
                            // adjust height of gradient section
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xD0F11), // transparent top
                                    Color(0xb50e0f13), // dark base
                                    AppColors.backgroundColor, // solid end
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 44),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 25,
                                  ),
                                  decoration: ShapeDecoration(
                                    color: Colors.white.withValues(alpha: 0.10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      Text(
                                        'Back',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 200),
                                Text(
                                  "Joker",
                                  style: GoogleFonts.aleo(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 10,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        '2024',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 10,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'AQSH',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 10,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Triller/Kriminal',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 10,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        '+18',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 25),
                                SizedBox(
                                  width: 743,
                                  child: Text(
                                    "Joker filmining davomi (2019). Film nomiga kiritilgan folie à deux atamasi psixiatrik sindromni bildiradi, unda ikki shaxsda bir xil mazmundagi delusional g'oyalar kuzatiladi. Film Arkham boshpanasida bo'lib o'tadi, u erda Xarli Joker laqabini olgan jinoyatchi Artur Flek bilan uchrashadi.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                          color: Color(
                                            0xFF000000,
                                          ).withOpacity(0.25),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 33),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.35 >
                                                240
                                            ? 230
                                            : MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.35 <
                                                  150
                                            ? 150
                                            : MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.35,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 44,
                                              vertical: 22,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            elevation: 8,
                                            shadowColor: Colors.black
                                                .withOpacity(0.3),
                                          ),
                                          onPressed: () {},
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Watch Now",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              SvgPicture.asset(
                                                'assets/icons/play.svg',
                                                height: 25,
                                                width: 25,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Flexible(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.35 >
                                                240
                                            ? 230
                                            : MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.35 <
                                                  150
                                            ? 150
                                            : MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.35,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white
                                                .withOpacity(0.10),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 44,
                                              vertical: 24,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            elevation: 8,
                                            shadowColor: Colors.black
                                                .withOpacity(0.3),
                                          ),
                                          onPressed: () {},
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Treyler",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              SvgPicture.asset(
                                                'assets/icons/treyler.svg',
                                                height: 25,
                                                width: 25,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SliverPersistentHeader(
                pinned: true,

                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,

                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.white,
                    labelStyle: GoogleFonts.rubik(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: GoogleFonts.rubik(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),

                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    tabs: [
                      Tab(text: 'Film haqida'),
                      Tab(text: 'Prodyuser va akterlar'),
                      Tab(text: 'Izohlar'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              AboutScreen(),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Prodyuser va akterlar content goes here...',
                    style: GoogleFonts.rubik(color: Colors.white),
                  ),
                ),
              ),
              // Placeholder for Izohlar content
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Izohlar content goes here...',
                    style: GoogleFonts.rubik(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppColors.backgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
