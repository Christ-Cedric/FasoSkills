import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/artisan.dart';

class ArtisanDetailScreen extends StatefulWidget {
  final dynamic artisanData;

  const ArtisanDetailScreen({
    super.key,
    this.artisanData,
  });

  @override
  State<ArtisanDetailScreen> createState() => _ArtisanDetailScreenState();
}

class _ArtisanDetailScreenState extends State<ArtisanDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;

  // Extracted artisan properties
  late final String _id;
  late final String _fullName;
  late final String _specialty;
  late final String _experience;
  late final String _city;
  late final String _district;
  late final double _rating;
  late final String _reviewsCount;
  late final String _hourlyRate;
  late final bool _isAvailable;
  late final List<Color> _avatarGradient;
  late final IconData _icon;
  late final bool _isVerified;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _extractArtisanData();
  }

  void _extractArtisanData() {
    final raw = widget.artisanData;

    if (raw is Artisan) {
      _id = raw.id;
      _fullName = raw.fullName;
      _specialty = raw.specialty;
      _experience = '${raw.experienceYears} ans d\'expérience';
      _city = raw.city;
      _district = 'Centre-ville';
      _rating = raw.rating > 0 ? raw.rating : 4.9;
      _reviewsCount = raw.reviewsCount > 0 ? '${raw.reviewsCount}' : '124';
      _hourlyRate = '5 000 F / h';
      _isAvailable = raw.availability == 'Disponible';
      _avatarGradient = const [Color(0xFF1E3A8A), Color(0xFF2563EB)];
      _icon = Icons.handyman_rounded;
      _isVerified = raw.isVerified;
    } else if (raw is Map<String, dynamic>) {
      _id = raw['id']?.toString() ?? 'art_1';
      _fullName = raw['fullName']?.toString() ?? 'Moussa Kaboré';
      _specialty = raw['specialty']?.toString() ?? 'Plomberie Sanitaire';
      _experience = raw['experience']?.toString() ?? '8 ans d\'expérience';
      _city = raw['city']?.toString() ?? 'Ouagadougou';
      _district = raw['district']?.toString() ?? 'Ouaga 2000';
      _rating = (raw['rating'] as num?)?.toDouble() ?? 4.9;
      _reviewsCount = raw['reviewsCount']?.toString() ?? '142';
      _hourlyRate = raw['hourlyRate']?.toString() ?? '5 000 F / h';
      _isAvailable = raw['isAvailable'] as bool? ?? true;
      _avatarGradient = (raw['avatarGradient'] as List<Color>?) ??
          const [Color(0xFF1E3A8A), Color(0xFF2563EB)];
      _icon = (raw['icon'] as IconData?) ?? Icons.plumbing_rounded;
      _isVerified = raw['verified'] as bool? ?? true;
    } else {
      // Default fallback
      _id = 'art_1';
      _fullName = 'Moussa Kaboré';
      _specialty = 'Plomberie & Sanitaire';
      _experience = '8 ans d\'expérience';
      _city = 'Ouagadougou';
      _district = 'Ouaga 2000';
      _rating = 4.9;
      _reviewsCount = '142';
      _hourlyRate = '5 000 F / h';
      _isAvailable = true;
      _avatarGradient = const [Color(0xFF1E3A8A), Color(0xFF2563EB)];
      _icon = Icons.plumbing_rounded;
      _isVerified = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openChat() {
    context.push(
      '/chat-detail',
      extra: {
        'id': 'conv_$_id',
        'artisanName': _fullName,
        'specialty': _specialty,
        'avatarGradient': _avatarGradient,
        'isOnline': _isAvailable,
        'district': '$_city, $_district',
        'lastMessage': 'Bonjour ! Je suis disponible pour étudier votre projet.',
      },
    );
  }

  void _requestQuote() {
    context.push('/request-quote');
  }

  void _callArtisan() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: _avatarGradient),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Icon(_icon, color: Colors.white, size: 28),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fullName,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$_specialty • $_city',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone_rounded, color: Color(0xFF2563EB), size: 22),
                    const SizedBox(width: 12),
                    const Text(
                      '+226 70 85 41 23',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Direct',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.call_rounded, size: 18),
                      label: const Text(
                        'Appeler',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF10B981),
                            content: Text('Appel vers $_fullName en cours...'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Main Scrollable Content
          CustomScrollView(
            slivers: [
              // 1. Sleek Sliver App Bar with Hero Header
              _buildSliverAppBar(),

              // 2. Profile Card & Quick Stats
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    children: [
                      // Key Metrics Row (4 Metrics)
                      _buildQuickMetricsRow(),
                      const SizedBox(height: 20),

                      // Fast Action Buttons Row (Discuter, Appeler, Devis)
                      _buildFastActionButtons(),
                      const SizedBox(height: 24),

                      // Tabs Header
                      _buildTabsHeader(),
                    ],
                  ),
                ),
              ),

              // 3. Tab Content View
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  child: _buildSelectedTabContent(),
                ),
              ),
            ],
          ),

          // Bottom Sticky Booking / Contact Dock
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomStickyDock(),
          ),
        ],
      ),
    );
  }

  /// Sliver Header with Background Gradient, Avatar & Verified Status
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xFF1E3A8A),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF0F172A), size: 26),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      actions: [
        // Share Button
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.share_outlined, color: Color(0xFF0F172A), size: 20),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lien du profil artisan copié dans le presse-papier !'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Bookmark / Favorite
        Padding(
          padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: _isFavorite ? const Color(0xFFEF4444) : const Color(0xFF0F172A),
                size: 20,
              ),
              onPressed: () {
                setState(() => _isFavorite = !_isFavorite);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_isFavorite
                        ? '$_fullName ajouté à vos favoris !'
                        : '$_fullName retiré de vos favoris.'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Blue Modern Gradient Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // Decorative Geometric Circles
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              left: -40,
              bottom: 20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),

            // Profile Header Content
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Large Avatar Container with Online Indicator
                  Stack(
                    children: [
                      Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _avatarGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(_icon, color: Colors.white, size: 40),
                        ),
                      ),
                      // Online dot
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: _isAvailable ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 16),

                  // Name, Specialty, Rating & Badges
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Verified badge + Specialty tag
                        Row(
                          children: [
                            if (_isVerified) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.verified_rounded, color: Color(0xFF34D399), size: 12),
                                    SizedBox(width: 4),
                                    Text(
                                      'Certifié',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _isAvailable ? 'Disponible' : 'Occupé',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // Full Name
                        Text(
                          _fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                        ),

                        const SizedBox(height: 3),

                        // Specialty and Location
                        Text(
                          '$_specialty • $_city, $_district',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 4 Quick Metric Cards
  Widget _buildQuickMetricsRow() {
    return Row(
      children: [
        _buildMetricItem(
          icon: Icons.star_rounded,
          iconColor: const Color(0xFFF59E0B),
          value: '$_rating',
          label: '$_reviewsCount avis',
        ),
        const SizedBox(width: 8),
        _buildMetricItem(
          icon: Icons.work_history_rounded,
          iconColor: const Color(0xFF2563EB),
          value: _experience.split(' ').first,
          label: 'Années exp.',
        ),
        const SizedBox(width: 8),
        _buildMetricItem(
          icon: Icons.task_alt_rounded,
          iconColor: const Color(0xFF10B981),
          value: '340+',
          label: 'Missions',
        ),
        const SizedBox(width: 8),
        _buildMetricItem(
          icon: Icons.bolt_rounded,
          iconColor: const Color(0xFF8B5CF6),
          value: '< 15m',
          label: 'Réactivité',
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Fast Action Buttons: Discuter, Appeler, Demander un devis
  Widget _buildFastActionButtons() {
    return Row(
      children: [
        // 1. Discuter (Primary)
        Expanded(
          flex: 4,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
            label: const Text(
              'Discuter',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: _openChat,
          ),
        ),

        const SizedBox(width: 10),

        // 2. Appeler (Secondary)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: IconButton(
            icon: const Icon(Icons.call_outlined, color: Color(0xFF2563EB), size: 22),
            onPressed: _callArtisan,
          ),
        ),

        const SizedBox(width: 10),

        // 3. Devis (Pill)
        Expanded(
          flex: 4,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0F172A),
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.assignment_outlined, size: 18, color: Color(0xFF2563EB)),
            label: const Text(
              'Devis',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: _requestQuote,
          ),
        ),
      ],
    );
  }

  /// Tabs Header: À propos, Services, Portfolio, Avis
  Widget _buildTabsHeader() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (_) => setState(() {}),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        labelColor: const Color(0xFF2563EB),
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        tabs: const [
          Tab(text: 'À propos'),
          Tab(text: 'Services'),
          Tab(text: 'Portfolio'),
          Tab(text: 'Avis'),
        ],
      ),
    );
  }

  /// Selected Tab Content
  Widget _buildSelectedTabContent() {
    switch (_tabController.index) {
      case 0:
        return _buildAboutTab();
      case 1:
        return _buildServicesTab();
      case 2:
        return _buildPortfolioTab();
      case 3:
        return _buildReviewsTab();
      default:
        return _buildAboutTab();
    }
  }

  /// TAB 1: À PROPOS
  Widget _buildAboutTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bio Section
        _buildSectionCard(
          title: 'Présentation & Parcours',
          icon: Icons.person_outline_rounded,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Artisan professionnel diplômé et certifié, fort de plus de $_experience dans le domaine de $_specialty à $_city et ses environs.\n\n'
                'Je m\'engage à délivrer un travail soigné et respectueux des normes de sécurité en vigueur. Chaque intervention donne lieu à un diagnostic précis et un devis transparent avant le démarrage des travaux.',
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF334155),
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Engagements & Garanties
        _buildSectionCard(
          title: 'Garanties FasoSkills',
          icon: Icons.shield_outlined,
          content: Column(
            children: [
              _buildGuaranteeTile(
                icon: Icons.verified_user_rounded,
                title: 'Identité & Compétences certifiées',
                desc: 'Vérifié par l\'équipe FasoSkills (CNIB & diplômes validés).',
              ),
              const Divider(height: 18, color: Color(0xFFF1F5F9)),
              _buildGuaranteeTile(
                icon: Icons.payment_rounded,
                title: 'Paiement Sécurisé Bilfou / Orange Money',
                desc: 'Les fonds ne sont débloqués qu\'une fois le travail validé.',
              ),
              const Divider(height: 18, color: Color(0xFFF1F5F9)),
              _buildGuaranteeTile(
                icon: Icons.thumb_up_alt_rounded,
                title: 'Garantie d\'intervention 30 jours',
                desc: 'En cas de défaut constaté, réintervention gratuite sous 48h.',
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Zone d'intervention & Horaires
        _buildSectionCard(
          title: 'Disponibilité & Secteurs',
          icon: Icons.place_outlined,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.location_on_rounded, color: Color(0xFF2563EB), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Zone couverte :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Ouagadougou (Ouaga 2000, Somgandé, Karpala, Dassasgho, Gounghin, Tampouy, Pissy) et périphérie.',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B), height: 1.4),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(Icons.schedule_rounded, color: Color(0xFF10B981), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Horaires habituels :',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Lun - Sam : 07h30 - 18h30 • Dimanche : Urgences dépannage',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// TAB 2: SERVICES & TARIFS
  Widget _buildServicesTab() {
    final services = [
      {
        'title': 'Dépannage & Réparation d\'urgence',
        'desc': 'Intervention sous 1h pour panne critique ou urgence technique.',
        'price': '7 500 F CFA',
        'badge': 'Urgence',
      },
      {
        'title': 'Installation neuve ou rénovation',
        'desc': 'Pose de nouveaux équipements, raccords et mise en conformité.',
        'price': 'Sur devis',
        'badge': 'Standard',
      },
      {
        'title': 'Entretien & Diagnostic préventif',
        'desc': 'Vérification complète de votre système avec rapport technique.',
        'price': '5 000 F CFA',
        'badge': 'Forfait',
      },
      {
        'title': 'Fourniture & Remplacement de pièces',
        'desc': 'Pièces d\'origine garanties avec facture détaillée.',
        'price': 'Prix coûtant + MO',
        'badge': 'Garantie',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rate Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF1E3A8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Tarif horaire de base',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '5 000 F CFA / heure',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                onPressed: _requestQuote,
                child: const Text('Devis Gratuit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Prestations proposées',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),

        ...services.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.handyman_rounded, color: Color(0xFF2563EB), size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item['title']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['badge']!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['desc']!,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['price']!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  /// TAB 3: PORTFOLIO & RÉALISATIONS
  Widget _buildPortfolioTab() {
    final projects = [
      {
        'title': 'Rénovation complète Villa Ouaga 2000',
        'category': 'Plomberie & Sanitaires',
        'date': 'Octobre 2024',
        'gradient': [const Color(0xFF0F172A), const Color(0xFF1E3A8A)],
        'icon': Icons.apartment_rounded,
      },
      {
        'title': 'Installation réseau hydraulique R+2',
        'category': 'Tuyauterie & Pompage',
        'date': 'Novembre 2024',
        'gradient': [const Color(0xFF1E3A8A), const Color(0xFF2563EB)],
        'icon': Icons.water_drop_rounded,
      },
      {
        'title': 'Pose de chauffe-eau solaire thermique',
        'category': 'Énergie & Confort',
        'date': 'Décembre 2024',
        'gradient': [const Color(0xFFD97706), const Color(0xFFB45309)],
        'icon': Icons.solar_power_rounded,
      },
      {
        'title': 'Remplacement de robinetterie moderne',
        'category': 'Finition Cuisine & Bain',
        'date': 'Janvier 2025',
        'gradient': [const Color(0xFF10B981), const Color(0xFF047857)],
        'icon': Icons.cleaning_services_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Chantiers récents certifiés',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              '${projects.length} projets',
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
        ),
        const SizedBox(height: 14),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projects.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final p = projects[index];
            final gradient = p['gradient'] as List<Color>;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 95,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: Center(
                      child: Icon(
                        p['icon'] as IconData,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 38,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['title'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          p['date'] as String,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /// TAB 4: AVIS CLIENTS VÉRIFIÉS
  Widget _buildReviewsTab() {
    final reviews = [
      {
        'name': 'Amadou Sawadogo',
        'rating': 5.0,
        'date': 'Il y a 3 jours',
        'comment':
            'Intervention remarquable ! Moussa est arrivé à l\'heure convenue, a repéré la fuite sous la dalle en 20 minutes et l\'a colmatée parfaitement. Très propre et courtois.',
        'tag': 'Plomberie d\'urgence',
      },
      {
        'name': 'Aïcha Ouédraogo',
        'rating': 5.0,
        'date': 'Il y a 1 semaine',
        'comment':
            'Très professionnel et surtout honnête sur les devis. Il a révisé toute la tuyauterie de notre restaurant à Ouaga 2000. Je n\'hésiterai pas à refaire appel à lui.',
        'tag': 'Rénovation sanitaire',
      },
      {
        'name': 'Karim Zongo',
        'rating': 4.8,
        'date': 'Il y a 2 semaines',
        'comment':
            'Excellent travail pour l\'installation du surpresseur et des sanitaires à Karpala. Tarif très correct et respecté. Recommandé sans réserve !',
        'tag': 'Installation neuve',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating Overview Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    '$_rating',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) => const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_reviewsCount avis vérifiés',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar(stars: 5, pct: 0.92),
                    const SizedBox(height: 4),
                    _buildRatingBar(stars: 4, pct: 0.08),
                    const SizedBox(height: 4),
                    _buildRatingBar(stars: 3, pct: 0.0),
                    const SizedBox(height: 4),
                    _buildRatingBar(stars: 2, pct: 0.0),
                    const SizedBox(height: 4),
                    _buildRatingBar(stars: 1, pct: 0.0),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Commentaires récents',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),

        ...reviews.map((r) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: const Color(0xFF2563EB).withValues(alpha: 0.15),
                            child: Text(
                              (r['name'] as String).substring(0, 1),
                              style: const TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                r['date'] as String,
                                style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                          const SizedBox(width: 2),
                          Text(
                            '${r['rating']}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    r['comment'] as String,
                    style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), height: 1.45),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      r['tag'] as String,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildRatingBar({required int stars, required double pct}) {
    return Row(
      children: [
        Text('$stars', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
        const SizedBox(width: 4),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 5,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF2563EB), size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildGuaranteeTile({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF2563EB), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Sticky Bottom Booking Dock
  Widget _buildBottomStickyDock() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Left price indicator
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tarif indicatif',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  _hourlyRate,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 20),

            // Right CTA Buttons: Message + Quote
            Expanded(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF2563EB)),
                      onPressed: _openChat,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _requestQuote,
                      child: const Text(
                        'Demander un devis',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                        ),
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
  }
}
