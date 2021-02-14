// @dart=2.9
import 'dart:io';
import 'package:tasky/domain/values/task_values.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:tasky/domain/values/user_values.dart';
import 'package:tasky/infrastructure/models/checklist_model.dart';
import 'package:tasky/infrastructure/models/comment_model.dart';
import 'package:tasky/infrastructure/models/label_model.dart';
import 'package:tasky/infrastructure/models/task_model.dart';
import 'package:tasky/infrastructure/models/user_model.dart';
import 'package:tasky/infrastructure/datasources/remote_data_source.dart';
import 'package:tasky/domain/failures/server_failure.dart';
import 'package:tasky/services/log_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/mock_log_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group("Internal requests tests", () {
    Dio dio;
    LogService logService;
    RemoteDataSource source;

    setUpAll(() {
      dio = MockDio();
      logService = MockLogService();
      source = RemoteDataSource.test(dio, logService);
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

    test("get failure returns the correct server failure", () {
      expect(
        source.getFailure(DioError(
          type: DioErrorType.RESPONSE,
          response: Response(statusCode: 400, data: "error_msg"),
        )),
        equals(ServerFailure.badRequest("error_msg")),
      );
      expect(
        source.getFailure(DioError(
          type: DioErrorType.RESPONSE,
          response: Response(statusCode: 500, data: "error_msg"),
        )),
        equals(ServerFailure.internalError("error_msg")),
      );
      expect(
        source.getFailure(DioError(
          type: DioErrorType.RESPONSE,
          response: Response(statusCode: 404, data: "error_msg"),
        )),
        equals(ServerFailure.unexpectedError("Received status code: 404")),
      );
      expect(
        source.getFailure(DioError(
          type: DioErrorType.DEFAULT,
          error: SocketException(""),
        )),
        equals(ServerFailure.noInternet()),
      );
      expect(
        source.getFailure(DioError(
          type: DioErrorType.DEFAULT,
          error: FormatException("format_exception"),
        )),
        equals(ServerFailure.formatError("format_exception")),
      );
      expect(
        source.getFailure(DioError(type: DioErrorType.CANCEL)),
        equals(ServerFailure.unexpectedError("")),
      );
      expect(
        source.getFailure(DioError(type: DioErrorType.CONNECT_TIMEOUT)),
        equals(ServerFailure.unexpectedError("")),
      );
      expect(
        source.getFailure(DioError(type: DioErrorType.SEND_TIMEOUT)),
        equals(ServerFailure.unexpectedError("")),
      );
      expect(
        source.getFailure(DioError(type: DioErrorType.RECEIVE_TIMEOUT)),
        equals(ServerFailure.unexpectedError("")),
      );
    });

    test("get returns data", () async {
      when(dio.get(any)).thenAnswer((_) async => Response(data: null));
      final res = await source.get("mock_get_url");
      expect(res.isRight(), isTrue);

      when(dio.get(any)).thenThrow(DioError());
      final res2 = await source.get("mock_get_url");
      expect(res2.isLeft(), isTrue);
    });

    test("post returns data", () async {
      when(dio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res = await source.post("mock_post_url", {});
      expect(res.isRight(), isTrue);

      when(dio.post(any, data: anyNamed("data"))).thenThrow(DioError());
      final res2 = await source.post("mock_post_url", {});
      expect(res2.isLeft(), isTrue);
    });

    test("patch returns data", () async {
      when(dio.patch(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res = await source.patch("mock_patch_url", {});
      expect(res.isRight(), isTrue);

      when(dio.patch(any, data: anyNamed("data"))).thenThrow(DioError());
      final res2 = await source.patch("mock_patch_url", {});
      expect(res2.isLeft(), isTrue);
    });

    test("delete returns data", () async {
      when(dio.delete(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res = await source.delete("mock_delete_url", {});
      expect(res.isRight(), isTrue);

      when(dio.delete(any, data: anyNamed("data"))).thenThrow(DioError());
      final res2 = await source.delete("mock_delete_url", {});
      expect(res2.isLeft(), isTrue);
    });
  });

  group("API methods tests", () {
    Dio dio;
    LogService logService;
    RemoteDataSource source;

    setUpAll(() {
      dio = MockDio();
      logService = MockLogService();
      source = RemoteDataSource.test(dio, logService);
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
      final res = (await source.getUsers());
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(res.getOrNull(), isNotEmpty);
      expect(res.getOrNull(), hasLength(2));
      expect(
        res.getOrNull(),
        equals(
          [
            UserModel(
              "mock_id_1",
              "Mock User 1",
              "mock1@email.com",
              Color(0xFFFF0000),
            ),
            UserModel(
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
      expect(res2.isRight(), isTrue);
      expect(res2.getOrNull(), isEmpty);
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
      final res = await source.authenticate(
          EmailAddress("mock@email.com"), Password("mock_password"));
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(
        res.getOrNull(),
        equals(
          UserModel(
            "mock_id",
            "Mock User",
            "mock@email.com",
            Color(0xFFFF0000),
          ),
        ),
      );

      when(dio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res2 = await source.authenticate(
          EmailAddress("mock@email.com"), Password("mock_password"));
      expect(res2.isLeft(), isTrue);
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
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(res.getOrNull(), isNotEmpty);
      expect(res.getOrNull(), hasLength(3));
      expect(
        res.getOrNull(),
        equals(
          [
            LabelModel(
              "mock_id_1",
              Color(0xFFFF0000),
              "Label 1",
            ),
            LabelModel(
              "mock_id_2",
              Color(0xFF00FF00),
              "Label 2",
            ),
            LabelModel(
              "mock_id_3",
              Color(0xFF0000FF),
              "Label 3",
            ),
          ],
        ),
      );

      when(dio.get(any)).thenAnswer((_) async => Response(data: null));
      final res2 = await source.getLabels();
      expect(res2.isRight(), isTrue);
      expect(res2.getOrNull(), isEmpty);
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
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(res.getOrNull(), isNotEmpty);
      expect(res.getOrNull(), hasLength(1));
      expect(
        res.getOrNull(),
        equals(
          [
            TaskModel(
              "mock_task_id",
              "Mock Title",
              null,
              null,
              UserModel(
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
      expect(res2.isRight(), isTrue);
      expect(res2.getOrNull(), isEmpty);
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
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(res.getOrNull(), isNotEmpty);
      expect(res.getOrNull(), hasLength(1));
      expect(
        res.getOrNull(),
        equals(
          [
            TaskModel(
              "mock_task_id",
              "Mock Title",
              null,
              null,
              UserModel(
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
      expect(res2.isRight(), isTrue);
      expect(res2.getOrNull(), isEmpty);
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
      final res = await source.getTask(UniqueId("mock_task_id"));
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(
        res.getOrNull(),
        equals(
          TaskModel(
            "mock_task_id",
            "Mock Title",
            null,
            null,
            UserModel(
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
      final res2 = await source.getTask(UniqueId("mock_task_id"));
      expect(res2.isRight(), isTrue);
      expect(res2.getOrNull(), isNull);
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
        TaskModel(
          null,
          "Mock Title",
          "Mock Description",
          null,
          UserModel(
            "mock_id",
            "Mock User",
            "mock@email.com",
            Color(0xFFFF0000),
          ),
          null,
          DateTime.parse("2021-01-03"),
          [
            ChecklistModel(
              "mock_checklist_id",
              "Mock Checklist Title",
              [
                ChecklistItemModel("mock_item_1", "item 1", false),
                ChecklistItemModel("mock_item_2", "item 2", false),
                ChecklistItemModel("mock_item_3", "item 3", false),
              ],
            ),
          ],
          null,
          false,
          DateTime.parse("2020-12-22"),
        ),
        UniqueId("mock_id"),
      );
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(
        res.getOrNull(),
        equals(
          TaskModel(
            "mock_task_id",
            "Mock Title",
            "Mock Description",
            null,
            UserModel(
              "mock_id",
              "Mock User",
              "mock@email.com",
              Color(0xFFFF0000),
            ),
            null,
            DateTime.parse("2021-01-03"),
            [
              ChecklistModel(
                "mock_checklist_id",
                "Mock Checklist Title",
                [
                  ChecklistItemModel("mock_item_1", "item 1", false),
                  ChecklistItemModel("mock_item_2", "item 2", false),
                  ChecklistItemModel("mock_item_3", "item 3", false),
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
        TaskModel(
          null,
          "Mock Title",
          "Mock Description",
          null,
          UserModel(
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
        UniqueId("mock_id"),
      );
      expect(res2.isLeft(), isTrue);
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
        TaskModel(
          "mock_task_id",
          "Mock Title",
          "Mock Description",
          [
            LabelModel("label_1", Colors.red, "label 1"),
            LabelModel("label_2", Colors.blue, "label 2"),
          ],
          UserModel(
            "mock_id",
            "Mock User",
            "mock@email.com",
            Color(0xFFFF0000),
          ),
          [
            UserModel("user_1", "user 1", "user1@email.com", null),
            UserModel("user_2", "user 2", "user2@email.com", null),
            UserModel("user_3", "user 3", "user3@email.com", null),
          ],
          DateTime.parse("2021-01-03"),
          [
            ChecklistModel(
              "checklist_1",
              "Checklist 1",
              [
                ChecklistItemModel("item_1", "item 1", true),
                ChecklistItemModel("item_2", "item 2", false),
              ],
            ),
            ChecklistModel(
              "checklist_2",
              "Checklist 2",
              [
                ChecklistItemModel("item_1", "item 1", false),
                ChecklistItemModel("item_2", "item 2", true),
              ],
            ),
            ChecklistModel("checklist_3", "Checklist 3", null),
          ],
          null,
          false,
          DateTime.parse("2020-12-22"),
        ),
        UniqueId("mock_id"),
      );
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(
        res.getOrNull(),
        equals(
          TaskModel(
            "mock_task_id",
            "Mock Title",
            "Mock Description",
            null,
            UserModel(
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
        TaskModel(
          "mock_task_id",
          "Mock Title",
          "Mock Description",
          null,
          UserModel(
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
        UniqueId("mock_id"),
      );
      expect(res2.isLeft(), isTrue);
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
        UniqueId("mock_task_id"),
        UniqueId("mock_user_id"),
        CommentContent("mock_content"),
      );
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(
        res.getOrNull(),
        equals(
          TaskModel(
            "mock_task_id",
            "Mock Title",
            null,
            null,
            UserModel(
              "mock_id",
              "Mock User",
              "mock@email.com",
              Color(0xFFFF0000),
            ),
            null,
            null,
            null,
            [
              CommentModel(
                "mock_comment",
                "mock_content",
                UserModel(
                  "mock_id",
                  "Mock User",
                  "mock@email.com",
                  Color(0xFFFF0000),
                ),
                [],
                [],
                DateTime.parse("2020-12-22"),
              )
            ],
            false,
            DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio.post(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res2 = await source.postComment(
        UniqueId("mock_task_id"),
        UniqueId("mock_user_id"),
        CommentContent("mock_content"),
      );
      expect(res2.isLeft(), isTrue);
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
        UniqueId("mock_task_id"),
        UniqueId("mock_comment_id"),
        UniqueId("mock_user_id"),
      );
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(
        res.getOrNull(),
        equals(
          TaskModel(
            "mock_task_id",
            "Mock Title",
            null,
            null,
            UserModel(
              "mock_id",
              "Mock User",
              "mock@email.com",
              Color(0xFFFF0000),
            ),
            null,
            null,
            null,
            [
              CommentModel(
                "mock_comment",
                "mock_content",
                UserModel(
                  "mock_id",
                  "Mock User",
                  "mock@email.com",
                  Color(0xFFFF0000),
                ),
                [],
                [],
                DateTime.parse("2020-12-22"),
              )
            ],
            false,
            DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio.delete(any, data: anyNamed("data")))
          .thenAnswer((_) async => Response(data: null));
      final res2 = await source.deleteComment(
        UniqueId("mock_task_id"),
        UniqueId("mock_comment_id"),
        UniqueId("mock_user_id"),
      );
      expect(res2.isLeft(), isTrue);
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
        UniqueId("mock_task_id"),
        UniqueId("mock_comment_id"),
        UniqueId("mock_user_id"),
        CommentContent("mock_content"),
      );
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(
        res.getOrNull(),
        equals(
          TaskModel(
            "mock_task_id",
            "Mock Title",
            null,
            null,
            UserModel(
              "mock_id",
              "Mock User",
              "mock@email.com",
              Color(0xFFFF0000),
            ),
            null,
            null,
            null,
            [
              CommentModel(
                  "mock_comment",
                  "mock_content",
                  UserModel(
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
        UniqueId("mock_task_id"),
        UniqueId("mock_comment_id"),
        UniqueId("mock_user_id"),
        CommentContent("mock_content"),
      );
      expect(res2.isLeft(), isTrue);
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
        UniqueId("mock_task_id"),
        UniqueId("mock_comment_id"),
        UniqueId("mock_user_id"),
      );
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(
        res.getOrNull(),
        equals(
          TaskModel(
            "mock_task_id",
            "Mock Title",
            null,
            null,
            UserModel(
              "mock_id",
              "Mock User",
              "mock@email.com",
              Color(0xFFFF0000),
            ),
            null,
            null,
            null,
            [
              CommentModel(
                  "mock_comment",
                  "mock_content",
                  UserModel(
                    "mock_id",
                    "Mock User",
                    "mock@email.com",
                    Color(0xFFFF0000),
                  ),
                  [
                    UserModel(
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
        UniqueId("mock_task_id"),
        UniqueId("mock_comment_id"),
        UniqueId("mock_user_id"),
      );
      expect(res2.isLeft(), isTrue);
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
        UniqueId("mock_task_id"),
        UniqueId("mock_comment_id"),
        UniqueId("mock_user_id"),
      );
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(
        res.getOrNull(),
        equals(
          TaskModel(
            "mock_task_id",
            "Mock Title",
            null,
            null,
            UserModel(
              "mock_id",
              "Mock User",
              "mock@email.com",
              Color(0xFFFF0000),
            ),
            null,
            null,
            null,
            [
              CommentModel(
                  "mock_comment",
                  "mock_content",
                  UserModel(
                    "mock_id",
                    "Mock User",
                    "mock@email.com",
                    Color(0xFFFF0000),
                  ),
                  [],
                  [
                    UserModel(
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
        UniqueId("mock_task_id"),
        UniqueId("mock_comment_id"),
        UniqueId("mock_user_id"),
      );
      expect(res2.isLeft(), isTrue);
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
        UniqueId("mock_task_id"),
        UniqueId("mock_user_id"),
        Toggle(true),
      );
      expect(res.isRight(), isTrue);
      expect(
        res.getOrNull(),
        equals(
          TaskModel(
            "mock_task_id",
            "Mock Title",
            null,
            null,
            UserModel(
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
        UniqueId("mock_task_id"),
        UniqueId("mock_user_id"),
        Toggle(true),
      );
      expect(res2.isLeft(), isTrue);
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
        UniqueId("mock_task_id"),
        UniqueId("mock_user_id"),
        UniqueId("mock_checklist__id"),
        UniqueId("mock_item_id"),
        Toggle(true),
      );
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(
        res.getOrNull(),
        equals(
          TaskModel(
            "mock_task_id",
            "Mock Title",
            null,
            null,
            UserModel(
              "mock_id",
              "Mock User",
              "mock@email.com",
              Color(0xFFFF0000),
            ),
            null,
            null,
            [
              ChecklistModel(
                "mock_checklist_id",
                "mock checklist title",
                [
                  ChecklistItemModel(
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
        UniqueId("mock_task_id"),
        UniqueId("mock_user_id"),
        UniqueId("mock_checklist__id"),
        UniqueId("mock_item__id"),
        Toggle(true),
      );
      expect(res2.isLeft(), isTrue);
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
        await source.archive(null, UniqueId("userId"), Toggle(true));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.archive(UniqueId("taskId"), null, Toggle(true));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.archive(UniqueId("taskId"), UniqueId("userId"), null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("post task throws an error with null parameters", () async {
      final res = await source.postTask(null, UniqueId("user_id"));
      expect(res.isLeft(), isTrue);

      try {
        await source.postTask(null, null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      final res2 = await source.postTask(
          TaskModel(
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
          ),
          UniqueId(null));
      expect(res2.isLeft(), isTrue);
    });

    test("patch task throws an error with null parameters", () async {
      final res = await source.patchTask(null, UniqueId("mock_id"));
      expect(res.isLeft(), isTrue);

      try {
        await source.patchTask(null, null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      final res2 = await source.patchTask(
          TaskModel(
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
            null,
          ),
          UniqueId(null));
      expect(res2.isLeft(), isTrue);
    });

    test("post comment throws an error with null parameters", () async {
      try {
        await source.postComment(
            null, UniqueId("userId"), CommentContent("content"));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.postComment(
            UniqueId("taskId"), null, CommentContent("content"));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.postComment(UniqueId("taskId"), UniqueId("userId"), null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("delete comment throws an error with null parameters", () async {
      try {
        await source.deleteComment(
            null, UniqueId("commentId"), UniqueId("userId"));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.deleteComment(
            UniqueId("taskId"), null, UniqueId("userId"));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.deleteComment(
            UniqueId("taskId"), UniqueId("commentId"), null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("patch comment throws an error with null parameters", () async {
      try {
        await source.patchComment(null, UniqueId("commentId"),
            UniqueId("userId"), CommentContent("content"));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.patchComment(UniqueId("taskId"), null, UniqueId("userId"),
            CommentContent("content"));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.patchComment(UniqueId("taskId"), UniqueId("commentId"),
            null, CommentContent("content"));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.patchComment(UniqueId("taskId"), UniqueId("commentId"),
            UniqueId("userId"), null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("like comment throws an error with null parameters", () async {
      try {
        await source.likeComment(
            null, UniqueId("commentId"), UniqueId("userId"));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.likeComment(UniqueId("taskId"), null, UniqueId("userId"));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.likeComment(
            UniqueId("taskId"), UniqueId("commentId"), null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("dislike comment throws an error with null parameters", () async {
      try {
        await source.dislikeComment(
            null, UniqueId("commentId"), UniqueId("userId"));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.dislikeComment(
            UniqueId("taskId"), null, UniqueId("userId"));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.dislikeComment(
            UniqueId("taskId"), UniqueId("commentId"), null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test("check throws an error with null parameters", () async {
      try {
        await source.check(null, UniqueId("userId"), UniqueId("checklistId"),
            UniqueId("itemId"), Toggle(true));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.check(UniqueId("taskId"), null, UniqueId("checklistId"),
            UniqueId("itemId"), Toggle(true));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.check(UniqueId("taskId"), UniqueId("userId"), null,
            UniqueId("itemId"), Toggle(true));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.check(UniqueId("taskId"), UniqueId("userId"),
            UniqueId("checklistId"), null, Toggle(true));
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }

      try {
        await source.check(UniqueId("taskId"), UniqueId("userId"),
            UniqueId("checklistId"), UniqueId("itemId"), null);
        fail("This should throw an exception!");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });
  });
}
