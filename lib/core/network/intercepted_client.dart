import 'package:http/http.dart' as http;
import 'network_info.dart';
import 'toast_helper.dart';

class InterceptedClient extends http.BaseClient {
  final http.Client _inner;
  final NetworkInfo _networkInfo;

  InterceptedClient(this._inner, this._networkInfo);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final connected = await _networkInfo.isConnected;
    if (!connected) {
      ToastHelper.showNoInternetToast();
      throw http.ClientException(
        'No Internet Connection. Please check your network and try again.',
        request.url,
      );
    }
    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
