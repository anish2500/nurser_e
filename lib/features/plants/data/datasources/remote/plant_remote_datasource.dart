
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/api/api_client.dart';
import 'package:nurser_e/core/api/api_endpoints.dart';
import 'package:nurser_e/features/plants/data/datasources/plant_datasource.dart';
import 'package:nurser_e/features/plants/data/models/plant_api_model.dart';

final plantRemoteDatasourceProvider = Provider<IPlantRemoteDataSource>((ref) {
  return PlantRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class PlantRemoteDatasource implements IPlantRemoteDataSource {
  final ApiClient _apiClient;

  PlantRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<PlantApiModel>> getAllPlants({String? category}) async {
    final queryParams = <String, dynamic>{};

    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }

    final response = await _apiClient.get(
      ApiEndpoints.plants,
      queryParameters: queryParams,
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as List;
      return data.map((json) => PlantApiModel.fromJson(json)).toList();
    }

    return [];
  }

  @override
  Future<PlantApiModel?> getPlantById(String id) async {
    final response = await _apiClient.get('${ApiEndpoints.plantDetails}/$id');

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return PlantApiModel.fromJson(data);
    }

    return null;
  }
}
