import 'package:aspdm_project/core/maybe.dart';
import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/services/link_service.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_log_service.dart';
import '../mocks/mock_navigation_service.dart';

class MockFirebaseDynamicLinks extends Mock implements FirebaseDynamicLinks {}

class MockPendingDynamicLinkData extends Mock
    implements PendingDynamicLinkData {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("LinkService test", () {
    LinkService service;
    NavigationService navigation;
    FirebaseDynamicLinks dynamicLinks;
    PendingDynamicLinkData pendingDynamicLinkData;

    setUp(() {
      navigation = MockNavigationService();
      dynamicLinks = MockFirebaseDynamicLinks();
      service = LinkService.private(
        dynamicLinks,
        navigation,
        MockLogService(),
      );

      pendingDynamicLinkData = MockPendingDynamicLinkData();
      when(dynamicLinks.getInitialLink())
          .thenAnswer((_) async => pendingDynamicLinkData);
    });

    tearDown(() {
      navigation = null;
      dynamicLinks = null;
      service = null;
    });

    test("calling init multiple times has no effect", () async {
      await service.init();
      await service.init();
      verify(dynamicLinks.getInitialLink()).called(1);
    });

    test("null initial message has no effect", () async {
      when(pendingDynamicLinkData.link).thenReturn(null);
      await service.init();
      verifyNever(navigation.navigateTo(any, arguments: anyNamed("arguments")));
    });

    test("incorrect initial message has no effect", () async {
      when(pendingDynamicLinkData.link)
          .thenReturn(Uri.parse("https://mock.link.com/not_task"));

      await service.init();
      verifyNever(navigation.navigateTo(any, arguments: anyNamed("arguments")));
    });

    test("correct initial message navigates to the task page", () async {
      when(pendingDynamicLinkData.link)
          .thenReturn(Uri.parse("https://mock.link.com/task?id=mock_task_id"));

      await service.init();
      verify(navigation.navigateTo(any, arguments: anyNamed("arguments")))
          .called(1);
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

    test("calling close un-initialize the service", () async {
      await service.init();
      service.close();
      await service.init();
      verify(dynamicLinks.getInitialLink()).called(2);
    });
  });
}
