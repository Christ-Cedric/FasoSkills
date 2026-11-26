import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../requests/domain/models/service_request.dart';
import '../../domain/repositories/artisan_space_repository.dart';

/// Debounce transformer for artisan request search (Requirement F8).
EventTransformer<E> artisanDebounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

// ── Events ─────────────────────────────────────────────────────────────────

abstract class ArtisanJobsEvent extends Equatable {
  const ArtisanJobsEvent();
  @override
  List<Object?> get props => [];
}

class LoadArtisanRequests extends ArtisanJobsEvent {
  final String? status;
  final String? city;
  final String? search;
  final String? categoryId;

  const LoadArtisanRequests({
    this.status,
    this.city,
    this.search,
    this.categoryId,
  });

  @override
  List<Object?> get props => [status, city, search, categoryId];
}

class SearchArtisanRequests extends ArtisanJobsEvent {
  final String query;
  final String? status;
  final String? city;

  const SearchArtisanRequests(this.query, {this.status, this.city});

  @override
  List<Object?> get props => [query, status, city];
}

class SubmitQuoteRequested extends ArtisanJobsEvent {
  final String requestId;
  final double amount;
  final int estimatedDays;
  final String? message;

  const SubmitQuoteRequested({
    required this.requestId,
    required this.amount,
    required this.estimatedDays,
    this.message,
  });

  @override
  List<Object?> get props => [requestId, amount, estimatedDays, message];
}

/// Optimistic status update with rollback on failure (Requirement F8).
class UpdateMissionStatusOptimistic extends ArtisanJobsEvent {
  final String requestId;
  final String newStatus;

