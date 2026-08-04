import 'package:http/http.dart' as http;
import 'connectivity_service.dart';
import 'intercepted_client.dart';

class AppHttpClient {
  static final ConnectivityServiceImpl connectivityService = ConnectivityServiceImpl();

  static final http.Client client = InterceptedClient(
    http.Client(),
    connectivityService,
  );
}
