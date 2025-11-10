// Updated characters_screen.dart (now uses BlocBuilder to display dynamic characters)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sozodesktop/src/core/constants/app_color.dart';
import 'package:sozodesktop/src/features/detail/model/character_model.dart';

import '../../core/constants/app_style.dart';
import 'bloc/character_bloc.dart';
import 'bloc/character_event.dart';
import 'bloc/character_state.dart';

class CharactersScreen extends StatefulWidget {
  final int mediaId;

  const CharactersScreen({super.key, required this.mediaId});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CharactersBloc>().add(FetchCharacters(widget.mediaId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<CharactersBloc, CharactersState>(
        builder: (context, state) {
          if (state is CharactersLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state is CharactersLoaded) {
            if (state.characters.isEmpty) {
              return const Center(
                child: Text(
                  'No characters found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return _buildCharactersList(state.characters);
          } else if (state is CharactersError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCharactersList(List<Character> characters) {
    return Container(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        itemCount: characters.length,
        itemBuilder: (context, index) {
          final character = characters[index];
          return _buildCharacterCard(character);
        },
      ),
    );
  }

  Widget _buildCharacterCard(Character character) {
    final imageUrl = character.imageUrl ?? 'https://via.placeholder.com/80';

    return Container(
      margin: const EdgeInsets.only(right: 20),
      padding: EdgeInsets.symmetric( horizontal: 15),
      decoration: BoxDecoration(
        color: Color(0xaffffff),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: 40,backgroundColor: AppColors.Gray2, backgroundImage: NetworkImage(imageUrl)),
          SizedBox(height: 12),
          Text(
            textAlign: TextAlign.center,
            character.name,
            style: AppStyle.dayOne14White,
          ),
        ],
      ),
    );
  }
}
