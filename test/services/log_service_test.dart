import 'package:aspdm_project/services/log_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // NOTE: Those tests will always succeed. When run those tests will print
  // the logs to the console to demonstrate how the original logs will be.
  group("LogService Tests", () {
    LogService service;

    setUpAll(() {
      service = LogService();
    });

    test("verbose logs", () {
      service.verbose("mock text");
      service.verbose("mock text", Exception("mock exception"));
      service.verbose({
        "mock 1": 1,
        "mock 2": 2,
        "mock 3": 3,
      }, Exception("mock exception"));
      service.verbose(
          "mock text", Exception("mock exception"), StackTrace.current);
    });

    test("debug logs", () {
      service.debug("mock text");
      service.debug("mock text", Exception("mock exception"));
      service.debug({
        "mock 1": 1,
        "mock 2": 2,
        "mock 3": 3,
      }, Exception("mock exception"));
      service.debug(
          "mock text", Exception("mock exception"), StackTrace.current);
    });

    test("info logs", () {
      service.info("mock text");
      service.info("mock text", Exception("mock exception"));
      service.info({
        "mock 1": 1,
        "mock 2": 2,
        "mock 3": 3,
      }, Exception("mock exception"));
      service.info(
          "mock text", Exception("mock exception"), StackTrace.current);
    });

    test("warning logs", () {
      service.warning("mock text");
      service.warning("mock text", Exception("mock exception"));
      service.warning({
        "mock 1": 1,
        "mock 2": 2,
        "mock 3": 3,
      }, Exception("mock exception"));
      service.warning(
          "mock text", Exception("mock exception"), StackTrace.current);
    });

    test("error logs", () {
      service.error("mock text");
      service.error("mock text", Exception("mock exception"));
      service.error({
        "mock 1": 1,
        "mock 2": 2,
        "mock 3": 3,
      }, Exception("mock exception"));
      service.error(
          "mock text", Exception("mock exception"), StackTrace.current);
    });

    test("wtf logs", () {
      service.wtf("mock text");
      service.wtf("mock text", Exception("mock exception"));
      service.wtf({
        "mock 1": 1,
        "mock 2": 2,
        "mock 3": 3,
      }, Exception("mock exception"));
      service.wtf("mock text", Exception("mock exception"), StackTrace.current);
    });

    test("widget build logs", () {
      service.logBuild("mock class name");
    });
  });
}
