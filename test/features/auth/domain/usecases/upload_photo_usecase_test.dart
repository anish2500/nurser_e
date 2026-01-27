import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/features/auth/domain/repositories/auth_repository.dart';
import 'package:nurser_e/features/auth/domain/usecases/upload_photo_usecase.dart';

// Mocking the repository and File
class MockAuthRepository extends Mock implements IAuthRepository {}
class MockFile extends Mock implements File {}

void main() {
  late UploadPhotoUsecase usecase;
  late MockAuthRepository mockRepository;
  late MockFile mockFile;

  setUpAll(() {
    // Registering MockFile as a fallback for any(File)
    registerFallbackValue(MockFile());
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    mockFile = MockFile();
    usecase = UploadPhotoUsecase(repository: mockRepository);
  });

  const tImageUrl = "https://nurser-e.com/uploads/profile.jpg";

  group('UploadPhotoUsecase', () {
    test('should return image URL String when upload is successful', () async {
      // Arrange
      when(() => mockRepository.uploadImage(any()))
          .thenAnswer((_) async => const Right(tImageUrl));

      // Act
      final result = await usecase(mockFile);

      // Assert
      expect(result, const Right(tImageUrl));
      verify(() => mockRepository.uploadImage(mockFile)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ApiFailure when the server rejects the upload', () async {
      // Arrange
      const failure = ApiFailure(message: 'Invalid image format', statusCode: 400);
      when(() => mockRepository.uploadImage(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(mockFile);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.uploadImage(mockFile)).called(1);
    });

    test('should return NetworkFailure when upload fails due to no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(() => mockRepository.uploadImage(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(mockFile);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.uploadImage(mockFile)).called(1);
    });

    test('should return LocalDatabaseFailure when temporary file access fails', () async {
      // Arrange
      const failure = LocalDatabaseFailure(message: 'Cannot read image file');
      when(() => mockRepository.uploadImage(any()))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(mockFile);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.uploadImage(mockFile)).called(1);
    });
  });
}