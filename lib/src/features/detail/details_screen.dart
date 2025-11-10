import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sozodesktop/src/core/constants/app_color.dart';
import 'package:sozodesktop/src/core/model/responses/media.dart';
import 'package:sozodesktop/src/features/detail/about_screen.dart';
import 'package:sozodesktop/src/features/detail/characters_screen.dart';
import 'package:sozodesktop/src/features/detail/bloc/detail_bloc.dart';
import 'package:sozodesktop/src/features/detail/episodes/episodes_screen.dart';
import 'package:sozodesktop/src/features/detail/model/relations_model.dart';
import 'package:sozodesktop/src/features/home/model/home_anime_model.dart';
import '../extrawidgets/kenbursview.dart';
import 'bloc/character_bloc.dart';
import 'episodes/bloc/episodes_bloc.dart';

class DetailsScreen extends StatefulWidget {
  final int animeid;

  const DetailsScreen({super.key, required this.animeid});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<DetailBloc>();
      if (!bloc.isClosed) {
        bloc.add(FetchAnimeDetails(widget.animeid));
      }
    });
  }

  @override
  void dispose() {
    context.read<DetailBloc>().close(); // Faqat factory bo'lsa kerak

    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<DetailBloc, DetailState>(
        builder: (context, state) {
          if (state is AboutLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (state is AboutError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage,
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<DetailBloc>().add(
                          FetchAnimeDetails(widget.animeid),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Go Back',
                        style: GoogleFonts.rubik(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is AboutLoaded) {
            print(state.anime.title!.english.toString());
            print(state.anime.description.toString());
            print(state.anime.countryOfOrigin!.toString());
            return _buildContent(state.anime);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(Media anime) {
    print(anime.title!.english.toString());
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              expandedHeight: 800,
              collapsedHeight: 80,
              floating: false,
              automaticallyImplyLeading: false,
              pinned: true,
              backgroundColor: AppColors.backgroundColor,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool collapsed = constraints.biggest.height <= 100;
                  return FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: EdgeInsets.only(
                      left: collapsed ? 18 : 0,
                      bottom: collapsed ? 20 : 0,
                    ),
                    title: collapsed
                        ? Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  anime.title?.english ?? 'No Title',
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        : null,
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      children: [
                        KenBurnsView(
                          image: NetworkImage(
                            anime.bannerImage ?? anime.coverImage?.large ?? "",
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xD0F11),
                                  const Color(0xb50e0f13),
                                  AppColors.backgroundColor,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 40),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 25,
                                  ),
                                  decoration: ShapeDecoration(
                                    color: Colors.white.withValues(alpha: 0.10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: const Row(
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
                              ),
                              Spacer(),
                              Text(
                                anime.title?.english ?? 'No Title',
                                style: GoogleFonts.aleo(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 25),
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
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: Text(
                                      anime.seasonYear?.toString() ?? 'N/A',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Flexible(
                                    child: Container(
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
                                        anime.countryOfOrigin.toString() +
                                            ' Country',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(
                                  anime.description.toString(),
                                  maxLines: 7,
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 44,
                                        vertical: 24,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 8,
                                      shadowColor: Colors.black.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider(
                                            create: (_) => EpisodeBloc(),
                                            // auto-search by title
                                            child: EpisodesScreen(anime: anime),
                                          ),
                                        ),
                                      );
                                    },
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
                                  const SizedBox(width: 15),
                                  Flexible(
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                                  0.35 >
                                              240
                                          ? 230
                                          : MediaQuery.of(context).size.width *
                                                    0.35 <
                                                150
                                          ? 150
                                          : MediaQuery.of(context).size.width *
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
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          elevation: 8,
                                          shadowColor: Colors.black.withOpacity(
                                            0.3,
                                          ),
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
                              const SizedBox(height: 25),
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
                  tabs: const [
                    Tab(text: 'Film haqida'),
                    Tab(text: 'Prodyuser va akterlar'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            AboutScreen(anime: anime),
            BlocProvider(
              create: (context) => CharactersBloc(),
              child: CharactersScreen(mediaId: anime.id!),
            ),
          ],
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
