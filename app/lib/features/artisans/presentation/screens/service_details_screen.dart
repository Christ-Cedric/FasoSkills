import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? serviceData;

  const ServiceDetailsScreen({
    super.key,
    this.serviceData,
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  int _currentCarouselIndex = 0;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _carouselItems = [
    {
      'title': 'Atelier & Intervention',
      'subtitle': 'Équipements de pointe et normes de sécurité',
      'icon': Icons.handyman_rounded,
      'gradient': [Color(0xFF0F172A), Color(0xFF1E3A8A)],
    },
    {
      'title': 'Diagnostic Précis',
      'subtitle': 'Détection rapide de pannes et devis transparent',
      'icon': Icons.troubleshoot_rounded,
      'gradient': [Color(0xFF1E3A8A), Color(0xFF2563EB)],
    },
    {
      'title': 'Finitions Haut de Gamme',
      'subtitle': 'Garantie décennale et satisfaction certifiée',
      'icon': Icons.verified_user_rounded,
      'gradient': [Color(0xFF1E293B), Color(0xFF334155)],
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.serviceData?['title'] as String? ?? 'Rénovation & Plomberie';
    final serviceIcon = widget.serviceData?['icon'] as IconData? ?? Icons.plumbing_rounded;

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
              icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF0F172A), size: 26),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Service Details',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 18,
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
                icon: const Icon(Icons.share_outlined, color: Color(0xFF0F172A), size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lien du service copié')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Image / Workspace Carousel
                    _buildCarousel(serviceIcon),

                    const SizedBox(height: 12),

                    // 2. Carousel Dots Indicator
                    _buildCarouselDots(),

                    const SizedBox(height: 20),

                    // 3. Clean Typography Hierarchy Header
                    _buildTypographyHierarchy(title),

                    const SizedBox(height: 24),

                    // 4. Two Pricing Cards (Side-by-Side as in mockup)
                    _buildPricingSection(),

                    const SizedBox(height: 24),

                    // 5. Garanties et Avantages
                    _buildGuaranteesList(),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom Sticky CTA: "Book Consultation"
            _buildBottomBookingBar(title),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(IconData icon) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (idx) => setState(() => _currentCarouselIndex = idx),
          itemCount: _carouselItems.length,
          itemBuilder: (context, index) {
            final item = _carouselItems[index];
            final gradientColors = item['gradient'] as List<Color>;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Icon(
                      icon,
                      size: 180,
                      color: Colors.white.withValues(alpha: 0.10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                              SizedBox(width: 6),
                              Text(
                                'Intervention Certifiée',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['subtitle'] as String,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
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
      ),
    );
  }

  Widget _buildCarouselDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_carouselItems.length, (index) {
        final isActive = _currentCarouselIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6,
          width: isActive ? 20 : 6,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF2563EB) : const Color(0xFFCBD5E1),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  Widget _buildTypographyHierarchy(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.star_rounded, color: Color(0xFFEAB308), size: 16),
                  SizedBox(width: 4),
                  Text(
                    '4.9 (128 avis)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Tous les services d\'artisans locaux certifiés',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2563EB),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Clean typography hierarchy and clear structured services for your home and office. Bénéficiez d\'un artisan qualifié avec diagnostic rapide, garantie d\'exécution et devis transparent.',
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Row(
      children: [
        // Pricing Card 1: Standard
        Expanded(
          child: _buildPriceCard(
            badge: 'Standard',
            price: '15 000 F',
            period: '/ intervention',
            highlight: false,
            features: ['Diagnostic standard', 'Intervention en 24h', 'Garantie 3 mois'],
            onTap: () => context.push('/request-quote'),
          ),
        ),
        const SizedBox(width: 14),
        // Pricing Card 2: Urgence 24/7
        Expanded(
          child: _buildPriceCard(
            badge: 'Urgence 24/7',
            price: '25 000 F',
            period: '/ intervention',
            highlight: true,
            features: ['Arrivée sous 1h', 'Service de nuit & WE', 'Garantie 6 mois'],
            onTap: () => context.push('/request-quote'),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCard({
    required String badge,
    required String price,
    required String period,
    required bool highlight,
    required List<String> features,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlight ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
          width: highlight ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: highlight
                ? const Color(0xFF2563EB).withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: highlight ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            badge,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: highlight ? const Color(0xFF2563EB) : const Color(0xFF0F172A),
            ),
          ),
          Text(
            period,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: highlight ? const Color(0xFF2563EB) : const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      f,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF475569)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: highlight ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
                foregroundColor: highlight ? Colors.white : const Color(0xFF1E293B),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteesList() {
    final guarantees = [
      {'icon': Icons.security_rounded, 'title': 'Assurance & Garantie', 'desc': 'Travaux couverts en cas de dommages.'},
      {'icon': Icons.bolt_rounded, 'title': 'Réactivité', 'desc': 'Confirmation de disponibilité en moins de 15 minutes.'},
      {'icon': Icons.price_check_rounded, 'title': 'Prix Fixe & Transparent', 'desc': 'Pas de frais cachés, devis validé avant travaux.'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: guarantees
            .map(
              (g) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(g['icon'] as IconData, color: const Color(0xFF2563EB), size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g['title'] as String,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          Text(
                            g['desc'] as String,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildBottomBookingBar(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              context.push('/request-quote');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: const Color(0xFF2563EB).withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Book Consultation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
