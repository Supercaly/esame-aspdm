import 'package:tasky/core/maybe.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/services/log_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';

/// Class that manages the dynamic links created and opened
/// by the application.
class LinkService {
  final FirebaseDynamicLinks _dynamicLinks;
  final LogService _logService;
  bool _initialized;

  LinkService({
    @required LogService logService,
  })  : _dynamicLinks = FirebaseDynamicLinks.instance,
        _logService = logService,
        _initialized = false;

  @visibleForTesting
  LinkService.private(
    this._dynamicLinks,
    this._logService,
  ) : _initialized = false;

  /// Initialize the [LinkService].
  Future<void> init({
    @required void Function(Maybe<UniqueId> id) onTaskOpen,
  }) async {
    assert(onTaskOpen != null);

    // If already initialized return immediately
    if (_initialized) return;

    // If the device is web skip the initialization
    if (kIsWeb) {
      _logService
          .warning("LinkService: Dynamic links for web are not supported!");
      return;
    }

    // Catch the link that started the app.
    final data = await _dynamicLinks.getInitialLink();
    if (data != null) onTaskOpen(_taskFromDynamicLink(data));

    // Listen to all links that resume the app from background
    _dynamicLinks.onLink(
      onSuccess: (linkData) async => onTaskOpen(
        _taskFromDynamicLink(linkData),
      ),
    );
    _initialized = true;
  }

  /// Close the [LinkService].
  void close() {
    _initialized = false;
  }

  /// This method will return [Maybe] an [UniqueId] with the task id extracted
  /// from the dynamic link.
  Maybe<UniqueId> _taskFromDynamicLink(PendingDynamicLinkData data) {
    if (data?.link == null) return Maybe.nothing();
    final deepLink = data.link;
    _logService.info("LinkService: handling dynamic link: $deepLink");

    // The received link is for a task
    if (deepLink.pathSegments.first == 'task') {
      final String rawTaskId = deepLink.queryParameters['id'];
      final taskId = UniqueId(rawTaskId);
      if (taskId.value.isRight()) return Maybe.just(taskId);
    }
    return Maybe.nothing();
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
        packageName: "com.supercaly.tasky",
        minimumVersion: 0,
      ),
    );

    final newShortLink = await param.buildShortLink();
    return Maybe.just(newShortLink.shortUrl);
  }
}
