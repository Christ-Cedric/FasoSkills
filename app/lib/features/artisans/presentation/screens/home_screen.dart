import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/artisan_list_bloc.dart';
import '../../domain/models/artisan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ArtisanListBloc>().add(const LoadArtisans());
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user != null ? 'Bonjour, ${user.fullName}' : 'FasoSkills',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textColor),
            ),
            const Text(
              'Trouvez un artisan qualifié près de chez vous',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.primaryColor),
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.destructiveColor),
            tooltip: 'Déconnexion',
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ArtisanListBloc>().add(const RefreshArtisans());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner / Search shortcut
              GestureDetector(
                onTap: () => context.push('/search'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Besoin d’un dépannage rapide ?',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Plombiers, électriciens, menuisiers vérifiés',
                              style: TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.build_circle, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Categories Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Catégories de services',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textColor),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryChip('Tous', Icons.dashboard, isSelected: true),
                    _buildCategoryChip('Plomberie', Icons.plumbing),
                    _buildCategoryChip('Électricité', Icons.electrical_services),
                    _buildCategoryChip('Menuiserie', Icons.carpenter),
                    _buildCategoryChip('Maçonnerie', Icons.foundation),
                    _buildCategoryChip('Peinture', Icons.format_paint),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Artisans Section with F7 states: loading, empty, error with retry, loaded
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Artisans disponibles',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textColor),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              BlocBuilder<ArtisanListBloc, ArtisanListState>(
                builder: (context, state) {
                  // Loading State
                  if (state is ArtisanListLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
                    );
                  }

                  // Empty State
                  if (state is ArtisanListEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(32),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.person_search_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    );
                  }

                  // Error State with Retry Button (Exigence F7)
                  if (state is ArtisanListError) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, color: AppTheme.destructiveColor, size: 40),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppTheme.destructiveColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<ArtisanListBloc>().add(const LoadArtisans());
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Réessayer'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                          ),
                        ],
                      ),
                    );
                  }

                  // Loaded State (Cache-then-network aware - Exigence F9)
                  if (state is ArtisanListLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (state.isFromCache)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: const [
                                Icon(Icons.offline_pin, size: 14, color: AppTheme.accentColor),
                                SizedBox(width: 4),
                                Text(
                                  'Données en cache hors-ligne',
                                  style: TextStyle(fontSize: 12, color: AppTheme.accentColor),
                                ),
                              ],
                            ),
                          ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.artisans.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final artisan = state.artisans[index];
                            return _buildArtisanCard(context, artisan);
                          },
                        ),
                      ],
                    );
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/request-quote'),
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Créer une demande', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() => _currentIndex = idx);
          if (idx == 1) context.push('/search');
          if (idx == 2) context.push('/requests');
          if (idx == 3) context.push('/messages');
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Recherche'),
          NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'Demandes'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Messages'),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        avatar: Icon(icon, size: 16, color: isSelected ? Colors.white : AppTheme.primaryColor),
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        backgroundColor: Colors.white,
        selectedColor: AppTheme.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onSelected: (_) {
          context.read<ArtisanListBloc>().add(LoadArtisans(categoryId: label == 'Tous' ? null : label));
        },
      ),
    );
  }

  Widget _buildArtisanCard(BuildContext context, Artisan artisan) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              child: Text(
                artisan.fullName.isNotEmpty ? artisan.fullName[0].toUpperCase() : 'A',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          artisan.fullName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (artisan.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, size: 16, color: AppTheme.primaryColor),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    artisan.specialty.isNotEmpty ? artisan.specialty : (artisan.category?.name ?? 'Artisan'),
                    style: const TextStyle(fontSize: 14, color: AppTheme.primaryColor, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: AppTheme.accentColor),
                      const SizedBox(width: 4),
                      Text(
                        '${artisan.rating} (${artisan.reviewsCount} avis)',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.textMuted),
                      const SizedBox(width: 2),
                      Text(
                        artisan.city,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
