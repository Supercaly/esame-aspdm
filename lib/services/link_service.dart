import 'package:aspdm_project/domain/values/unique_id.dart';
import 'package:aspdm_project/presentation/routes.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:aspdm_project/services/navigation_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';

class LinkService {
  final FirebaseDynamicLinks _dynamicLinks;
  final NavigationService _navigationService;
  final LogService _logService;
  bool _initialized;

  LinkService({
    @required NavigationService navigationService,
    @required LogService logService,
  })  : _dynamicLinks = FirebaseDynamicLinks.instance,
        _navigationService = navigationService,
        _logService = logService,
        _initialized = false;

  @visibleForTesting
  LinkService.private(
    this._dynamicLinks,
    this._navigationService,
    this._logService,
  ) : _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    if (kIsWeb) {
      _logService
          .warning("LinkService: Dynamic links for web are not supported!");
      return;
    }

    final data = await _dynamicLinks.getInitialLink();
    await _handleDynamicLink(data);
    _dynamicLinks.onLink(onSuccess: _handleDynamicLink);
    _initialized = true;
  }

  void close() {
    _initialized = false;
  }

  Future<void> _handleDynamicLink(PendingDynamicLinkData data) async {
    if (data?.link == null) return;
    final deepLink = data.link;
    _logService.info("LinkService: handling dynamic link: $deepLink");

    // The received link is for a task
    if (deepLink.pathSegments.first == 'task') {
      final String rawTaskId = deepLink.queryParameters['id'];
      final taskId = UniqueId(rawTaskId);
      _logService.info("LinkService: Open info page for task $taskId");
      if (taskId.value.isRight())
        _navigationService.navigateTo(Routes.task, arguments: taskId);
    }
  }

  /// Returns a [String] with the new sharable link for
  /// the given task.
  Future<String> createLinkForPost(UniqueId taskId) async {
    final param = DynamicLinkParameters(
      uriPrefix: "https://petifytest.page.link",
      link: Uri.parse("https://test-petify.web.app/post?id=$taskId"),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      androidParameters: AndroidParameters(
        packageName: "com.supercaly.petify",
        minimumVersion: 0,
      ),
    );

    final newShortLink = await param.buildShortLink();
    final newLink = newShortLink.shortUrl;

    return newLink.toString();
  }
}
