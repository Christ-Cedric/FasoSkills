import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/artisan_jobs_bloc.dart';
import '../widgets/artisan_floating_dock_nav_bar.dart';
import '../widgets/artisan_request_card.dart';

class ArtisanMissionsScreen extends StatefulWidget {
  const ArtisanMissionsScreen({super.key});

  @override
  State<ArtisanMissionsScreen> createState() => _ArtisanMissionsScreenState();
}

class _ArtisanMissionsScreenState extends State<ArtisanMissionsScreen> {
  int _selectedTab = 0; // 0: En cours, 1: Ouvertes, 2: Terminées

  final List<({String label, String status})> _tabs = const [
    (label: 'En cours', status: 'in_progress'),
    (label: 'Ouvertes', status: 'pending'),
    (label: 'Terminées', status: 'completed'),
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentTab();
  }

  void _loadCurrentTab() {
    context.read<ArtisanJobsBloc>().add(
          LoadArtisanRequests(status: _tabs[_selectedTab].status),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                  child: Row(
                    children: [
                      const Text(
                        'Mes Chantiers',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _loadCurrentTab,
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _buildPillTabs(),
                const SizedBox(height: 16),
                Expanded(child: _buildMissionsList()),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ArtisanFloatingDockNavBar(
                currentIndex: 1,
                onItemSelected: (idx) {
                  if (idx == 0) context.go('/artisan/home');
                  if (idx == 3) context.push('/discussions');
                  if (idx == 4) context.go('/artisan/profile');
                },
                onCenterFabTap: _loadCurrentTab,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedTab = index);
                _loadCurrentTab();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                const Color(0xFF0F172A).withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  _tabs[index].label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMissionsList() {
    return BlocBuilder<ArtisanJobsBloc, ArtisanJobsState>(
      builder: (context, state) {
        if (state is ArtisanJobsLoading || state is ArtisanJobsInitial) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
          );
        }

        if (state is ArtisanJobsError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Color(0xFFEF4444),
                  ),
                  const SizedBox(height: 12),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadCurrentTab,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is ArtisanJobsEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.assignment_turned_in_outlined,
                    size: 56,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Aucun chantier "${_tabs[_selectedTab].label}"',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is ArtisanJobsLoaded) {
          return RefreshIndicator(
            color: const Color(0xFF2563EB),
            onRefresh: () async => _loadCurrentTab(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 110),
              itemCount: state.requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final req = state.requests[index];
                return ArtisanRequestCard(
                  request: req,
                  onTapDetails: () =>
                      context.push('/artisan/request-detail', extra: req),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
