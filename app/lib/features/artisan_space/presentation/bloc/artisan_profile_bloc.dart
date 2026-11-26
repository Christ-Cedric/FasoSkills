import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../artisans/domain/models/artisan.dart';
import '../../domain/repositories/artisan_space_repository.dart';

// ── Events ─────────────────────────────────────────────────────────────────

abstract class ArtisanProfileEvent extends Equatable {
  const ArtisanProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadArtisanProfile extends ArtisanProfileEvent {
  final String artisanId;
  const LoadArtisanProfile(this.artisanId);
  @override
  List<Object?> get props => [artisanId];
}

class UpdateArtisanProfileSubmitted extends ArtisanProfileEvent {
  final String artisanId;
  final String? specialty;
  final String? city;
  final int? experienceYears;
  final String? bio;
  final String? availability;

  const UpdateArtisanProfileSubmitted({
    required this.artisanId,
    this.specialty,
    this.city,
    this.experienceYears,
    this.bio,
    this.availability,
  });

  @override
  List<Object?> get props =>
      [artisanId, specialty, city, experienceYears, bio, availability];
}

// ── States ─────────────────────────────────────────────────────────────────

abstract class ArtisanProfileState extends Equatable {
  const ArtisanProfileState();
  @override
  List<Object?> get props => [];
}

class ArtisanProfileInitial extends ArtisanProfileState {}

class ArtisanProfileLoading extends ArtisanProfileState {}

class ArtisanProfileLoaded extends ArtisanProfileState {
  final Artisan artisan;
  final bool isUpdating;
  final String? feedbackMessage;
  final String? errorBanner;

  const ArtisanProfileLoaded(
    this.artisan, {
    this.isUpdating = false,
    this.feedbackMessage,
    this.errorBanner,
  });

  ArtisanProfileLoaded copyWith({
    Artisan? artisan,
    bool? isUpdating,
    String? feedbackMessage,
    String? errorBanner,
  }) {
    return ArtisanProfileLoaded(
      artisan ?? this.artisan,
      isUpdating: isUpdating ?? this.isUpdating,
      feedbackMessage: feedbackMessage,
      errorBanner: errorBanner,
    );
  }

  @override
  List<Object?> get props =>
      [artisan, isUpdating, feedbackMessage, errorBanner];
}

class ArtisanProfileError extends ArtisanProfileState {
  final String message;
  const ArtisanProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── BLoC ───────────────────────────────────────────────────────────────────

class ArtisanProfileBloc
    extends Bloc<ArtisanProfileEvent, ArtisanProfileState> {
  final ArtisanSpaceRepository _repository;

  ArtisanProfileBloc({required ArtisanSpaceRepository repository})
      : _repository = repository,
        super(ArtisanProfileInitial()) {
    on<LoadArtisanProfile>(_onLoadProfile);
    on<UpdateArtisanProfileSubmitted>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadArtisanProfile event,
    Emitter<ArtisanProfileState> emit,
  ) async {
    emit(ArtisanProfileLoading());
    final result = await _repository.getArtisanProfile(event.artisanId);
    result.when(
      success: (artisan) => emit(ArtisanProfileLoaded(artisan)),
      failure: (failure) => emit(ArtisanProfileError(failure.message)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateArtisanProfileSubmitted event,
    Emitter<ArtisanProfileState> emit,
  ) async {
    final current = state;
    if (current is ArtisanProfileLoaded) {
      emit(current.copyWith(isUpdating: true));
    }

    final result = await _repository.updateArtisanProfile(
      artisanId: event.artisanId,
      specialty: event.specialty,
      city: event.city,
      experienceYears: event.experienceYears,
      bio: event.bio,
      availability: event.availability,
    );

    result.when(
      success: (updated) => emit(ArtisanProfileLoaded(
        updated,
        feedbackMessage: 'Profil artisan mis à jour',
      )),
      failure: (failure) {
        if (current is ArtisanProfileLoaded) {
          emit(current.copyWith(
            isUpdating: false,
            errorBanner: failure.message,
          ));
        } else {
          emit(ArtisanProfileError(failure.message));
        }
      },
    );
  }
}
