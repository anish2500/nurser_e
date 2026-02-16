import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/core/usecases/app.usecase.dart';
import 'package:nurser_e/features/auth/data/repositories/auth_repository.dart';
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';
import 'package:nurser_e/features/auth/domain/repositories/auth_repository.dart';
class UpdateProfileParams extends Equatable {
  final String? fullName;
  final String? username;
  final String? email;
  final File? profilePicture;
  const UpdateProfileParams({
    this.fullName,
    this.username,
    this.email,
    this.profilePicture,
  });
  @override
  List<Object?> get props => [fullName, username, email, profilePicture];
}
final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return UpdateProfileUsecase(repository: repository);
});
class UpdateProfileUsecase implements UsecaseWithParams<AuthEntity, UpdateProfileParams> {
  final IAuthRepository _repository;
  UpdateProfileUsecase({required IAuthRepository repository}) : _repository = repository;
  
  @override
  Future<Either<Failure, AuthEntity>> call(UpdateProfileParams params) {
    return _repository.updateProfile(params);
  }
}