import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/floating_dock_nav_bar.dart';

class DiscussionsListScreen extends StatefulWidget {
  const DiscussionsListScreen({super.key});

  @override
  State<DiscussionsListScreen> createState() => _DiscussionsListScreenState();
}

class _DiscussionsListScreenState extends State<DiscussionsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final int _dockIndex = 1; // Discussions tab

  // Mock discussions data
  final List<Map<String, dynamic>> _discussions = [
    {
      'id': 'conv_1',
      'artisanName': 'Moussa Kaboré',
      'specialty': 'Plombier Sanitaire',
      'lastMessage': 'Bonjour ! Je peux passer demain matin vers 9h pour inspecter la fuite.',
      'time': '14:24',
      'unreadCount': 2,
      'isOnline': true,
      'avatarGradient': [Color(0xFF1E3A8A), Color(0xFF2563EB)],
      'icon': Icons.plumbing_rounded,
      'district': 'Ouaga 2000',
    },
    {
      'id': 'conv_2',
      'artisanName': 'Ibrahim Traoré',
      'specialty': 'Menuisier Ébéniste',
      'lastMessage': 'Le devis pour la table sur mesure est prêt. Je vous l\'envoie tout de suite.',
      'time': '11:15',
      'unreadCount': 0,
      'isOnline': false,
      'avatarGradient': [Color(0xFFD97706), Color(0xFFB45309)],
      'icon': Icons.carpenter_rounded,
      'district': 'Somgandé',
    },
    {
      'id': 'conv_3',
      'artisanName': 'Kassoum Ouédraogo',
      'specialty': 'Électricien Bâtiment',
      'lastMessage': 'Merci pour votre confirmation. J\'apporte les disjoncteurs certifiés.',
      'time': 'Hier',
      'unreadCount': 0,
      'isOnline': true,
      'avatarGradient': [Color(0xFF0F172A), Color(0xFF334155)],
      'icon': Icons.electrical_services_rounded,
      'district': 'Karpala',
    },
    {
      'id': 'conv_4',
      'artisanName': 'Fatou Diallo',
      'specialty': 'Peinture Décorative',
      'lastMessage': 'Quelle teinte préférez-vous pour le salon ? Nuancier disponible.',
      'time': '21 Nov',
      'unreadCount': 1,
      'isOnline': false,
      'avatarGradient': [Color(0xFF7C3AED), Color(0xFF5B21B6)],
      'icon': Icons.format_paint_rounded,
      'district': 'Dassasgho',
    },
    {
      'id': 'conv_5',
      'artisanName': 'Ousmane Sanou',
      'specialty': 'Technicien Froid & Clim',
      'lastMessage': 'Entretien annuel effectué avec succès. Garantie 6 mois active.',
      'time': '18 Nov',
      'unreadCount': 0,
      'isOnline': false,
      'avatarGradient': [Color(0xFF0284C7), Color(0xFF0369A1)],
      'icon': Icons.ac_unit_rounded,
      'district': 'Gounghin',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filteredDiscussions = _discussions.where((d) {
      final name = (d['artisanName'] as String).toLowerCase();
      final specialty = (d['specialty'] as String).toLowerCase();
      final msg = (d['lastMessage'] as String).toLowerCase();
      return query.isEmpty || name.contains(query) || specialty.contains(query) || msg.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.forum_rounded,
                color: Color(0xFF2563EB),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Discussions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
                icon: const Icon(Icons.edit_note_rounded, color: Color(0xFF0F172A), size: 22),
                onPressed: () => context.push('/artisans-list'),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                // 1. Search Bar for conversations
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
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
                        hintText: 'Rechercher une discussion, un artisan...',
                        hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 2. Horizontal Story / Artisans en ligne
                _buildOnlineArtisansBar(),

                const SizedBox(height: 12),

                // 3. Conversations List
                Expanded(
                  child: filteredDiscussions.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                          itemCount: filteredDiscussions.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final conv = filteredDiscussions[index];
                            return _buildConversationItem(conv);
                          },
                        ),
                ),
              ],
            ),

            // 4. Floating Dock Navigation Bar (5 tabs)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FloatingDockNavBar(
                currentIndex: _dockIndex,
                onItemSelected: (idx) {
                  if (idx == 0) context.go('/home');
                  if (idx == 3) context.push('/artisans-list');
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

  Widget _buildOnlineArtisansBar() {
    final onlineArtisans = _discussions.where((d) => d['isOnline'] == true).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Artisans disponibles en direct',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 72,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: onlineArtisans.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final art = onlineArtisans[index];
              final gradient = art['avatarGradient'] as List<Color>;

              return GestureDetector(
                onTap: () {
                  context.push('/chat-detail', extra: art);
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF2563EB), width: 2),
                          ),
                          child: Center(
                            child: Icon(
                              art['icon'] as IconData,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 1,
                          bottom: 1,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (art['artisanName'] as String).split(' ').first,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConversationItem(Map<String, dynamic> conv) {
    final gradient = conv['avatarGradient'] as List<Color>;
    final isOnline = conv['isOnline'] as bool;
    final unread = conv['unreadCount'] as int;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unread > 0 ? const Color(0xFFBFDBFE) : const Color(0xFFE2E8F0),
          width: unread > 0 ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: unread > 0
                ? const Color(0xFF2563EB).withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Open chat conversation detail
          context.push('/chat-detail', extra: conv);
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Avatar with Online status
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        conv['icon'] as IconData,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 14),

              // Middle: Name, Specialty & Last Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            conv['artisanName'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        Text(
                          conv['time'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w500,
                            color: unread > 0 ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${conv['specialty']} • ${conv['district']}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      conv['lastMessage'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w400,
                        color: unread > 0 ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              // Unread Badge
              if (unread > 0)
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
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
              child: const Icon(Icons.chat_bubble_outline_rounded, size: 40, color: Color(0xFF2563EB)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucune discussion trouvée',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 6),
            const Text(
              'Contactez un artisan depuis la liste pour démarrer une conversation.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}
