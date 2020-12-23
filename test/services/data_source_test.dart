import 'dart:io';

import 'package:aspdm_project/model/task.dart';
import 'package:aspdm_project/model/user.dart';
import 'package:aspdm_project/services/data_source.dart';
import 'package:aspdm_project/services/log_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_log_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group("Internal requests tests", () {
    Dio dio;
    LogService logService;
    DataSource source;

    setUpAll(() {
      dio = MockDio();
      logService = MockLogService();
      source = DataSource.test(dio, logService);
    });

    tearDownAll(() {
      dio = null;
      logService = null;
      source = null;
    });

    test("call close dispose the http client", () {
      source.close();
      verify(dio.close(force: anyNamed("force"))).called(1);
    });

    test("get returns data", () async {
      when(dio.get(any)).thenAnswer((_) async => Response(data: null));
      final res = await source.get("mock_get_url");

      expect(res, isA<Response<dynamic>>());
    });

    test("get handle errors", () async {
      when(dio.get(any))
          .thenThrow(DioError(response: Response(statusCode: 400)));
      try {
        await source.get("mock_get_url");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<DioError>());
        verify(logService.error(any)).called(1);
      }

      when(dio.get(any)).thenThrow(DioError(error: SocketException("")));
      try {
        await source.get("mock_get_url");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<DioError>());
        verify(logService.error(any)).called(1);
      }
    });

    test("post returns data", () async {
      when(dio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res = await source.post("mock_post_url", {});

      expect(res, isA<Response<dynamic>>());
    });

    test("post handle errors", () async {
      when(dio.post(any, data: anyNamed("data")))
          .thenThrow(DioError(response: Response(statusCode: 400)));
      try {
        await source.post("mock_post_url", {});
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<DioError>());
        verify(logService.error(any)).called(1);
      }

      when(dio.post(any, data: anyNamed("data")))
          .thenThrow(DioError(error: SocketException("")));
      try {
        await source.post("mock_post_url", {});
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<DioError>());
        verify(logService.error(any)).called(1);
      }
    });

    test("patch returns data", () async {
      when(dio.patch(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res = await source.patch("mock_patch_url", {});

      expect(res, isA<Response<dynamic>>());
    });

    test("patch handle errors", () async {
      when(dio.patch(any, data: anyNamed("data")))
          .thenThrow(DioError(response: Response(statusCode: 400)));
      try {
        await source.patch("mock_patch_url", {});
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<DioError>());
        verify(logService.error(any)).called(1);
      }

      when(dio.patch(any, data: anyNamed("data")))
          .thenThrow(DioError(error: SocketException("")));
      try {
        await source.patch("mock_patch_url", {});
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<DioError>());
        verify(logService.error(any)).called(1);
      }
    });

    test("delete returns data", () async {
      when(dio.delete(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res = await source.delete("mock_delete_url", {});

      expect(res, isA<Response<dynamic>>());
    });

    test("delete handle errors", () async {
      when(dio.delete(any, data: anyNamed("data")))
          .thenThrow(DioError(response: Response(statusCode: 400)));
      try {
        await source.delete("mock_delete_url", {});
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<DioError>());
        verify(logService.error(any)).called(1);
      }

      when(dio.delete(any, data: anyNamed("data")))
          .thenThrow(DioError(error: SocketException("")));
      try {
        await source.delete("mock_delete_url", {});
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<DioError>());
        verify(logService.error(any)).called(1);
      }
    });
  });

  group("API methods tests", () {
    Dio dio;
    LogService logService;
    DataSource source;

    setUpAll(() {
      dio = MockDio();
      logService = MockLogService();
      source = DataSource.test(dio, logService);
    });

    tearDownAll(() {
      dio = null;
      logService = null;
      source = null;
    });

    test("authentication works correctly", () async {
      when(dio.post(any, data: anyNamed("data"))).thenAnswer(
        (_) async => Response(
          data: {
            "_id": "mock_id",
            "name": "Mock User",
            "email": "mock@email.com",
            "profile_color": "#FF0000",
          },
        ),
      );
      final res = await source.authenticate("mock@email.com", "mock_password");

      expect(res, isNotNull);
      expect(
        res,
        equals(
          User(
            "mock_id",
            "Mock User",
            "mock@email.com",
            Color(0xFFFF0000),
          ),
        ),
      );

      when(dio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res2 = await source.authenticate("mock@email.com", "mock_password");

      expect(res2, isNull);
    });

    test("list un-archived tasks works correctly", () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: [
            {
              "_id": "mock_task_id",
              "title": "Mock Title",
              "author": {
                "_id": "mock_id",
                "name": "Mock User",
                "email": "mock@email.com",
                "profile_color": "#FF0000",
              },
              "creation_date": "2020-12-22",
            },
          ],
        ),
      );
      final res = await source.getUnarchivedTasks();

      expect(res, isNotNull);
      expect(res, isNotEmpty);
      expect(res, hasLength(1));
      expect(
        res,
        equals(
          [
            Task(
              "mock_task_id",
              "Mock Title",
              null,
              null,
              User(
                "mock_id",
                "Mock User",
                "mock@email.com",
                Color(0xFFFF0000),
              ),
              null,
              null,
              null,
              null,
              false,
              DateTime.parse("2020-12-22"),
            ),
          ],
        ),
      );

      when(dio.get(any)).thenAnswer((_) async => Response(data: null));
      final res2 = await source.getUnarchivedTasks();

      expect(res2, isNull);
    });

    test("list archived tasks works correctly", () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: [
            {
              "_id": "mock_task_id",
              "title": "Mock Title",
              "author": {
                "_id": "mock_id",
                "name": "Mock User",
                "email": "mock@email.com",
                "profile_color": "#FF0000",
              },
              "creation_date": "2020-12-22",
            },
          ],
        ),
      );
      final res = await source.getArchivedTasks();

      expect(res, isNotNull);
      expect(res, isNotEmpty);
      expect(res, hasLength(1));
      expect(
        res,
        equals(
          [
            Task(
              "mock_task_id",
              "Mock Title",
              null,
              null,
              User(
                "mock_id",
                "Mock User",
                "mock@email.com",
                Color(0xFFFF0000),
              ),
              null,
              null,
              null,
              null,
              false,
              DateTime.parse("2020-12-22"),
            ),
          ],
        ),
      );

      when(dio.get(any)).thenAnswer((_) async => Response(data: null));
      final res2 = await source.getArchivedTasks();

      expect(res2, isNull);
    });
  });
}
