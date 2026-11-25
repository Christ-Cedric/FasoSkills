import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/request_bloc.dart';
import '../../domain/models/service_request.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RequestBloc>().add(LoadMyRequests());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Mes Demandes'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state is RequestLoaded && state.notificationMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.notificationMessage!),
                duration: const Duration(seconds: 2),
                backgroundColor: AppTheme.primaryColor,
              ),
            );
          }
        },
        builder: (context, state) {
          // Loading state (F7)
          if (state is RequestLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor));
          }

          // Error state with retry (F7)
          if (state is RequestError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: AppTheme.destructiveColor),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<RequestBloc>().add(LoadMyRequests()),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Empty state (F7)
          if (state is RequestEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_outlined,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(state.message,
                      style: const TextStyle(color: AppTheme.textSecondary)),
                ],
              ),
            );
          }

          // Loaded state
          if (state is RequestLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<RequestBloc>().add(LoadMyRequests());
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.requests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final request = state.requests[index];
                  return _buildRequestCard(context, request);
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, ServiceRequest request) {
    Color statusColor;
    String statusLabel;

    switch (request.status) {
      case 'pending':
        statusColor = AppTheme.statusPending;
        statusLabel = 'En attente';
        break;
      case 'in_progress':
        statusColor = AppTheme.primaryColor;
        statusLabel = 'En cours';
        break;
      case 'completed':
        statusColor = Colors.green;
        statusLabel = 'Terminée';
        break;
      case 'cancelled':
        statusColor = AppTheme.destructiveColor;
        statusLabel = 'Annulée';
        break;
      default:
        statusColor = Colors.grey;
        statusLabel = request.status;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              request.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: AppTheme.textMuted),
                    const SizedBox(width: 4),
                    Text(request.city,
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
                // Optimistic cancel button (Requirement F8)
                if (request.status == 'pending')
                  TextButton.icon(
                    style: TextButton.styleFrom(
                        foregroundColor: AppTheme.destructiveColor),
                    icon: const Icon(Icons.cancel_outlined, size: 16),
                    label: const Text('Annuler'),
                    onPressed: () {
                      context
                          .read<RequestBloc>()
                          .add(CancelRequestOptimistic(request.id));
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
