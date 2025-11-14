// lib/features/home/data/dog_api.dart
import '../../../core/api/api_client.dart';

class HomeApi {
  final ApiClient apiClient;

  HomeApi({required this.apiClient});

  /// Fetches a random dog image from Dog CEO API (public).
  Future<String> fetchRandomDogImage() async {
    // Dog CEO has its own host; we can use Dio directly via apiClient.dio.request with full URL
    final resp = await apiClient.dio.get(
      'https://dog.ceo/api/breeds/image/random',
    );
    if (resp.data is Map<String, dynamic> && resp.data['status'] == 'success') {
      return resp.data['message'] as String;
    }
    throw Exception('Failed to load dog image');
  }
}
