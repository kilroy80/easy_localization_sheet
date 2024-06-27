import 'package:googleapis_auth/auth_io.dart';

class GoogleAuthClient {
  GoogleAuthClient({
    required this.scopes,
    required this.serviceKey,
  });

  final List<String> scopes;
  final String serviceKey;

  Future<AutoRefreshingAuthClient> client() async {
    if (serviceKey.isEmpty) throw Exception('google service key empty');
    if (scopes.isEmpty) throw Exception('scopes must be provided');

    try {
      final accountCredentials = ServiceAccountCredentials.fromJson(serviceKey);

      AutoRefreshingAuthClient client = await clientViaServiceAccount(
        accountCredentials, scopes,
      );
      return client;
    } catch (e) {
      throw Exception('[Error] credentials google service key');
    }
  }
}