  const UpdateMissionStatusOptimistic({
    required this.requestId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [requestId, newStatus];
}

// ── States (F7: Loading, Empty, Error with retry, Loaded) ──────────────────

abstract class ArtisanJobsState extends Equatable {
  const ArtisanJobsState();
  @override
  List<Object?> get props => [];
}

class ArtisanJobsInitial extends ArtisanJobsState {}

class ArtisanJobsLoading extends ArtisanJobsState {}

class ArtisanJobsLoaded extends ArtisanJobsState {
  final List<ServiceRequest> requests;
  final String? activeCity;
  final String? activeStatus;
  final String? searchQuery;
  final bool isSubmittingQuote;
  final String? notificationMessage;
  final String? errorBanner;

  const ArtisanJobsLoaded({
    required this.requests,
    this.activeCity,
    this.activeStatus,
    this.searchQuery,
    this.isSubmittingQuote = false,
    this.notificationMessage,
    this.errorBanner,
  });

  ArtisanJobsLoaded copyWith({
    List<ServiceRequest>? requests,
    String? activeCity,
    String? activeStatus,
    String? searchQuery,
    bool? isSubmittingQuote,
    String? notificationMessage,
    String? errorBanner,
  }) {
    return ArtisanJobsLoaded(
      requests: requests ?? this.requests,
      activeCity: activeCity ?? this.activeCity,
      activeStatus: activeStatus ?? this.activeStatus,
      searchQuery: searchQuery ?? this.searchQuery,
      isSubmittingQuote: isSubmittingQuote ?? this.isSubmittingQuote,
      notificationMessage: notificationMessage,
      errorBanner: errorBanner,
    );
  }

  @override
  List<Object?> get props => [
        requests,
        activeCity,
        activeStatus,
        searchQuery,
        isSubmittingQuote,
        notificationMessage,
        errorBanner,
      ];
}

class ArtisanJobsEmpty extends ArtisanJobsState {
  final String message;
  final String? activeCity;
  final String? activeStatus;
  final String? searchQuery;

  const ArtisanJobsEmpty({
    this.message = 'Aucune demande disponible dans cette zone',
    this.activeCity,
    this.activeStatus,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [message, activeCity, activeStatus, searchQuery];
}

class ArtisanJobsError extends ArtisanJobsState {
  final String message;
  const ArtisanJobsError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── BLoC ───────────────────────────────────────────────────────────────────

class ArtisanJobsBloc extends Bloc<ArtisanJobsEvent, ArtisanJobsState> {
  final ArtisanSpaceRepository _repository;

  ArtisanJobsBloc({required ArtisanSpaceRepository repository})
      : _repository = repository,
        super(ArtisanJobsInitial()) {
    on<LoadArtisanRequests>(_onLoadRequests);
    on<SearchArtisanRequests>(
      _onSearchRequests,
      transformer: artisanDebounce(const Duration(milliseconds: 300)),
    );
    on<SubmitQuoteRequested>(_onSubmitQuote);
    on<UpdateMissionStatusOptimistic>(_onUpdateMissionStatus);
  }

  Future<void> _onLoadRequests(
    LoadArtisanRequests event,
    Emitter<ArtisanJobsState> emit,
  ) async {
    emit(ArtisanJobsLoading());
    final result = await _repository.getRequests(
      status: event.status,
      city: event.city,
      search: event.search,
      categoryId: event.categoryId,
    );

    result.when(
      success: (requests) {
        if (requests.isEmpty) {
          emit(ArtisanJobsEmpty(
            activeCity: event.city,
            activeStatus: event.status,
            searchQuery: event.search,
          ));
        } else {
          emit(ArtisanJobsLoaded(
            requests: requests,
            activeCity: event.city,
            activeStatus: event.status,
            searchQuery: event.search,
          ));
        }
      },
      failure: (failure) => emit(ArtisanJobsError(failure.message)),
    );
  }

  Future<void> _onSearchRequests(
    SearchArtisanRequests event,
    Emitter<ArtisanJobsState> emit,
  ) async {
    emit(ArtisanJobsLoading());
    final result = await _repository.getRequests(
      search: event.query,
      status: event.status,
      city: event.city,
    );

    result.when(
      success: (requests) {
        if (requests.isEmpty) {
          emit(ArtisanJobsEmpty(
            message: 'Aucune demande ne correspond à "${event.query}"',
            activeCity: event.city,
            activeStatus: event.status,
            searchQuery: event.query,
          ));
        } else {
          emit(ArtisanJobsLoaded(
            requests: requests,
            activeCity: event.city,
            activeStatus: event.status,
            searchQuery: event.query,
          ));
        }
      },
      failure: (failure) => emit(ArtisanJobsError(failure.message)),
    );
  }

  Future<void> _onSubmitQuote(
    SubmitQuoteRequested event,
    Emitter<ArtisanJobsState> emit,
  ) async {
    final current = state;
    if (current is ArtisanJobsLoaded) {
      emit(current.copyWith(isSubmittingQuote: true));
    }

    final result = await _repository.submitQuote(
      requestId: event.requestId,
      amount: event.amount,
      estimatedDays: event.estimatedDays,
      message: event.message,
    );

    result.when(
      success: (quote) {
        if (state is ArtisanJobsLoaded) {
          final loaded = state as ArtisanJobsLoaded;
          emit(loaded.copyWith(
            isSubmittingQuote: false,
            notificationMessage:
                'Devis de ${quote.amount.toStringAsFixed(0)} F CFA envoyé avec succès',
          ));
        }
      },
      failure: (failure) {
        if (state is ArtisanJobsLoaded) {
          final loaded = state as ArtisanJobsLoaded;
          emit(loaded.copyWith(
            isSubmittingQuote: false,
            errorBanner: failure.message,
          ));
        } else {
          emit(ArtisanJobsError(failure.message));
        }
      },
    );
  }

  Future<void> _onUpdateMissionStatus(
    UpdateMissionStatusOptimistic event,
    Emitter<ArtisanJobsState> emit,
  ) async {
    if (state is! ArtisanJobsLoaded) return;
    final loaded = state as ArtisanJobsLoaded;
    final previous = List<ServiceRequest>.from(loaded.requests);

    // 1. Optimistic UI update
    final optimistic = loaded.requests
        .map((r) =>
            r.id == event.requestId ? r.copyWith(status: event.newStatus) : r)
        .toList();

    emit(loaded.copyWith(
      requests: optimistic,
      notificationMessage: 'Statut mis à jour',
    ));

    // 2. Sync with backend; rollback on failure
    final result = await _repository.updateRequestStatus(
      event.requestId,
      event.newStatus,
    );

    result.when(
      success: (updated) {
        final synced = optimistic
            .map((r) => r.id == updated.id ? updated : r)
            .toList();
        emit(loaded.copyWith(
          requests: synced,
          notificationMessage: 'Statut confirmé (${updated.status})',
        ));
      },
      failure: (failure) {
        emit(loaded.copyWith(
          requests: previous,
          errorBanner: 'Échec de mise à jour : ${failure.message}',
        ));
      },
    );
  }
}
