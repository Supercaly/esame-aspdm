import 'package:aspdm_project/core/maybe.dart';
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

  /// Initialize the [LinkService].
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

  /// Close the [LinkService].
  void close() {
    _initialized = false;
  }

  /// This method will navigate to [Routes.task] if the link has
  /// a valid task id.
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

  /// Returns a [Uri] with the new sharable link for
  /// the given task.
  Future<Maybe<Uri>> createLinkForPost(Maybe<UniqueId> taskId) async {
    if (kIsWeb) {
      _logService.warning(
          "LinkService: Dynamic link generation for web is not supported!");
      return Maybe.nothing();
    }

    UniqueId taskIdValue = taskId.fold(() => null, (value) => value);
    if (taskIdValue == null || taskIdValue.value.isLeft())
      return Maybe<Uri>.nothing();

    final taskIdStr = taskIdValue.value.getOrNull();
    final param = DynamicLinkParameters(
      uriPrefix: "https://taskyapp.page.link",
      link: Uri.parse("https://aspdm-project.web.app/task?id=$taskIdStr"),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      androidParameters: AndroidParameters(
        packageName: "com.supercaly.aspdm_project",
        minimumVersion: 0,
      ),
    );

    final newShortLink = await param.buildShortLink();
    return Maybe.just(newShortLink.shortUrl);
  }
}
