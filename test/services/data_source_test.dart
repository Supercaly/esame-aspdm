import 'dart:io';

import 'package:aspdm_project/model/checklist.dart';
import 'package:aspdm_project/model/comment.dart';
import 'package:aspdm_project/model/label.dart';
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

    test("get users works correctly", () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: [
            {
              "_id": "mock_id_1",
              "name": "Mock User 1",
              "email": "mock1@email.com",
              "profile_color": "#FF0000",
            },
            {
              "_id": "mock_id_2",
              "name": "Mock User 2",
              "email": "mock2@email.com",
              "profile_color": "#00FF00",
            }
          ],
        ),
      );
      final res = await source.getUsers();

      expect(res, isNotNull);
      expect(res, isNotEmpty);
      expect(res, hasLength(2));
      expect(
        res,
        equals(
          [
            User(
              "mock_id_1",
              "Mock User 1",
              "mock1@email.com",
              Color(0xFFFF0000),
            ),
            User(
              "mock_id_2",
              "Mock User 2",
              "mock2@email.com",
              Color(0xFF00FF00),
            ),
          ],
        ),
      );

      when(dio.get(any)).thenAnswer((_) async => Response(data: null));
      final res2 = await source.getUsers();

      expect(res2, isNull);
    });

    test("get user works correctly", () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: {
            "_id": "mock_id_1",
            "name": "Mock User 1",
            "email": "mock1@email.com",
            "profile_color": "#FF0000",
          },
        ),
      );
      final res = await source.getUser("mock_id_1");

      expect(res, isNotNull);
      expect(
        res,
        equals(
          User(
            "mock_id_1",
            "Mock User 1",
            "mock1@email.com",
            Color(0xFFFF0000),
          ),
        ),
      );

      when(dio.get(any)).thenAnswer((_) async => Response(data: null));
      final res2 = await source.getUser("mock_id_1");

      expect(res2, isNull);
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

    test("get labels works correctly", () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: [
            {
              "_id": "mock_id_1",
              "label": "Label 1",
              "color": "#FF0000",
            },
            {
              "_id": "mock_id_2",
              "label": "Label 2",
              "color": "#00FF00",
            },
            {
              "_id": "mock_id_3",
              "label": "Label 3",
              "color": "#0000FF",
            },
          ],
        ),
      );
      final res = await source.getLabels();

      expect(res, isNotNull);
      expect(res, isNotEmpty);
      expect(res, hasLength(3));
      expect(
        res,
        equals(
          [
            Label(
              "mock_id_1",
              Color(0xFFFF0000),
              "Label 1",
            ),
            Label(
              "mock_id_2",
              Color(0xFF00FF00),
              "Label 2",
            ),
            Label(
              "mock_id_3",
              Color(0xFF0000FF),
              "Label 3",
            ),
          ],
        ),
      );

      when(dio.get(any)).thenAnswer((_) async => Response(data: null));
      final res2 = await source.getLabels();

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

    test("get tasks works correctly", () async {
      when(dio.get(any)).thenAnswer(
        (_) async => Response(
          data: {
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
        ),
      );
      final res = await source.getTask("mock_task_id");

      expect(res, isNotNull);
      expect(
        res,
        equals(
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
        ),
      );

      when(dio.get(any)).thenAnswer((_) async => Response(data: null));
      final res2 = await source.getTask("mock_task_id");

      expect(res2, isNull);
    });

    test("post task works correctly", () async {
      when(dio.post(any, data: anyNamed("data"))).thenAnswer(
        (_) async => Response(
          data: {
            "_id": "mock_task_id",
            "title": "Mock Title",
            "description": "Mock Description",
            "author": {
              "_id": "mock_id",
              "name": "Mock User",
              "email": "mock@email.com",
              "profile_color": "#FF0000",
            },
            "expire_date": "2021-01-03",
            "creation_date": "2020-12-22",
            "checklists": [
              {
                "_id": "mock_checklist_id",
                "title": "Mock Checklist Title",
                "items": [
                  {
                    "_id": "mock_item_1",
                    "item": "item 1",
                    "complete": false,
                  },
                  {
                    "_id": "mock_item_2",
                    "item": "item 2",
                    "complete": false,
                  },
                  {
                    "_id": "mock_item_3",
                    "item": "item 3",
                    "complete": false,
                  },
                ]
              }
            ]
          },
        ),
      );
      final res = await source.postTask(
        Task(
          null,
          "Mock Title",
          "Mock Description",
          null,
          User(
            "mock_id",
            "Mock User",
            "mock@email.com",
            Color(0xFFFF0000),
          ),
          null,
          DateTime.parse("2021-01-03"),
          [
            Checklist(
              "mock_checklist_id",
              "Mock Checklist Title",
              [
                ChecklistItem("mock_item_1", "item 1", false),
                ChecklistItem("mock_item_2", "item 2", false),
                ChecklistItem("mock_item_3", "item 3", false),
              ],
            ),
          ],
          null,
          false,
          DateTime.parse("2020-12-22"),
        ),
      );

      expect(res, isNotNull);
      expect(
        res,
        equals(
          Task(
            "mock_task_id",
            "Mock Title",
            "Mock Description",
            null,
            User(
              "mock_id",
              "Mock User",
              "mock@email.com",
              Color(0xFFFF0000),
            ),
            null,
            DateTime.parse("2021-01-03"),
            [
              Checklist(
                "mock_checklist_id",
                "Mock Checklist Title",
                [
                  ChecklistItem("mock_item_1", "item 1", false),
                  ChecklistItem("mock_item_2", "item 2", false),
                  ChecklistItem("mock_item_3", "item 3", false),
                ],
              ),
            ],
            null,
            false,
            DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res2 = await source.postTask(
        Task(
          null,
          "Mock Title",
          "Mock Description",
          null,
          User(
            "mock_id",
            "Mock User",
            "mock@email.com",
            Color(0xFFFF0000),
          ),
          null,
          DateTime.parse("2021-01-03"),
          null,
          null,
          false,
          DateTime.parse("2020-12-22"),
        ),
      );

      expect(res2, isNull);
    });

    test("patch task works correctly", () async {
      when(dio.patch(any, data: anyNamed("data"))).thenAnswer(
        (_) async => Response(
          data: {
            "_id": "mock_task_id",
            "title": "Mock Title",
            "description": "Mock Description",
            "author": {
              "_id": "mock_id",
              "name": "Mock User",
              "email": "mock@email.com",
              "profile_color": "#FF0000",
            },
            "expire_date": "2021-01-03",
            "creation_date": "2020-12-22",
          },
        ),
      );
      final res = await source.patchTask(
        Task(
          null,
          "Mock Title",
          "Mock Description",
          null,
          User(
            "mock_id",
            "Mock User",
            "mock@email.com",
            Color(0xFFFF0000),
          ),
          null,
          DateTime.parse("2021-01-03"),
          null,
          null,
          false,
          DateTime.parse("2020-12-22"),
        ),
      );

      expect(res, isNotNull);
      expect(
        res,
        equals(
          Task(
            "mock_task_id",
            "Mock Title",
            "Mock Description",
            null,
            User(
              "mock_id",
              "Mock User",
              "mock@email.com",
              Color(0xFFFF0000),
            ),
            null,
            DateTime.parse("2021-01-03"),
            null,
            null,
            false,
            DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio.patch(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res2 = await source.patchTask(
        Task(
          null,
          "Mock Title",
          "Mock Description",
          null,
          User(
            "mock_id",
            "Mock User",
            "mock@email.com",
            Color(0xFFFF0000),
          ),
          null,
          DateTime.parse("2021-01-03"),
          null,
          null,
          false,
          DateTime.parse("2020-12-22"),
        ),
      );

      expect(res2, isNull);
    });

    test("post comment works correctly", () async {
      when(dio.post(any, data: anyNamed("data"))).thenAnswer(
        (_) async => Response(
          data: {
            "_id": "mock_task_id",
            "title": "Mock Title",
            "author": {
              "_id": "mock_id",
              "name": "Mock User",
              "email": "mock@email.com",
              "profile_color": "#FF0000",
            },
            "creation_date": "2020-12-22",
            "comments": [
              {
                "_id": "mock_comment",
                "content": "mock_content",
                "author": {
                  "_id": "mock_id",
                  "name": "Mock User",
                  "email": "mock@email.com",
                  "profile_color": "#FF0000",
                },
                "like_users": [],
                "dislike_users": [],
                "creation_date": "2020-12-22",
              },
            ]
          },
        ),
      );
      final res = await source.postComment(
        "mock_task_id",
        "mock_user_id",
        "mock_content",
      );

      expect(res, isNotNull);
      expect(
        res,
        equals(
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
            [
              Comment(
                  "mock_comment",
                  "mock_content",
                  User(
                    "mock_id",
                    "Mock User",
                    "mock@email.com",
                    Color(0xFFFF0000),
                  ),
                  [],
                  [],
                  DateTime.parse("2020-12-22"))
            ],
            false,
            DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res2 = await source.postComment(
        "mock_task_id",
        "mock_user_id",
        "mock_content",
      );

      expect(res2, isNull);
    });

    test("delete comment works correctly", () async {
      when(dio.delete(any, data: anyNamed("data"))).thenAnswer(
        (_) async => Response(
          data: {
            "_id": "mock_task_id",
            "title": "Mock Title",
            "author": {
              "_id": "mock_id",
              "name": "Mock User",
              "email": "mock@email.com",
              "profile_color": "#FF0000",
            },
            "creation_date": "2020-12-22",
            "comments": [
              {
                "_id": "mock_comment",
                "content": "mock_content",
                "author": {
                  "_id": "mock_id",
                  "name": "Mock User",
                  "email": "mock@email.com",
                  "profile_color": "#FF0000",
                },
                "like_users": [],
                "dislike_users": [],
                "creation_date": "2020-12-22",
              },
            ]
          },
        ),
      );
      final res = await source.deleteComment(
        "mock_task_id",
        "mock_comment_id",
        "mock_user_id",
      );

      expect(res, isNotNull);
      expect(
        res,
        equals(
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
            [
              Comment(
                  "mock_comment",
                  "mock_content",
                  User(
                    "mock_id",
                    "Mock User",
                    "mock@email.com",
                    Color(0xFFFF0000),
                  ),
                  [],
                  [],
                  DateTime.parse("2020-12-22"))
            ],
            false,
            DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio.delete(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res2 = await source.deleteComment(
        "mock_task_id",
        "mock_comment_id",
        "mock_user_id",
      );

      expect(res2, isNull);
    });

    test("patch comment works correctly", () async {
      when(dio.patch(any, data: anyNamed("data"))).thenAnswer(
        (_) async => Response(
          data: {
            "_id": "mock_task_id",
            "title": "Mock Title",
            "author": {
              "_id": "mock_id",
              "name": "Mock User",
              "email": "mock@email.com",
              "profile_color": "#FF0000",
            },
            "creation_date": "2020-12-22",
            "comments": [
              {
                "_id": "mock_comment",
                "content": "mock_content",
                "author": {
                  "_id": "mock_id",
                  "name": "Mock User",
                  "email": "mock@email.com",
                  "profile_color": "#FF0000",
                },
                "like_users": [],
                "dislike_users": [],
                "creation_date": "2020-12-22",
              },
            ]
          },
        ),
      );
      final res = await source.patchComment(
        "mock_task_id",
        "mock_comment_id",
        "mock_user_id",
        "mock_content",
      );

      expect(res, isNotNull);
      expect(
        res,
        equals(
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
            [
              Comment(
                  "mock_comment",
                  "mock_content",
                  User(
                    "mock_id",
                    "Mock User",
                    "mock@email.com",
                    Color(0xFFFF0000),
                  ),
                  [],
                  [],
                  DateTime.parse("2020-12-22"))
            ],
            false,
            DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio.patch(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res2 = await source.patchComment(
        "mock_task_id",
        "mock_comment_id",
        "mock_user_id",
        "mock_content",
      );

      expect(res2, isNull);
    });

    test("like comment works correctly", () async {
      when(dio.post(any, data: anyNamed("data"))).thenAnswer(
        (_) async => Response(
          data: {
            "_id": "mock_task_id",
            "title": "Mock Title",
            "author": {
              "_id": "mock_id",
              "name": "Mock User",
              "email": "mock@email.com",
              "profile_color": "#FF0000",
            },
            "creation_date": "2020-12-22",
            "comments": [
              {
                "_id": "mock_comment",
                "content": "mock_content",
                "author": {
                  "_id": "mock_id",
                  "name": "Mock User",
                  "email": "mock@email.com",
                  "profile_color": "#FF0000",
                },
                "like_users": [
                  {
                    "_id": "mock_id",
                    "name": "Mock User",
                    "email": "mock@email.com",
                    "profile_color": "#FF0000",
                  },
                ],
                "dislike_users": [],
                "creation_date": "2020-12-22",
              },
            ]
          },
        ),
      );
      final res = await source.likeComment(
        "mock_task_id",
        "mock_comment_id",
        "mock_user_id",
      );

      expect(res, isNotNull);
      expect(
        res,
        equals(
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
            [
              Comment(
                  "mock_comment",
                  "mock_content",
                  User(
                    "mock_id",
                    "Mock User",
                    "mock@email.com",
                    Color(0xFFFF0000),
                  ),
                  [
                    User(
                      "mock_id",
                      "Mock User",
                      "mock@email.com",
                      Color(0xFFFF0000),
                    ),
                  ],
                  [],
                  DateTime.parse("2020-12-22"))
            ],
            false,
            DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res2 = await source.likeComment(
        "mock_task_id",
        "mock_comment_id",
        "mock_user_id",
      );

      expect(res2, isNull);
    });

    test("dislike comment works correctly", () async {
      when(dio.post(any, data: anyNamed("data"))).thenAnswer(
        (_) async => Response(
          data: {
            "_id": "mock_task_id",
            "title": "Mock Title",
            "author": {
              "_id": "mock_id",
              "name": "Mock User",
              "email": "mock@email.com",
              "profile_color": "#FF0000",
            },
            "creation_date": "2020-12-22",
            "comments": [
              {
                "_id": "mock_comment",
                "content": "mock_content",
                "author": {
                  "_id": "mock_id",
                  "name": "Mock User",
                  "email": "mock@email.com",
                  "profile_color": "#FF0000",
                },
                "like_users": [],
                "dislike_users": [
                  {
                    "_id": "mock_id",
                    "name": "Mock User",
                    "email": "mock@email.com",
                    "profile_color": "#FF0000",
                  },
                ],
                "creation_date": "2020-12-22",
              },
            ]
          },
        ),
      );
      final res = await source.dislikeComment(
        "mock_task_id",
        "mock_comment_id",
        "mock_user_id",
      );

      expect(res, isNotNull);
      expect(
        res,
        equals(
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
            [
              Comment(
                  "mock_comment",
                  "mock_content",
                  User(
                    "mock_id",
                    "Mock User",
                    "mock@email.com",
                    Color(0xFFFF0000),
                  ),
                  [],
                  [
                    User(
                      "mock_id",
                      "Mock User",
                      "mock@email.com",
                      Color(0xFFFF0000),
                    ),
                  ],
                  DateTime.parse("2020-12-22"))
            ],
            false,
            DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res2 = await source.dislikeComment(
        "mock_task_id",
        "mock_comment_id",
        "mock_user_id",
      );

      expect(res2, isNull);
    });

    test("archive works correctly", () async {
      when(dio.post(any, data: anyNamed("data"))).thenAnswer(
        (_) async => Response(
          data: {
            "_id": "mock_task_id",
            "title": "Mock Title",
            "author": {
              "_id": "mock_id",
              "name": "Mock User",
              "email": "mock@email.com",
              "profile_color": "#FF0000",
            },
            "creation_date": "2020-12-22",
            "comments": [],
            "archived": true,
          },
        ),
      );
      final res = await source.archive(
        "mock_task_id",
        "mock_user_id",
        true,
      );

      expect(res, isNotNull);
      expect(
        res,
        equals(
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
            [],
            true,
            DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res2 = await source.archive(
        "mock_task_id",
        "mock_user_id",
        true,
      );

      expect(res2, isNull);
    });

    test("check works correctly", () async {
      when(dio.post(any, data: anyNamed("data"))).thenAnswer(
        (_) async => Response(
          data: {
            "_id": "mock_task_id",
            "title": "Mock Title",
            "author": {
              "_id": "mock_id",
              "name": "Mock User",
              "email": "mock@email.com",
              "profile_color": "#FF0000",
            },
            "creation_date": "2020-12-22",
            "checklists": [
              {
                "_id": "mock_checklist_id",
                "title": "mock checklist title",
                "items": [
                  {
                    "_id": "mock_item_id",
                    "item": "item 1",
                    "complete": true,
                  },
                ],
              },
            ],
          },
        ),
      );
      final res = await source.check(
        "mock_task_id",
        "mock_user_id",
        "mock_checklist__id",
        "mock_item_id",
        true,
      );

      expect(res, isNotNull);
      expect(
        res,
        equals(
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
            [
              Checklist(
                "mock_checklist_id",
                "mock checklist title",
                [
                  ChecklistItem(
                    "mock_item_id",
                    "item 1",
                    true,
                  )
                ],
              ),
            ],
            null,
            false,
            DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res2 = await source.check(
        "mock_task_id",
        "mock_user_id",
        "mock_checklist__id",
        "mock_item__id",
        true,
      );

      expect(res2, isNull);
    });

    test("get user throws an error with null parameters", () async {
      try {
        await source.getUser(null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("get task throws an error with null parameters", () async {
      try {
        await source.getTask(null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("archive throws an error with null parameters", () async {
      try {
        await source.archive(null, "userId", true);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.archive("taskId", null, true);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.archive("taskId", "userId", null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("post task throws an error with null parameters", () async {
      try {
        await source.postTask(null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("patch task throws an error with null parameters", () async {
      try {
        await source.patchTask(null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("post comment throws an error with null parameters", () async {
      try {
        await source.postComment(null, "userId", "content");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.postComment("taskId", null, "content");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.postComment("taskId", "userId", null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("delete comment throws an error with null parameters", () async {
      try {
        await source.deleteComment(null, "commentId", "userId");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.deleteComment("taskId", null, "content");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.deleteComment("taskId", "commentId", null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("patch comment throws an error with null parameters", () async {
      try {
        await source.patchComment(null, "commentId", "userId", "content");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.patchComment("taskId", null, "userId", "content");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.patchComment("taskId", "commentId", null, "content");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.patchComment("taskId", "commentId", "userId", null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("like comment throws an error with null parameters", () async {
      try {
        await source.likeComment(null, "commentId", "userId");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.likeComment("taskId", null, "content");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.likeComment("taskId", "commentId", null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("dislike comment throws an error with null parameters", () async {
      try {
        await source.dislikeComment(null, "commentId", "userId");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.dislikeComment("taskId", null, "content");
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.dislikeComment("taskId", "commentId", null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("check throws an error with null parameters", () async {
      try {
        await source.check(null, "userId", "checklistId", "itemId", true);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.check("taskId", null, "checklistId", "itemId", true);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.check("taskId", "userId", null, "itemId", true);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.check("taskId", "userId", "checklistId", null, true);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.check("taskId", "userId", "checklistId", "itemId", null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });
  });
}
