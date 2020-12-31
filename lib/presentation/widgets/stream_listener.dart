import 'dart:async';

import 'package:flutter/material.dart';

/// Define a callback function called each time the
/// stream emits new data.
typedef StreamWidgetListener<T> = void Function(
  BuildContext context,
  AsyncSnapshot<T> snapshot,
);

/// Widget that builds his [child] and calls [listener]
/// based on the latest snapshot of interaction with
/// a [stream].
class StreamListener<T> extends StatefulWidget {
  /// Callback called each time the [stream] emits new data.
  final StreamWidgetListener<T> listener;

  /// Stream listened by the widget.
  final Stream<T> stream;

  /// The data that will be used to create the initial snapshot.
  final T initialData;

  /// [Widget] built ad a child of this.
  final Widget child;

  StreamListener({
    Key key,
    this.listener,
    this.stream,
    this.initialData,
    this.child,
  }) : super(key: key);

  @override
  _StreamListenerState createState() => _StreamListenerState<T>();
}

class _StreamListenerState<T> extends State<StreamListener<T>> {
  StreamSubscription<T> _subscription;
  AsyncSnapshot<T> _summary;

  @override
  void initState() {
    super.initState();
    _summary = widget.initialData == null
        ? AsyncSnapshot<T>.nothing()
        : AsyncSnapshot.withData(ConnectionState.none, widget.initialData);
    _subscribe();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant StreamListener oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.stream != oldWidget.stream) {
      if (_subscription != null) {
        _unsubscribe();
        _summary = _summary.inState(ConnectionState.none);
        widget.listener?.call(context, _summary);
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;

  void _subscribe() {
    if (widget.stream != null) {
      _subscription = widget.stream.listen((T data) {
        _summary = AsyncSnapshot<T>.withData(ConnectionState.active, data);
        widget.listener?.call(context, _summary);
      }, onError: (Object error) {
        _summary = AsyncSnapshot<T>.withError(ConnectionState.active, error);
        widget.listener?.call(context, _summary);
      }, onDone: () {
        _summary = _summary.inState(ConnectionState.done);
        widget.listener?.call(context, _summary);
      });
      _summary = _summary.inState(ConnectionState.waiting);
      widget.listener?.call(context, _summary);
    }
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
