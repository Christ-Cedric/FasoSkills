import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/floating_dock_nav_bar.dart';

class ArtisansListScreen extends StatefulWidget {
  final String? initialCategory;

  const ArtisansListScreen({
    super.key,
    this.initialCategory,
  });

  @override
  State<ArtisansListScreen> createState() => _ArtisansListScreenState();
}

class _ArtisansListScreenState extends State<ArtisansListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedCategory;
  final int _dockIndex = 3; // Explorer tab

  final List<String> _categories = [
    'Tous',
    'Plomberie',
    'Électricité',
    'Menuiserie',
    'Maçonnerie',
    'Peinture',
    'Climatisation',
    'Serrurerie',
  ];

  // Rich mock data of realistic artisans in Burkina Faso
  final List<Map<String, dynamic>> _allArtisans = [
    {
      'id': 'art_1',
      'fullName': 'Moussa Kaboré',
      'specialty': 'Plomberie',
      'experience': '8 ans d\'expérience',
      'city': 'Ouagadougou',
      'district': 'Ouaga 2000',
      'rating': 4.9,
      'reviewsCount': '142',
      'hourlyRate': '5 000 F / h',
      'isAvailable': true,
      'avatarGradient': [Color(0xFF1E3A8A), Color(0xFF2563EB)],
      'icon': Icons.plumbing_rounded,
      'verified': true,
    },
    {
      'id': 'art_2',
      'fullName': 'Ibrahim Traoré',
      'specialty': 'Menuiserie',
      'experience': '12 ans d\'expérience',
      'city': 'Ouagadougou',
      'district': 'Somgandé',
      'rating': 5.0,
      'reviewsCount': '210',
      'hourlyRate': '7 500 F / h',
      'isAvailable': true,
      'avatarGradient': [Color(0xFFD97706), Color(0xFFB45309)],
      'icon': Icons.carpenter_rounded,
      'verified': true,
    },
    {
      'id': 'art_3',
      'fullName': 'Kassoum Ouédraogo',
      'specialty': 'Électricité',
      'experience': '9 ans d\'expérience',
      'city': 'Ouagadougou',
      'district': 'Karpala',
      'rating': 4.8,
      'reviewsCount': '98',
      'hourlyRate': '6 000 F / h',
      'isAvailable': true,
      'avatarGradient': [Color(0xFF0F172A), Color(0xFF334155)],
      'icon': Icons.electrical_services_rounded,
      'verified': true,
    },
    {
      'id': 'art_4',
      'fullName': 'Salif Kaboré',
      'specialty': 'Maçonnerie',
      'experience': '15 ans d\'expérience',
      'city': 'Bobo-Dioulasso',
      'district': 'Kounsé',
      'rating': 4.9,
      'reviewsCount': '180',
      'hourlyRate': '8 000 F / h',
      'isAvailable': false,
      'avatarGradient': [Color(0xFFDC2626), Color(0xFF991B1B)],
      'icon': Icons.foundation_rounded,
      'verified': true,
    },
    {
      'id': 'art_5',
      'fullName': 'Fatou Diallo',
      'specialty': 'Peinture',
      'experience': '7 ans d\'expérience',
      'city': 'Ouagadougou',
      'district': 'Dassasgho',
      'rating': 4.9,
      'reviewsCount': '115',
      'hourlyRate': '5 500 F / h',
      'isAvailable': true,
      'avatarGradient': [Color(0xFF7C3AED), Color(0xFF5B21B6)],
      'icon': Icons.format_paint_rounded,
      'verified': true,
    },
    {
      'id': 'art_6',
      'fullName': 'Ousmane Sanou',
      'specialty': 'Climatisation',
      'experience': '10 ans d\'expérience',
      'city': 'Ouagadougou',
      'district': 'Gounghin',
      'rating': 5.0,
      'reviewsCount': '240',
      'hourlyRate': '10 000 F / h',
      'isAvailable': true,
      'avatarGradient': [Color(0xFF0284C7), Color(0xFF0369A1)],
      'icon': Icons.ac_unit_rounded,
      'verified': true,
    },
    {
      'id': 'art_7',
      'fullName': 'Issa Sawadogo',
      'specialty': 'Serrurerie',
      'experience': '6 ans d\'expérience',
      'city': 'Ouagadougou',
      'district': 'Pissy',
      'rating': 4.7,
      'reviewsCount': '64',
      'hourlyRate': '4 500 F / h',
      'isAvailable': true,
      'avatarGradient': [Color(0xFF059669), Color(0xFF047857)],
      'icon': Icons.lock_open_rounded,
      'verified': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'Tous';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filteredList = _allArtisans.where((a) {
      final matchesCategory = _selectedCategory == 'Tous' ||
          (a['specialty'] as String).toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = query.isEmpty ||
          (a['fullName'] as String).toLowerCase().contains(query) ||
          (a['specialty'] as String).toLowerCase().contains(query) ||
          (a['district'] as String).toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // Top Custom App Bar matching Screen 2 of the mockup
                _buildTopSearchHeader(),

                // Horizontal Category Filter Chips
                _buildCategoryChips(),

                const SizedBox(height: 8),

                // Count and Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredList.length} professionnels trouvés',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.sort_rounded, size: 16, color: Color(0xFF2563EB)),
                          SizedBox(width: 4),
                          Text(
                            'Les mieux notés',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Vertical List of Artisan Cards (identical to Screen 2 of mockup)
                Expanded(
                  child: filteredList.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                          itemCount: filteredList.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final artisan = filteredList[index];
                            return _buildArtisanCard(artisan);
                          },
                        ),
                ),
              ],
            ),

            // Bottom Navigation Dock (5 tabs)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FloatingDockNavBar(
                currentIndex: _dockIndex,
                onItemSelected: (idx) {
                  if (idx == 0) context.go('/home');
                  if (idx == 1) context.push('/discussions');
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

  /// Top App Bar matching Screen 2: [<] [ Search... ] [ Category v ] [Filter icon]
  Widget _buildTopSearchHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          // Back Button in white circular card
          Container(
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
              icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF0F172A), size: 26),
              onPressed: () => context.pop(),
            ),
          ),
          const SizedBox(width: 10),

          // Search Field
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Rechercher un pro, quartier...',
                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Active Category Pill Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  _selectedCategory,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.arrow_drop_down_rounded, color: Colors.white, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Horizontal Category Chips
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory.toLowerCase() == cat.toLowerCase();
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Artisan Card directly inspired by Screen 2 of the mockup
  Widget _buildArtisanCard(Map<String, dynamic> artisan) {
    final gradient = artisan['avatarGradient'] as List<Color>;
    final isAvailable = artisan['isAvailable'] as bool;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Open detail of the artisan
          context.push('/artisan-detail', extra: artisan);
        },
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Photo / Avatar container with rating badge & share icon overlay
              Stack(
                children: [
                  Container(
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Icon(
                        artisan['icon'] as IconData,
                        color: Colors.white.withValues(alpha: 0.75),
                        size: 44,
                      ),
                    ),
                  ),

                  // Top right share/bookmark icon
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                        size: 13,
                      ),
                    ),
                  ),

                  // Bottom rating pill: ★ 4.9 (140)
                  Positioned(
                    left: 6,
                    right: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 3),
                          Text(
                            '${artisan['rating']}',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            ' (${artisan['reviewsCount']})',
                            style: const TextStyle(
                              fontSize: 9.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 14),

              // Right: Info Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Line 1: Specialty header with icon & 3-dots menu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.build_circle_outlined,
                              size: 14,
                              color: const Color(0xFF2563EB),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Artisan ${artisan['specialty']}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.more_vert_rounded, size: 18, color: Color(0xFF94A3B8)),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Line 2: Artisan Full Name
                    Text(
                      artisan['fullName'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 3),

                    // Line 3: Experience & District
                    Text(
                      '${artisan['experience']} • ${artisan['district']}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Line 4: Price Tag & Direct "+" Action Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Hourly Rate Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                          ),
                          child: Text(
                            artisan['hourlyRate'] as String,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ),

                        // Action Button (+) / Contacter
                        Row(
                          children: [
                            if (isAvailable)
                              Container(
                                margin: const EdgeInsets.only(right: 6),
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            GestureDetector(
                              onTap: () {
                                context.push('/chat-detail', extra: {
                                  'id': artisan['id'],
                                  'artisanName': artisan['fullName'],
                                  'specialty': artisan['specialty'],
                                  'hourlyRate': artisan['hourlyRate'],
                                  'district': artisan['district'],
                                });
                              },
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 16),
                                ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off_rounded, size: 40, color: Color(0xFF2563EB)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucun artisan trouvé',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 6),
            const Text(
              'Essayez de sélectionner une autre catégorie ou de modifier vos mots-clés.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}
