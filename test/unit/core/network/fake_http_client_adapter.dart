import 'dart:typed_data';
import 'package:dio/dio.dart';

/// Implementacao falsa nomeada de HttpClientAdapter para testes headless F.I.R.S.T.
class FakeHttpClientAdapter implements HttpClientAdapter {
  RequestOptions? lastRequestOptions;
  ResponseBody Function(RequestOptions options)? responseHandler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequestOptions = options;
    if (responseHandler != null) {
      return responseHandler!(options);
    }
    return ResponseBody.fromString('{"sucesso": true}', 200);
  }

  @override
  void close({bool force = false}) {}
}
