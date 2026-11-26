import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/core/errors/failure.dart';
import 'package:app/core/errors/result.dart';
import 'package:app/features/artisans/domain/models/artisan.dart';
import 'package:app/features/artisan_space/domain/repositories/artisan_space_repository.dart';
import 'package:app/features/artisan_space/presentation/bloc/artisan_jobs_bloc.dart';
import 'package:app/features/artisan_space/presentation/bloc/artisan_profile_bloc.dart';
import 'package:app/features/requests/domain/models/quote.dart';
import 'package:app/features/requests/domain/models/service_request.dart';

class MockArtisanSpaceRepository extends Mock
    implements ArtisanSpaceRepository {}

void main() {
  late MockArtisanSpaceRepository mockRepo;

  const sampleRequest = ServiceRequest(
    id: 'req_1',
    clientId: 'client_1',
    categoryId: 'cat_1',
    title: 'Fuite robinet cuisine',
    description: 'Fuite importante sous évier à Ouaga 2000',
    city: 'Ouagadougou',
    address: 'Ouaga 2000',
    status: 'pending',
  );

  const sampleQuote = Quote(
    id: 'q_1',
    requestId: 'req_1',
    artisanId: 'art_1',
    amount: 15000,
    estimatedDays: 1,
    message: 'Disponible demain matin',
  );

  const sampleArtisan = Artisan(
    id: 'art_1',
    userId: 'user_1',
    fullName: 'Moussa Kaboré',
    specialty: 'Plombier Sanitaire',
    city: 'Ouagadougou',
    experienceYears: 7,
    rating: 4.8,
    completedJobs: 42,
    isVerified: true,
  );

  setUp(() {
    mockRepo = MockArtisanSpaceRepository();
  });

  group('ArtisanJobsBloc', () {
    blocTest<ArtisanJobsBloc, ArtisanJobsState>(
      'emits [ArtisanJobsLoading, ArtisanJobsLoaded] when requests load',
      build: () {
        when(() => mockRepo.getRequests(status: 'pending')).thenAnswer(
          (_) async => const Success([sampleRequest]),
        );
        return ArtisanJobsBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const LoadArtisanRequests(status: 'pending')),
      expect: () => [
        ArtisanJobsLoading(),
        const ArtisanJobsLoaded(
          requests: [sampleRequest],
          activeStatus: 'pending',
        ),
      ],
    );

    blocTest<ArtisanJobsBloc, ArtisanJobsState>(
      'emits [ArtisanJobsLoading, ArtisanJobsEmpty] when list is empty',
      build: () {
        when(() => mockRepo.getRequests(status: 'pending')).thenAnswer(
          (_) async => const Success([]),
        );
        return ArtisanJobsBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const LoadArtisanRequests(status: 'pending')),
      expect: () => [
        ArtisanJobsLoading(),
        const ArtisanJobsEmpty(activeStatus: 'pending'),
      ],
    );

    blocTest<ArtisanJobsBloc, ArtisanJobsState>(
      'emits [ArtisanJobsLoading, ArtisanJobsError] when repository fails',
      build: () {
        when(() => mockRepo.getRequests(status: 'pending')).thenAnswer(
          (_) async => const FailureResult(NetworkFailure('Pas de connexion')),
        );
        return ArtisanJobsBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const LoadArtisanRequests(status: 'pending')),
      expect: () => [
        ArtisanJobsLoading(),
        const ArtisanJobsError('Pas de connexion'),
      ],
    );

    blocTest<ArtisanJobsBloc, ArtisanJobsState>(
      'submits quote and emits success notification',
      build: () {
        when(() => mockRepo.submitQuote(
              requestId: 'req_1',
              amount: 15000,
              estimatedDays: 1,
              message: 'Disponible demain matin',
            )).thenAnswer((_) async => const Success(sampleQuote));
        return ArtisanJobsBloc(repository: mockRepo);
      },
      seed: () => const ArtisanJobsLoaded(requests: [sampleRequest]),
      act: (bloc) => bloc.add(
        const SubmitQuoteRequested(
          requestId: 'req_1',
          amount: 15000,
          estimatedDays: 1,
          message: 'Disponible demain matin',
        ),
      ),
      expect: () => [
        const ArtisanJobsLoaded(
          requests: [sampleRequest],
          isSubmittingQuote: true,
        ),
        const ArtisanJobsLoaded(
          requests: [sampleRequest],
          isSubmittingQuote: false,
          notificationMessage: 'Devis de 15000 F CFA envoyé avec succès',
        ),
      ],
    );

    blocTest<ArtisanJobsBloc, ArtisanJobsState>(
      'optimistic status update rolls back on server failure',
      build: () {
        when(() => mockRepo.updateRequestStatus('req_1', 'completed'))
            .thenAnswer(
          (_) async => const FailureResult(ServerFailure('Accès refusé')),
        );
        return ArtisanJobsBloc(repository: mockRepo);
      },
      seed: () => const ArtisanJobsLoaded(requests: [sampleRequest]),
      act: (bloc) => bloc.add(
        const UpdateMissionStatusOptimistic(
          requestId: 'req_1',
          newStatus: 'completed',
        ),
      ),
      expect: () => [
        ArtisanJobsLoaded(
          requests: [sampleRequest.copyWith(status: 'completed')],
          notificationMessage: 'Statut mis à jour',
        ),
        const ArtisanJobsLoaded(
          requests: [sampleRequest],
          errorBanner: 'Échec de mise à jour : Accès refusé',
        ),
      ],
    );
  });

  group('ArtisanProfileBloc', () {
    blocTest<ArtisanProfileBloc, ArtisanProfileState>(
      'emits [ArtisanProfileLoading, ArtisanProfileLoaded] on load',
      build: () {
        when(() => mockRepo.getArtisanProfile('art_1')).thenAnswer(
          (_) async => const Success(sampleArtisan),
        );
        return ArtisanProfileBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const LoadArtisanProfile('art_1')),
      expect: () => [
        ArtisanProfileLoading(),
        const ArtisanProfileLoaded(sampleArtisan),
      ],
    );

    blocTest<ArtisanProfileBloc, ArtisanProfileState>(
      'updates profile and emits feedback message',
      build: () {
        when(() => mockRepo.updateArtisanProfile(
              artisanId: 'art_1',
              specialty: 'Plombier & Chauffagiste',
              city: null,
              experienceYears: null,
              bio: null,
              availability: null,
            )).thenAnswer(
          (_) async => const Success(
            Artisan(
              id: 'art_1',
              userId: 'user_1',
              fullName: 'Moussa Kaboré',
              specialty: 'Plombier & Chauffagiste',
              city: 'Ouagadougou',
              experienceYears: 7,
              rating: 4.8,
              completedJobs: 42,
              isVerified: true,
            ),
          ),
        );
        return ArtisanProfileBloc(repository: mockRepo);
      },
      seed: () => const ArtisanProfileLoaded(sampleArtisan),
      act: (bloc) => bloc.add(
        const UpdateArtisanProfileSubmitted(
          artisanId: 'art_1',
          specialty: 'Plombier & Chauffagiste',
        ),
      ),
      expect: () => [
        const ArtisanProfileLoaded(sampleArtisan, isUpdating: true),
        const ArtisanProfileLoaded(
          Artisan(
            id: 'art_1',
            userId: 'user_1',
            fullName: 'Moussa Kaboré',
            specialty: 'Plombier & Chauffagiste',
            city: 'Ouagadougou',
            experienceYears: 7,
            rating: 4.8,
            completedJobs: 42,
            isVerified: true,
          ),
          feedbackMessage: 'Profil artisan mis à jour',
        ),
      ],
    );
  });
}
