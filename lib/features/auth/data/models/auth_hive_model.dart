import 'package:hive/hive.dart';
import 'package:nurser_e/core/constants/hive_table_constant.dart';
import 'package:nurser_e/features/auth/domain/entities/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String username;

  @HiveField(3)
  final String? password;

  @HiveField(4)
  final String? profilePicture;

  AuthHiveModel({
    String? authId, // this is auto increment so using Uuid
    required this.email,
    required this.username,
    this.password,
    this.profilePicture,
  }) : authId = authId ?? Uuid().v4();

  //From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      email: entity.email,
      username: entity.username,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }

  //To entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      email: email,
      username: username,
      password: password,
      profilePicture: profilePicture,
    );
  }

  //To Entity list
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
