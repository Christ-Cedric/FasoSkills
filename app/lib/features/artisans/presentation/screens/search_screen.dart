import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/floating_dock_nav_bar.dart';
import '../bloc/artisan_list_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final int _dockIndex = 3; // Explorer tab

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A), size: 22),
              onPressed: () => context.go('/home'),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Explorer',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // Pill Search input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un métier, artisan...',
                        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 22),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Color(0xFF94A3B8)),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<ArtisanListBloc>().add(const SearchQueryChanged(''));
                                  setState(() {});
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                      onChanged: (query) {
                        context.read<ArtisanListBloc>().add(SearchQueryChanged(query));
                        setState(() {});
                      },
                    ),
                  ),
                ),

                Expanded(
                  child: BlocBuilder<ArtisanListBloc, ArtisanListState>(
                    builder: (context, state) {
                      if (state is ArtisanListLoading) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
                      }

                      if (state is ArtisanListEmpty) {
                        return Center(
                          child: Text(state.message, style: const TextStyle(color: AppTheme.textSecondary)),
                        );
                      }

                      if (state is ArtisanListLoaded) {
                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                          itemCount: state.artisans.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final artisan = state.artisans[index];
                            return GestureDetector(
                              onTap: () {
                                context.push('/artisan-detail', extra: artisan);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          artisan.fullName[0].toUpperCase(),
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            artisan.fullName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${artisan.specialty} • ${artisan.city}',
                                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF3C7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFD97706)),
                                          const SizedBox(width: 3),
                                          Text(
                                            '${artisan.rating}',
                                            style: const TextStyle(
                                              color: Color(0xFFB45309),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
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

                      return const Center(child: Text('Tapez pour rechercher un artisan'));
                    },
                  ),
                ),
              ],
            ),

            // Bottom Navigation Dock
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FloatingDockNavBar(
                currentIndex: _dockIndex,
                onItemSelected: (idx) {
                  if (idx == 0) context.go('/home');
                  if (idx == 1) context.push('/messages');
                  if (idx == 4) context.push('/profile');
                },
                onCenterFabTap: () => context.push('/request-quote'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
