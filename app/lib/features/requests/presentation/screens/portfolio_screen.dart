import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/floating_dock_nav_bar.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  int _selectedFilterIndex = 0;
  final int _dockIndex = 2; // Projets tab

  final List<String> _filters = [
    'Tous',
    'Plomberie',
    'Électricité',
    'Menuiserie',
    'Maçonnerie',
    'Peinture',
    'Climatisation',
  ];

  final List<Map<String, dynamic>> _portfolioItems = [
    {
      'title': 'Rénovation Villa Ouaga 2000',
      'category': 'PLOMBERIE',
      'artisan': 'Moussa Sawadogo',
      'rating': '4.9',
      'height': 240.0,
      'gradient': [Color(0xFF1E3A8A), Color(0xFF2563EB)],
      'icon': Icons.water_drop_rounded,
      'hasVideo': true,
      'tag': 'BRANDING',
    },
    {
      'title': 'Table & Mobilier Bois Teck',
      'category': 'MENUISERIE',
      'artisan': 'Ibrahim Traoré',
      'rating': '5.0',
      'height': 170.0,
      'gradient': [Color(0xFFD97706), Color(0xFFB45309)],
      'icon': Icons.carpenter_rounded,
      'hasVideo': false,
      'tag': 'POSTERS',
    },
    {
      'title': 'Installation Solaire 5kW',
      'category': 'ÉLECTRICITÉ',
      'artisan': 'Kassoum Ouedraogo',
      'rating': '4.8',
      'height': 190.0,
      'gradient': [Color(0xFF0F172A), Color(0xFF334155)],
      'icon': Icons.solar_power_rounded,
      'hasVideo': true,
      'tag': 'VIDEOS',
    },
    {
      'title': 'Chantier Duplex Somgandé',
      'category': 'MAÇONNERIE',
      'artisan': 'Salif Kaboré',
      'rating': '4.9',
      'height': 230.0,
      'gradient': [Color(0xFFDC2626), Color(0xFF991B1B)],
      'icon': Icons.foundation_rounded,
      'hasVideo': false,
      'tag': 'PHOTOS',
    },
    {
      'title': 'Peinture Décorative Moderne',
      'category': 'PEINTURE',
      'artisan': 'Fatou Diallo',
      'rating': '4.9',
      'height': 180.0,
      'gradient': [Color(0xFF7C3AED), Color(0xFF5B21B6)],
      'icon': Icons.format_paint_rounded,
      'hasVideo': false,
      'tag': 'CAMPAIGN',
    },
    {
      'title': 'Clim Centrale Siège Banque',
      'category': 'CLIMATISATION',
      'artisan': 'Ousmane Sanou',
      'rating': '5.0',
      'height': 210.0,
      'gradient': [Color(0xFF0284C7), Color(0xFF0369A1)],
      'icon': Icons.ac_unit_rounded,
      'hasVideo': true,
      'tag': 'PHOTOS',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedFilterIndex == 0
        ? _portfolioItems
        : _portfolioItems
            .where((item) =>
                (item['category'] as String).toLowerCase() ==
                _filters[_selectedFilterIndex].toLowerCase())
            .toList();

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
          'Portfolio',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
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
                icon: const Icon(Icons.search_rounded, color: Color(0xFF0F172A), size: 22),
                onPressed: () => context.push('/search'),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter Chips row (matching [Filters] [Posters] [Videos] [Photos] in mockup)
                  _buildFilterChips(),

                  const SizedBox(height: 16),

                  // Staggered 2-column masonry grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildMasonryGrid(filteredItems),
                  ),
                ],
              ),
            ),

            // Floating Dock Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FloatingDockNavBar(
                currentIndex: _dockIndex,
                onItemSelected: (idx) {
                  if (idx == 0) context.go('/home');
                  if (idx == 1) context.push('/messages');
                  if (idx == 3) context.push('/search');
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

  Widget _buildFilterChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Text(
                _filters[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMasonryGrid(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: const Text(
          'Aucune réalisation dans cette catégorie',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
      );
    }

    final leftColumnItems = <Map<String, dynamic>>[];
    final rightColumnItems = <Map<String, dynamic>>[];

    for (int i = 0; i < items.length; i++) {
      if (i % 2 == 0) {
        leftColumnItems.add(items[i]);
      } else {
        rightColumnItems.add(items[i]);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: leftColumnItems.map((item) => _buildCard(item)).toList(),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            children: rightColumnItems.map((item) => _buildCard(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    final gradient = item['gradient'] as List<Color>;
    final height = item['height'] as double;
    final tag = item['tag'] as String;
    final hasVideo = item['hasVideo'] as bool;

    return GestureDetector(
      onTap: () {
        context.push('/request-quote');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Gradient Background with abstract shape & icon
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    item['icon'] as IconData,
                    size: height * 0.35,
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
              ),

              // Gradient Overlay for text contrast
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.15),
                        Colors.black.withValues(alpha: 0.75),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              // Tag Badge (Branding / Posters / Photos) on top
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              // Video / Play Icon badge
              if (hasVideo)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),

              // Bottom details info
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item['title'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(color: Colors.black45, blurRadius: 4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['artisan'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              item['rating'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
