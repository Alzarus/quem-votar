import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Fabrica de transformador de eventos com debounce e cancelamento de emissoes intermediarias.
///
/// Retarda o processamento do evento pela [duration] informada, descartando
/// eventos intermediarios emitidos durante a janela de resguardo temporal (RF02).
EventTransformer<E> debounceTransformer<E>(Duration duration) {
  return (Stream<E> events, EventMapper<E> mapper) {
    late final StreamController<E> controller;
    Timer? timer;
    StreamSubscription<E>? eventSub;
    StreamSubscription<E>? mappedSub;
    var isDone = false;

    void handleDone() {
      if (isDone && (timer == null || !timer!.isActive) && mappedSub == null) {
        if (!controller.isClosed) {
          controller.close();
        }
      }
    }

    controller = StreamController<E>(
      sync: true,
      onListen: () {
        eventSub = events.listen(
          (event) {
            timer?.cancel();
            timer = Timer(duration, () {
              mappedSub?.cancel();
              mappedSub = mapper(event).listen(
                controller.add,
                onError: controller.addError,
                onDone: () {
                  mappedSub = null;
                  handleDone();
                },
              );
            });
          },
          onError: controller.addError,
          onDone: () {
            isDone = true;
            handleDone();
          },
        );
      },
      onCancel: () {
        timer?.cancel();
        mappedSub?.cancel();
        eventSub?.cancel();
      },
    );

    return controller.stream;
  };
}
