import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:nurser_e/core/constants/hive_table_constant.dart';
import 'package:nurser_e/features/auth/data/models/auth_hive_model.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationCacheDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapter();
    await openBoxes();
  }

  void _registerAdapter() {
    // Registering Auth Adapter
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    
    // If you have Batch or other features later, register them here
  }

  Future<void> openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }

  Future<void> close() async {
    await Hive.close();
  }

  // Helper getter for Auth Box
  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  // ======================== AUTH QUERIES ========================== //

  /// Register a new user
  Future<void> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
  }

  /// Login user by checking credentials
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final users = _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );
    return users.isNotEmpty ? users.first : null;
  }

  /// Get user by their Unique ID (authId)
  Future<AuthHiveModel?> getUserById(String authId) async {
    return _authBox.get(authId);
  }

  /// Get user by email address
  Future<AuthHiveModel?> getUserByEmail(String email) async {
    final users = _authBox.values.where((user) => user.email == email);
    return users.isNotEmpty ? users.first : null;
  }

  /// Update existing user information
  Future<void> updateUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
  }

  /// Delete user from local database
  Future<void> deleteUser(String authId) async {
    await _authBox.delete(authId);
  }

  /// Get currently logged in user details
  Future<AuthHiveModel?> getCurrentUser(String authId) async {
    return _authBox.get(authId);
  }

  /// Check if email is already taken
  bool isEmailExists(String email) {
    return _authBox.values.any((user) => user.email == email);
  }

  /// Local logout (usually handled by session service, but here for completeness)
  Future<void> logoutUser() async {
    // Typically, local database remains, but session is cleared.
    // If you want to wipe local data on logout, use _authBox.clear();
  }
}