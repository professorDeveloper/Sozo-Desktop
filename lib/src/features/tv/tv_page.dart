import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_color.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_style.dart';
import '../../utils/itv_garden_manager.dart';
import '../tvmedia/live_channel_screen.dart';
import 'bloc/channel_bloc.dart';

class TvScreen extends StatefulWidget {
  const TvScreen({super.key});

  @override
  State<TvScreen> createState() => _TvScreenState();
}

class _TvScreenState extends State<TvScreen> {
  var currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  bool isCountryFilter = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<ChannelBloc>();
      bloc.add(const LoadCategories());
      bloc.add(const LoadCountries());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> getTabs(ChannelState state) {
    if (isCountryFilter) {
      return state.countries.map((country) => country.name).toList();
    } else {
      return state.categories.map((category) => category.name).toList();
    }
  }

  List<Channel> getFilteredChannels(ChannelState state) {
    var channels = state.channels;

    if (searchQuery.isNotEmpty) {
      channels = channels
          .where(
            (channel) =>
                channel.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    return channels;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChannelBloc, ChannelState>(
      listener: (context, state) {
        if (state.status == ChannelStatus.success && state.channels.isEmpty) {
          if (!isCountryFilter && state.categories.isNotEmpty) {
            context.read<ChannelBloc>().add(
              LoadChannelsForCategory(state.categories[0].key),
            );
          } else if (isCountryFilter && state.countries.isNotEmpty) {
            context.read<ChannelBloc>().add(
              LoadChannelsForCountry(state.countries[0].code),
            );
          }
        }
      },
      child: BlocBuilder<ChannelBloc, ChannelState>(
        builder: (context, state) {
          final tabs = getTabs(state);

          final filteredChannels = getFilteredChannels(state);
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Title and Search
                  Row(
                    children: [
                      Text(
                        'TV Channels',
                        style: GoogleFonts.daysOne(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      // Search Bar
                      Container(
                        width: 320,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0x15FFFFFF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0x20FFFFFF),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search channels...',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white.withOpacity(0.5),
                              size: 20,
                            ),
                            suffixIcon: searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.white.withOpacity(0.5),
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Filter Toggle and Country/Genre Tabs Row
                  Row(
                    children: [
                      // Filter Type Button
                      GestureDetector(
                        onTap: () {
                          _showFilterDialog();
                        },
                        child: Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0x30FFFFFF),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.tune_rounded,
                                color: Colors.white.withOpacity(0.9),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Filter',
                                style: AppStyle.rubik14White.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Current Filter Type Indicator
                      Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0x15FFFFFF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0x20FFFFFF),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCountryFilter ? Icons.public : Icons.category,
                              color: Colors.white.withOpacity(0.7),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isCountryFilter ? 'Country' : 'Genre',
                              style: AppStyle.rubik14White.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Tabs List
                      Expanded(
                        child: Container(
                          height: 42,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              final isSelected = index == currentIndex;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentIndex = index;
                                    if (isCountryFilter) {
                                      final country = state.countries[index];
                                      context.read<ChannelBloc>().add(
                                        LoadChannelsForCountry(country.code),
                                      );
                                    } else {
                                      final category = state.categories[index];
                                      context.read<ChannelBloc>().add(
                                        LoadChannelsForCategory(category.key),
                                      );
                                    }
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.Red
                                        : const Color(0x12FFFFFF),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.Red
                                          : const Color(0x15FFFFFF),
                                      width: 1,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: index == 0 ? 0 : 8,
                                    right: index == tabs.length - 1 ? 0 : 0,
                                  ),
                                  child: Center(
                                    child: Text(
                                      tabs[index],
                                      style: AppStyle.rubik14White.copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: tabs.length,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Loading, Error, or Results
                  if (state.status == ChannelStatus.loading)
                    const Center(child: CircularProgressIndicator())
                  else if (state.status == ChannelStatus.failure)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.errorMessage ?? 'Failed to load channels',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ChannelBloc>().add(
                                const LoadCategories(),
                              );
                              context.read<ChannelBloc>().add(
                                const LoadCountries(),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    // Results Count
                    if (searchQuery.isNotEmpty || tabs.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Text(
                              '${filteredChannels.length} channels',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              height: 4,
                              width: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              tabs[currentIndex],
                              style: TextStyle(
                                color: AppColors.Red,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // TV Channels Grid
                    Expanded(
                      child: filteredChannels.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.tv_off,
                                    size: 64,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No channels found',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.only(bottom: 20),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 0.8,
                                  ),
                              itemBuilder: (context, index) {
                                return liveTvItem(filteredChannels[index]);
                              },
                              itemCount: filteredChannels.length,
                            ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0x30FFFFFF), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0x20FFFFFF),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.tune, color: AppColors.Red, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Filter Options',
                        style: GoogleFonts.daysOne(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.close,
                          color: Colors.white.withOpacity(0.6),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Filter Options
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filter by:',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Country Option
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isCountryFilter = true;
                            currentIndex = 0;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isCountryFilter
                                ? AppColors.Red.withOpacity(0.2)
                                : const Color(0x10FFFFFF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCountryFilter
                                  ? AppColors.Red
                                  : const Color(0x20FFFFFF),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isCountryFilter
                                      ? AppColors.Red
                                      : const Color(0x15FFFFFF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.public,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Country',
                                      style: AppStyle.rubik14White.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Filter channels by country',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isCountryFilter)
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.Red,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Genre Option
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isCountryFilter = false;
                            currentIndex = 0;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: !isCountryFilter
                                ? AppColors.Red.withOpacity(0.2)
                                : const Color(0x10FFFFFF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: !isCountryFilter
                                  ? AppColors.Red
                                  : const Color(0x20FFFFFF),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: !isCountryFilter
                                      ? AppColors.Red
                                      : const Color(0x15FFFFFF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.category,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Genre',
                                      style: AppStyle.rubik14White.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Filter channels by genre',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isCountryFilter)
                                Icon(
                                  Icons.check_circle,
                                  color: AppColors.Red,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget liveTvItem(Channel channel) {
    return GestureDetector(
      onTap: () {
        // Navigate to live channel screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LiveChannelScreen(channel: channel),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: const Color(0x10FFFFFF),
                      child: Image.asset(
                        "imagePath",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.tv,
                              color: Colors.white.withOpacity(0.3),
                              size: 48,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white.withOpacity(0.8),
                        size: 32,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LiveChannelScreen(channel: channel),
                            ),
                          );
                        },
                        hoverColor: Colors.white.withOpacity(0.1),
                        splashColor: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                channel.name.toString(),
                style: AppStyle.rubik12White.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
