import 'dart:async';

import 'package:tasky/presentation/widgets/stream_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void _snapshotCbk(BuildContext context, AsyncSnapshot<String> snapshot) {
  print(snapshot.toString());
}

void main() {
  group("StreamListener Tests", () {
    testWidgets("gracefully handles transition from null stream",
        (WidgetTester tester) async {
      final GlobalKey key = GlobalKey();
      await tester.pumpWidget(
        StreamListener<String>(
          key: key,
          stream: null,
          listener: _snapshotCbk,
          child: Container(),
        ),
      );
      prints("AsyncSnapshot<String>(ConnectionState.none, null, null)");

      // ignore: close_sinks
      final StreamController<String> controller = StreamController<String>();
      await tester.pumpWidget(
        StreamListener<String>(
          key: key,
          stream: controller.stream,
          listener: _snapshotCbk,
          child: Container(),
        ),
      );
      prints("AsyncSnapshot<String>(ConnectionState.waiting, null, null)");
    });

    testWidgets("gracefully handles transition to null stream",
        (WidgetTester tester) async {
      final GlobalKey key = GlobalKey();
      // ignore: close_sinks
      final StreamController<String> controller = StreamController<String>();
      await tester.pumpWidget(
        StreamListener<String>(
          key: key,
          stream: controller.stream,
          listener: _snapshotCbk,
          child: Container(),
        ),
      );
      prints("AsyncSnapshot<String>(ConnectionState.waiting, null, null)");
      await tester.pumpWidget(
        StreamListener<String>(
          key: key,
          stream: null,
          listener: _snapshotCbk,
          child: Container(),
        ),
      );
      prints("AsyncSnapshot<String>(ConnectionState.none, null, null)");
    });

    testWidgets("gracefully handles transition to other stream",
        (WidgetTester tester) async {
      final GlobalKey key = GlobalKey();
      // ignore: close_sinks
      final StreamController<String> controllerA = StreamController<String>();
      // ignore: close_sinks
      final StreamController<String> controllerB = StreamController<String>();
      await tester.pumpWidget(
        StreamListener<String>(
          key: key,
          stream: controllerA.stream,
          listener: _snapshotCbk,
          child: Container(),
        ),
      );
      prints("AsyncSnapshot<String>(ConnectionState.waiting, null, null)");
      await tester.pumpWidget(
        StreamListener<String>(
          key: key,
          stream: controllerB.stream,
          listener: _snapshotCbk,
          child: Container(),
        ),
      );
      controllerB.add('B');
      controllerA.add('A');
      await tester.pump(Duration.zero);
      prints("AsyncSnapshot<String>(ConnectionState.active, B, null)");
    });

    testWidgets("tracks events and errors of stream until completion",
        (WidgetTester tester) async {
      final GlobalKey key = GlobalKey();
      final StreamController<String> controller = StreamController<String>();
      await tester.pumpWidget(
        StreamListener<String>(
          key: key,
          stream: controller.stream,
          listener: _snapshotCbk,
          child: Container(),
        ),
      );
      prints("AsyncSnapshot<String>(ConnectionState.waiting, null, null)");
      controller.add('1');
      controller.add('2');
      await tester.pump(Duration.zero);
      prints("AsyncSnapshot<String>(ConnectionState.active, 2, null)");
      controller.add('3');
      controller.addError('bad');
      await tester.pump(Duration.zero);
      prints("AsyncSnapshot<String>(ConnectionState.active, null, bad)");
      controller.add('4');
      controller.close();
      await tester.pump(Duration.zero);
      prints("AsyncSnapshot<String>(ConnectionState.done, 4, null)");
    });

    testWidgets("runs the builder using given initial data",
        (WidgetTester tester) async {
      // ignore: close_sinks
      final StreamController<String> controller = StreamController<String>();
      await tester.pumpWidget(StreamListener<String>(
        stream: controller.stream,
        listener: _snapshotCbk,
        child: Container(),
        initialData: 'I',
      ));
      prints("AsyncSnapshot<String>(ConnectionState.waiting, I, null)");
    });

    testWidgets("ignores initialData when reconfiguring",
        (WidgetTester tester) async {
      final GlobalKey key = GlobalKey();
      await tester.pumpWidget(StreamListener<String>(
        key: key,
        stream: null,
        listener: _snapshotCbk,
        child: Container(),
        initialData: 'I',
      ));
      prints("AsyncSnapshot<String>(ConnectionState.none, I, null)");
      // ignore: close_sinks
      final StreamController<String> controller = StreamController<String>();
      await tester.pumpWidget(StreamListener<String>(
        key: key,
        stream: controller.stream,
        listener: _snapshotCbk,
        child: Container(),
        initialData: 'Ignored',
      ));
      prints("AsyncSnapshot<String>(ConnectionState.waiting, I, null)");
    });
  });
}
