import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/floating_dock_nav_bar.dart';
import '../bloc/artisan_list_bloc.dart';
import '../../domain/models/artisan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _dockIndex = 0;
  final ScrollController _scrollController = ScrollController();

  // Hero carousel state
  final PageController _heroPageController = PageController();
  Timer? _heroTimer;
  int _heroCurrentIndex = 0;

  final List<Map<String, dynamic>> _heroCards = [
    {
      'tag': 'FASOSKILLS',
      'subtitle': 'TROUVEZ VOTRE ARTISAN QUALIFIÉ',
      'title': 'Bienvenue sur FasoSkills',
      'desc': 'Plomberie, électricité, menuiserie & maçonnerie certifiés',
      'icon': Icons.handyman_rounded,
      'gradient': [
        Color(0xFF0F172A),
        Color(0xFF1E3A8A),
        Color(0xFF2563EB),
      ],
    },
    {
      'tag': 'ESTIMATION CLAIRE',
      'subtitle': 'TRANSPARENCE ET PRIX FIXES',
      'title': 'Devis Direct & Gratuit',
      'desc': 'Chiffrez et validez vos travaux avant toute intervention',
      'icon': Icons.receipt_long_rounded,
      'gradient': [
        Color(0xFF1E1B4B),
        Color(0xFF1D4ED8),
        Color(0xFF3B82F6),
      ],
    },
    {
      'tag': 'GARANTIE QUALITÉ',
      'subtitle': 'INTERVENTION RAPIDE 24/7',
      'title': 'Artisans 100% Vérifiés',
      'desc': 'Disponibilité immédiate à Ouagadougou et Bobo-Dioulasso',
      'icon': Icons.verified_user_rounded,
      'gradient': [
        Color(0xFF0B192C),
        Color(0xFF0284C7),
        Color(0xFF2563EB),
      ],
    },
  ];

  final List<Map<String, dynamic>> _featuredServices = [
    {
      'title': 'Plomberie',
      'icon': Icons.plumbing_rounded,
      'color': const Color(0xFF2563EB),
      'slug': 'plomberie',
    },
    {
      'title': 'Électricité',
      'icon': Icons.electrical_services_rounded,
      'color': const Color(0xFFEAB308),
      'slug': 'electricite',
    },
    {
      'title': 'Menuiserie',
      'icon': Icons.carpenter_rounded,
      'color': const Color(0xFFD97706),
      'slug': 'menuiserie',
    },
    {
      'title': 'Maçonnerie',
      'icon': Icons.foundation_rounded,
      'color': const Color(0xFFDC2626),
      'slug': 'maconnerie',
    },
    {
      'title': 'Peinture',
      'icon': Icons.format_paint_rounded,
      'color': const Color(0xFF8B5CF6),
      'slug': 'peinture',
    },
    {
      'title': 'Froid & Clim',
      'icon': Icons.ac_unit_rounded,
      'color': const Color(0xFF06B6D4),
      'slug': 'climatisation',
    },
    {
      'title': 'Serrurerie',
      'icon': Icons.lock_open_rounded,
      'color': const Color(0xFF10B981),
      'slug': 'serrurerie',
    },
    {
      'title': 'Mécanique',
      'icon': Icons.build_rounded,
      'color': const Color(0xFF64748B),
      'slug': 'mecanique',
    },
  ];

  final List<Map<String, dynamic>> _quickActions = [
    {
      'label': 'Demande express',
      'icon': Icons.bolt_rounded,
      'color': const Color(0xFFEAB308),
      'route': '/request-quote',
    },
    {
      'label': 'Artisans vérifiés',
      'icon': Icons.verified_rounded,
      'color': const Color(0xFF2563EB),
      'route': '/search',
    },
    {
      'label': 'Devis direct',
      'icon': Icons.receipt_long_rounded,
      'color': const Color(0xFF10B981),
      'route': '/request-quote',
    },
    {
      'label': 'Mes Chantiers',
      'icon': Icons.assignment_rounded,
      'color': const Color(0xFF6366F1),
      'route': '/requests',
    },
  ];

  @override
  void initState() {
    super.initState();
    context.read<ArtisanListBloc>().add(const LoadArtisans());

    // Auto-scroll carousel every 3.8s from right to left smoothly
    _heroTimer = Timer.periodic(const Duration(milliseconds: 3800), (timer) {
      if (!mounted || !_heroPageController.hasClients) return;
      final nextIndex = (_heroCurrentIndex + 1) % _heroCards.length;
      _heroPageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _heroTimer?.cancel();
    _heroPageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            RefreshIndicator(
              color: const Color(0xFF2563EB),
              onRefresh: () async {
                context.read<ArtisanListBloc>().add(const RefreshArtisans());
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header (FasoSkills + Notification Bell)
                    _buildTopHeader(),

                    const SizedBox(height: 12),

                    // 2. Auto-scrolling Hero Carousel (3 cards)
                    _buildHeroCarousel(),

                    const SizedBox(height: 12),

                    // 3. Carousel Dots Indicator
                    _buildHeroDots(),

                    const SizedBox(height: 18),

                    // 4. Search Bar
                    _buildSearchBar(),

                    const SizedBox(height: 24),

                    // 5. Featured Services Grid (4 x 2)
                    _buildFeaturedServicesSection(),

                    const SizedBox(height: 20),

                    // 6. Quick Action Row (4 items harmonized)
                    _buildQuickActionsGrid(),

                    const SizedBox(height: 26),

                    // 7. Recent Projects
                    _buildRecentProjectsSection(),
                  ],
                ),
              ),
            ),

            // 8. Floating Glassmorphism Dock Bottom Bar (5 tabs)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FloatingDockNavBar(
                currentIndex: _dockIndex,
                onItemSelected: (idx) {
                  setState(() => _dockIndex = idx);
                  if (idx == 0) {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  } else if (idx == 1) {
                    context.push('/messages');
                  } else if (idx == 3) {
                    context.push('/search');
                  } else if (idx == 4) {
                    context.push('/profile');
                  }
                },
                onCenterFabTap: () => context.push('/request-quote'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Top Header: "FasoSkills" on left, Notification Bell on right
  Widget _buildTopHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.handyman_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'FasoSkills',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.6,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF1E293B),
                    size: 22,
                  ),
                  onPressed: () => context.push('/messages'),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Auto-scrolling Hero Carousel with 3 cards
  Widget _buildHeroCarousel() {
    return SizedBox(
      height: 195,
      child: PageView.builder(
        controller: _heroPageController,
        onPageChanged: (idx) {
          setState(() => _heroCurrentIndex = idx);
        },
        itemCount: _heroCards.length,
        itemBuilder: (context, index) {
          final card = _heroCards[index];
          final gradient = card['gradient'] as List<Color>;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 22.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: gradient.last.withValues(alpha: 0.35),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background artistic icon watermark
                Positioned(
                  right: -10,
                  bottom: -15,
                  child: Icon(
                    card['icon'] as IconData,
                    size: 130,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),

                // Content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Glass circular logo icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          card['icon'] as IconData,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      card['tag'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      card['subtitle'] as String,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      card['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      card['desc'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 3. Carousel Dots indicator
  Widget _buildHeroDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_heroCards.length, (index) {
        final isActive = _heroCurrentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6,
          width: isActive ? 22 : 6,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  /// 4. Pill Search Bar
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
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
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: TextField(
        readOnly: true,
        onTap: () => context.push('/search'),
        decoration: const InputDecoration(
          hintText: 'Rechercher un service, artisan...',
          hintStyle: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }

  /// 5. Featured Services Grid (4 x 2)
  Widget _buildFeaturedServicesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Featured Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _featuredServices.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 14,
              crossAxisSpacing: 12,
              childAspectRatio: 0.84,
            ),
            itemBuilder: (context, index) {
              final service = _featuredServices[index];
              return GestureDetector(
                onTap: () {
                  context.push('/service-details', extra: service);
                },
                child: Column(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
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
                      child: Center(
                        child: Icon(
                          service['icon'] as IconData,
                          color: service['color'] as Color,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      service['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 6. Quick Action 4-card Row (Harmonized with Featured Services)
  Widget _buildQuickActionsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _quickActions.map((act) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                final route = act['route'] as String;
                context.push(route);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
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
                      child: Center(
                        child: Icon(
                          act['icon'] as IconData,
                          color: act['color'] as Color,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      act['label'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 7. Recent Projects
  Widget _buildRecentProjectsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Projects',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, size: 24, color: Color(0xFF64748B)),
                    onPressed: () {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded, size: 24, color: Color(0xFF64748B)),
                    onPressed: () {
                      _scrollController.animateTo(
                        200,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          BlocBuilder<ArtisanListBloc, ArtisanListState>(
            builder: (context, state) {
              if (state is ArtisanListLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(color: AppTheme.primaryColor),
                  ),
                );
              }

              if (state is ArtisanListLoaded && state.artisans.isNotEmpty) {
                return SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.artisans.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final artisan = state.artisans[index];
                      return _buildRecentProjectCard(artisan);
                    },
                  ),
                );
              }

              return _buildFallbackProjects();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentProjectCard(Artisan artisan) {
    return GestureDetector(
      onTap: () {
        context.push('/contact', extra: artisan);
      },
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                gradient: LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.architecture_rounded,
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 48,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 12, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${artisan.rating}',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artisan.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${artisan.specialty} • ${artisan.city}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackProjects() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: AppTheme.primaryColor),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Aucun artisan disponible pour le moment. Créez une demande pour être contacté.',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ),
        ],
      ),
    );
  }
}
