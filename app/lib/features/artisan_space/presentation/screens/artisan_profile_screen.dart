import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../artisans/domain/models/artisan.dart';
import '../bloc/artisan_profile_bloc.dart';
import '../widgets/artisan_floating_dock_nav_bar.dart';

class ArtisanProfileScreen extends StatefulWidget {
  const ArtisanProfileScreen({super.key});

  @override
  State<ArtisanProfileScreen> createState() => _ArtisanProfileScreenState();
}

class _ArtisanProfileScreenState extends State<ArtisanProfileScreen> {
  String? _loadedArtisanId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated &&
        authState.user.artisanProfileId != null &&
        _loadedArtisanId != authState.user.artisanProfileId) {
      _loadedArtisanId = authState.user.artisanProfileId;
      context
          .read<ArtisanProfileBloc>()
          .add(LoadArtisanProfile(_loadedArtisanId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go('/login');
        }
      },
      builder: (context, authState) {
        final user = authState is Authenticated ? authState.user : null;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: Stack(
            children: [
              BlocConsumer<ArtisanProfileBloc, ArtisanProfileState>(
                listener: (context, profState) {
                  if (profState is ArtisanProfileLoaded &&
                      profState.feedbackMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(profState.feedbackMessage!),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  }
                  if (profState is ArtisanProfileLoaded &&
                      profState.errorBanner != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(profState.errorBanner!),
                        backgroundColor: const Color(0xFFEF4444),
                      ),
                    );
                  }
                },
                builder: (context, profState) {
                  final artisan = profState is ArtisanProfileLoaded
                      ? profState.artisan
                      : null;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 110),
                    child: Column(
                      children: [
                        _buildHeaderBanner(context),
                        _buildAvatarSection(
                          name: artisan?.fullName.isNotEmpty == true
                              ? artisan!.fullName
                              : (user?.fullName ?? 'Artisan FasoSkills'),
                          specialty: artisan?.specialty.isNotEmpty == true
                              ? artisan!.specialty
                              : 'Artisan Qualifié',
                          email: artisan?.email ?? user?.email ?? '',
                          isVerified:
                              artisan?.isVerified ?? user?.isVerified ?? false,
                        ),
                        const SizedBox(height: 16),
                        _buildStatisticsSection(artisan),
                        const SizedBox(height: 20),
                        if (profState is ArtisanProfileLoading)
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        _buildActionsList(
                            context, artisan, user?.artisanProfileId),
                      ],
                    ),
                  );
                },
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ArtisanFloatingDockNavBar(
                  currentIndex: 4,
                  onItemSelected: (idx) {
                    if (idx == 0) context.go('/artisan/home');
                    if (idx == 1) context.go('/artisan/missions');
                    if (idx == 3) context.push('/discussions');
                  },
                  onCenterFabTap: () => context.go('/artisan/home'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderBanner(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E3A8A),
            Color(0xFF2563EB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(36),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 22),
                  onPressed: () => context.go('/artisan/home'),
                ),
              ),
              const Text(
                'Profil Artisan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded,
                      color: Colors.white, size: 22),
                  onPressed: () => context.push('/notifications'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection({
    required String name,
    required String specialty,
    required String email,
    required bool isVerified,
  }) {
    return Transform.translate(
      offset: const Offset(0, -45),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 44,
              backgroundColor: Color(0xFF1E3A8A),
              child: Icon(
                Icons.handyman_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              if (isVerified) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.verified_rounded,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              specialty,
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              email,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(Artisan? artisan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            _statItem(
              value: '${artisan?.completedJobs ?? 0}',
              label: 'Missions',
              icon: Icons.check_circle_outline_rounded,
              color: const Color(0xFF10B981),
            ),
            _verticalDivider(),
            _statItem(
              value: (artisan?.rating ?? 0.0).toStringAsFixed(1),
              label: 'Note moyenne',
              icon: Icons.star_rounded,
              color: const Color(0xFFF59E0B),
            ),
            _verticalDivider(),
            _statItem(
              value: '${artisan?.experienceYears ?? 0} ans',
              label: 'Expérience',
              icon: Icons.work_outline_rounded,
              color: const Color(0xFF2563EB),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 40,
      color: const Color(0xFFE2E8F0),
    );
  }

  Widget _buildActionsList(
    BuildContext context,
    Artisan? artisan,
    String? artisanProfileId,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          _menuTile(
            icon: Icons.edit_outlined,
            title: 'Modifier mes informations pro',
            subtitle: 'Spécialité, ville, biographie, disponibilité',
            onTap: artisanProfileId == null
                ? null
                : () => _showEditProfileDialog(
                      context,
                      artisanProfileId,
                      artisan,
                    ),
          ),
          const SizedBox(height: 10),
          _menuTile(
            icon: Icons.assignment_outlined,
            title: 'Mes chantiers & devis',
            subtitle: 'Suivre les interventions en cours',
            onTap: () => context.go('/artisan/missions'),
          ),
          const SizedBox(height: 10),
          _menuTile(
            icon: Icons.logout_rounded,
            title: 'Se déconnecter',
            subtitle: 'Fermer votre session artisan',
            isDestructive: true,
            onTap: () => context.read<AuthBloc>().add(LogoutRequested()),
          ),
        ],
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final color =
        isDestructive ? const Color(0xFFEF4444) : const Color(0xFF0F172A);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDestructive
                    ? const Color(0xFFEF4444).withValues(alpha: 0.1)
                    : const Color(0xFF2563EB).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isDestructive
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF2563EB),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDestructive
                  ? const Color(0xFFEF4444)
                  : const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    String artisanId,
    Artisan? artisan,
  ) {
    final specialtyCtrl = TextEditingController(text: artisan?.specialty ?? '');
    final cityCtrl =
        TextEditingController(text: artisan?.city ?? 'Ouagadougou');
    final expCtrl = TextEditingController(
      text: (artisan?.experienceYears ?? 1).toString(),
    );
    final bioCtrl = TextEditingController(text: artisan?.bio ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            24 + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Modifier mon profil pro',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: specialtyCtrl,
                  decoration: const InputDecoration(labelText: 'Spécialité'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cityCtrl,
                  decoration: const InputDecoration(labelText: 'Ville'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: expCtrl,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Années d\'expérience'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bioCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Présentation'),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<ArtisanProfileBloc>().add(
                            UpdateArtisanProfileSubmitted(
                              artisanId: artisanId,
                              specialty: specialtyCtrl.text.trim(),
                              city: cityCtrl.text.trim(),
                              experienceYears:
                                  int.tryParse(expCtrl.text.trim()),
                              bio: bioCtrl.text.trim(),
                            ),
                          );
                      Navigator.of(ctx).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Enregistrer'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
