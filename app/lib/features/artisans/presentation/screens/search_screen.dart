import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/artisan_list_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Rechercher un métier, un artisan...',
            border: InputBorder.none,
          ),
          // Deliberate debounce event transformer trigger - Requirement F8
          onChanged: (query) {
            context.read<ArtisanListBloc>().add(SearchQueryChanged(query));
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                context.read<ArtisanListBloc>().add(const SearchQueryChanged(''));
              },
            ),
        ],
      ),
      body: BlocBuilder<ArtisanListBloc, ArtisanListState>(
        builder: (context, state) {
          if (state is ArtisanListLoading) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
          }

          if (state is ArtisanListEmpty) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: AppTheme.textSecondary)),
            );
          }

          if (state is ArtisanListLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.artisans.length,
              itemBuilder: (context, index) {
                final artisan = state.artisans[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                    child: Text(artisan.fullName[0].toUpperCase()),
                  ),
                  title: Text(artisan.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${artisan.specialty} • ${artisan.city}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 16, color: AppTheme.accentColor),
                      const SizedBox(width: 4),
                      Text('${artisan.rating}'),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Tapez pour rechercher un artisan'));
        },
      ),
    );
  }
}
