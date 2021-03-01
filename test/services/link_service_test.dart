import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/services/link_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tasky/services/log_service.dart';

import '../mocks/mock_log_service.dart';

class MockFirebaseDynamicLinks extends Mock implements FirebaseDynamicLinks {}

class MockPendingDynamicLinkData extends Mock
    implements PendingDynamicLinkData {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("LinkService test", () {
    LinkService service;
    FirebaseDynamicLinks dynamicLinks;
    PendingDynamicLinkData pendingDynamicLinkData;
    LogService logService;

    setUp(() {
      dynamicLinks = MockFirebaseDynamicLinks();
      logService = MockLogService();
      service = LinkService.private(
        dynamicLinks,
        logService,
      );

      pendingDynamicLinkData = MockPendingDynamicLinkData();
      when(logService).calls(#info).thenReturn();
      when(dynamicLinks)
          .calls(#getInitialLink)
          .thenAnswer((_) async => pendingDynamicLinkData);
      when(dynamicLinks).calls(#onLink).thenReturn();
      when(pendingDynamicLinkData).calls(#link).thenReturn();
    });

    tearDown(() {
      dynamicLinks = null;
      service = null;
    });

    test("calling init multiple times has no effect", () async {
      await service.init(onTaskOpen: (id) {});
      await service.init(onTaskOpen: (id) {});
      verify(dynamicLinks).called(#getInitialLink).once();
    });

    test("null initial message has no effect", () async {
      when(pendingDynamicLinkData).calls(#link).thenReturn(null);
      bool opened = false;
      await service.init(onTaskOpen: (id) => opened = id.isJust());
      expect(opened, isFalse);
    });

    test("incorrect initial message has no effect", () async {
      when(pendingDynamicLinkData)
          .calls(#link)
          .thenReturn(Uri.parse("https://mock.link.com/not_task"));

      bool opened = false;
      await service.init(onTaskOpen: (id) => opened = id.isJust());
      expect(opened, isFalse);
    });

    test("correct initial message fires the on task open callback", () async {
      when(pendingDynamicLinkData)
          .calls(#link)
          .thenReturn(Uri.parse("https://mock.link.com/task?id=mock_task_id"));

      bool opened = false;
      UniqueId taskId;
      await service.init(onTaskOpen: (id) {
        opened = id.isJust();
        taskId = id.getOrNull();
      });
      expect(opened, isTrue);
      expect(taskId, equals(UniqueId("mock_task_id")));
    });

    test("calling close un-initialize the service", () async {
      await service.init(onTaskOpen: (id) {});
      service.close();
      await service.init(onTaskOpen: (id) {});
      verify(dynamicLinks).called(#getInitialLink).times(2);
    });

    test("create link for post returns correctly", () async {
      FirebaseDynamicLinks.channel.setMockMethodCallHandler((call) async {
        if (call.method == "DynamicLinkParameters#buildShortLink")
          return {
            "url": "https://mock.link.com/mock",
            "warnings": null,
          };
      });

      final l1 = await service.createLinkForPost(
        Maybe.just(UniqueId("mock_task_id")),
      );
      expect(l1.isJust(), isTrue);
      expect(l1.getOrNull().toString(), equals("https://mock.link.com/mock"));

      final l2 = await service.createLinkForPost(
        Maybe.nothing(),
      );
      expect(l2.isNothing(), isTrue);

      final l3 = await service.createLinkForPost(
        Maybe.just(UniqueId.empty()),
      );
      expect(l3.isNothing(), isTrue);
    });
  });
}
