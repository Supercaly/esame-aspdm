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
import 'package:mocktail/mocktail.dart';

import '../../mocks/mock_log_service.dart';

class MockDio extends Mock implements Dio {}

Response<T> testResponse<T>({T data, int statusCode}) => Response<T>(
      data: data,
      statusCode: statusCode,
      request: RequestOptions(path: "mock_request_path"),
    );

void main() {
  group("Internal requests tests", () {
    Dio dio;
    LogService logService;
    RemoteDataSource source;

    setUpAll(() {
      dio = MockDio();
      logService = MockLogService();
      source = RemoteDataSource.test(dio, logService);
      when(logService).calls(#error).thenReturn();
    });

    tearDownAll(() {
      dio = null;
      logService = null;
      source = null;
    });

    test("call close dispose the http client", () {
      when(dio).calls(#close).thenReturn();
      source.close();
      verify(dio).called(#close).once();
    });

    test("get failure returns the correct server failure", () {
      expect(
        source.getFailure(DioError(
          type: DioErrorType.response,
          response: testResponse(statusCode: 400, data: "error_msg"),
        )),
        equals(ServerFailure.badRequest("error_msg")),
      );
      expect(
        source.getFailure(DioError(
          type: DioErrorType.response,
          response: testResponse(statusCode: 500, data: "error_msg"),
        )),
        equals(ServerFailure.internalError("error_msg")),
      );
      expect(
        source.getFailure(DioError(
          type: DioErrorType.response,
          response: testResponse(statusCode: 404, data: "error_msg"),
        )),
        equals(ServerFailure.unexpectedError("Received status code: 404")),
      );
      expect(
        source.getFailure(DioError(
          type: DioErrorType.other,
          error: SocketException(""),
        )),
        equals(ServerFailure.noInternet()),
      );
      expect(
        source.getFailure(DioError(
          type: DioErrorType.other,
          error: FormatException("format_exception"),
        )),
        equals(ServerFailure.formatError("format_exception")),
      );
      expect(
        source.getFailure(DioError(type: DioErrorType.cancel)),
        equals(ServerFailure.unexpectedError("")),
      );
      expect(
        source.getFailure(DioError(type: DioErrorType.connectTimeout)),
        equals(ServerFailure.unexpectedError("")),
      );
      expect(
        source.getFailure(DioError(type: DioErrorType.sendTimeout)),
        equals(ServerFailure.unexpectedError("")),
      );
      expect(
        source.getFailure(DioError(type: DioErrorType.receiveTimeout)),
        equals(ServerFailure.unexpectedError("")),
      );
    });

    test("get returns data", () async {
      when(dio).calls(#get).thenAnswer((_) async => testResponse());
      final res = await source.get("mock_get_url");
      expect(res.isRight(), isTrue);

      when(dio).calls(#get).thenThrow(DioError());
      final res2 = await source.get("mock_get_url");
      expect(res2.isLeft(), isTrue);
    });

    test("post returns data", () async {
      when(dio).calls(#post).thenAnswer((_) async => testResponse());
      final res = await source.post("mock_post_url", {});
      expect(res.isRight(), isTrue);

      when(dio).calls(#post).thenThrow(DioError());
      final res2 = await source.post("mock_post_url", {});
      expect(res2.isLeft(), isTrue);
    });

    test("patch returns data", () async {
      when(dio).calls(#patch).thenAnswer((_) async => testResponse());
      final res = await source.patch("mock_patch_url", {});
      expect(res.isRight(), isTrue);

      when(dio).calls(#patch).thenThrow(DioError());
      final res2 = await source.patch("mock_patch_url", {});
      expect(res2.isLeft(), isTrue);
    });

    test("delete returns data", () async {
      when(dio).calls(#delete).thenAnswer((_) async => testResponse());
      final res = await source.delete("mock_delete_url", {});
      expect(res.isRight(), isTrue);

      when(dio).calls(#delete).thenThrow(DioError());
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
      when(dio).calls(#get).thenAnswer(
            (_) async => testResponse(
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
              id: "mock_id_1",
              name: "Mock User 1",
              email: "mock1@email.com",
              profileColor: Color(0xFFFF0000),
            ),
            UserModel(
              id: "mock_id_2",
              name: "Mock User 2",
              email: "mock2@email.com",
              profileColor: Color(0xFF00FF00),
            ),
          ],
        ),
      );

      when(dio).calls(#get).thenAnswer((_) async => testResponse());
      final res2 = await source.getUsers();
      expect(res2.isRight(), isTrue);
      expect(res2.getOrNull(), isEmpty);
    });

    test("authentication works correctly", () async {
      when(dio).calls(#post).thenAnswer(
            (_) async => testResponse(
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
            id: "mock_id",
            name: "Mock User",
            email: "mock@email.com",
            profileColor: Color(0xFFFF0000),
          ),
        ),
      );

      when(dio).calls(#post).thenAnswer((_) async => testResponse());
      final res2 = await source.authenticate(
          EmailAddress("mock@email.com"), Password("mock_password"));
      expect(res2.isLeft(), isTrue);
    });

    test("get labels works correctly", () async {
      when(dio).calls(#get).thenAnswer(
            (_) async => testResponse(
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
              id: "mock_id_1",
              color: Color(0xFFFF0000),
              label: "Label 1",
            ),
            LabelModel(
              id: "mock_id_2",
              color: Color(0xFF00FF00),
              label: "Label 2",
            ),
            LabelModel(
              id: "mock_id_3",
              color: Color(0xFF0000FF),
              label: "Label 3",
            ),
          ],
        ),
      );

      when(dio).calls(#get).thenAnswer((_) async => testResponse());
      final res2 = await source.getLabels();
      expect(res2.isRight(), isTrue);
      expect(res2.getOrNull(), isEmpty);
    });

    test("list un-archived tasks works correctly", () async {
      when(dio).calls(#get).thenAnswer(
            (_) async => testResponse(
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
              id: "mock_task_id",
              title: "Mock Title",
              description: null,
              labels: null,
              author: UserModel(
                id: "mock_id",
                name: "Mock User",
                email: "mock@email.com",
                profileColor: Color(0xFFFF0000),
              ),
              members: null,
              checklists: null,
              comments: null,
              expireDate: null,
              archived: false,
              creationDate: DateTime.parse("2020-12-22"),
            ),
          ],
        ),
      );

      when(dio).calls(#get).thenAnswer((_) async => testResponse());
      final res2 = await source.getUnarchivedTasks();
      expect(res2.isRight(), isTrue);
      expect(res2.getOrNull(), isEmpty);
    });

    test("list archived tasks works correctly", () async {
      when(dio).calls(#get).thenAnswer(
            (_) async => testResponse(
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
              id: "mock_task_id",
              title: "Mock Title",
              description: null,
              labels: null,
              author: UserModel(
                id: "mock_id",
                name: "Mock User",
                email: "mock@email.com",
                profileColor: Color(0xFFFF0000),
              ),
              members: null,
              checklists: null,
              comments: null,
              expireDate: null,
              archived: false,
              creationDate: DateTime.parse("2020-12-22"),
            ),
          ],
        ),
      );

      when(dio).calls(#get).thenAnswer((_) async => testResponse());
      final res2 = await source.getArchivedTasks();
      expect(res2.isRight(), isTrue);
      expect(res2.getOrNull(), isEmpty);
    });

    test("get tasks works correctly", () async {
      when(dio).calls(#get).thenAnswer(
            (_) async => testResponse(
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
            id: "mock_task_id",
            title: "Mock Title",
            description: null,
            labels: null,
            author: UserModel(
              id: "mock_id",
              name: "Mock User",
              email: "mock@email.com",
              profileColor: Color(0xFFFF0000),
            ),
            members: null,
            checklists: null,
            comments: null,
            expireDate: null,
            archived: false,
            creationDate: DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio).calls(#get).thenAnswer((_) async => testResponse());
      final res2 = await source.getTask(UniqueId("mock_task_id"));
      expect(res2.isRight(), isTrue);
      expect(res2.getOrNull(), isNull);
    });

    test("post task works correctly", () async {
      when(dio).calls(#post).thenAnswer(
            (_) async => testResponse(
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
          id: null,
          title: "Mock Title",
          description: "Mock Description",
          labels: null,
          author: UserModel(
            id: "mock_id",
            name: "Mock User",
            email: "mock@email.com",
            profileColor: Color(0xFFFF0000),
          ),
          members: null,
          expireDate: DateTime.parse("2021-01-03"),
          checklists: [
            ChecklistModel(
              id: "mock_checklist_id",
              title: "Mock Checklist Title",
              items: [
                ChecklistItemModel(
                  id: "mock_item_1",
                  item: "item 1",
                  complete: false,
                ),
                ChecklistItemModel(
                  id: "mock_item_2",
                  item: "item 2",
                  complete: false,
                ),
                ChecklistItemModel(
                  id: "mock_item_3",
                  item: "item 3",
                  complete: false,
                ),
              ],
            ),
          ],
          comments: null,
          archived: false,
          creationDate: DateTime.parse("2020-12-22"),
        ),
        UniqueId("mock_id"),
      );
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(
        res.getOrNull(),
        equals(
          TaskModel(
            id: "mock_task_id",
            title: "Mock Title",
            description: "Mock Description",
            labels: null,
            author: UserModel(
              id: "mock_id",
              name: "Mock User",
              email: "mock@email.com",
              profileColor: Color(0xFFFF0000),
            ),
            members: null,
            expireDate: DateTime.parse("2021-01-03"),
            checklists: [
              ChecklistModel(
                id: "mock_checklist_id",
                title: "Mock Checklist Title",
                items: [
                  ChecklistItemModel(
                    id: "mock_item_1",
                    item: "item 1",
                    complete: false,
                  ),
                  ChecklistItemModel(
                    id: "mock_item_2",
                    item: "item 2",
                    complete: false,
                  ),
                  ChecklistItemModel(
                    id: "mock_item_3",
                    item: "item 3",
                    complete: false,
                  ),
                ],
              ),
            ],
            comments: null,
            archived: false,
            creationDate: DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio).calls(#post).thenAnswer((_) async => testResponse());
      final res2 = await source.postTask(
        TaskModel(
          id: null,
          title: "Mock Title",
          description: "Mock Description",
          labels: null,
          author: UserModel(
            id: "mock_id",
            name: "Mock User",
            email: "mock@email.com",
            profileColor: Color(0xFFFF0000),
          ),
          members: null,
          expireDate: DateTime.parse("2021-01-03"),
          checklists: null,
          comments: null,
          archived: false,
          creationDate: DateTime.parse("2020-12-22"),
        ),
        UniqueId("mock_id"),
      );
      expect(res2.isLeft(), isTrue);
    });

    test("patch task works correctly", () async {
      when(dio).calls(#patch).thenAnswer(
            (_) async => testResponse(
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
          id: "mock_task_id",
          title: "Mock Title",
          description: "Mock Description",
          labels: [
            LabelModel(
              id: "label_1",
              color: Colors.red,
              label: "label 1",
            ),
            LabelModel(
              id: "label_2",
              color: Colors.blue,
              label: "label 2",
            ),
          ],
          author: UserModel(
            id: "mock_id",
            name: "Mock User",
            email: "mock@email.com",
            profileColor: Color(0xFFFF0000),
          ),
          members: [
            UserModel(
              id: "user_1",
              name: "user 1",
              email: "user1@email.com",
              profileColor: null,
            ),
            UserModel(
              id: "user_2",
              name: "user 2",
              email: "user2@email.com",
              profileColor: null,
            ),
            UserModel(
              id: "user_3",
              name: "user 3",
              email: "user3@email.com",
              profileColor: null,
            ),
          ],
          expireDate: DateTime.parse("2021-01-03"),
          checklists: [
            ChecklistModel(
              id: "checklist_1",
              title: "Checklist 1",
              items: [
                ChecklistItemModel(
                  id: "item_1",
                  item: "item 1",
                  complete: true,
                ),
                ChecklistItemModel(
                  id: "item_2",
                  item: "item 2",
                  complete: false,
                ),
              ],
            ),
            ChecklistModel(
              id: "checklist_2",
              title: "Checklist 2",
              items: [
                ChecklistItemModel(
                  id: "item_1",
                  item: "item 1",
                  complete: false,
                ),
                ChecklistItemModel(
                  id: "item_2",
                  item: "item 2",
                  complete: true,
                ),
              ],
            ),
            ChecklistModel(
              id: "checklist_3",
              title: "Checklist 3",
              items: null,
            ),
          ],
          comments: null,
          archived: false,
          creationDate: DateTime.parse("2020-12-22"),
        ),
        UniqueId("mock_id"),
      );
      expect(res.isRight(), isTrue);
      expect(res.getOrNull(), isNotNull);
      expect(
        res.getOrNull(),
        equals(
          TaskModel(
            id: "mock_task_id",
            title: "Mock Title",
            description: "Mock Description",
            labels: null,
            author: UserModel(
              id: "mock_id",
              name: "Mock User",
              email: "mock@email.com",
              profileColor: Color(0xFFFF0000),
            ),
            members: null,
            expireDate: DateTime.parse("2021-01-03"),
            checklists: null,
            comments: null,
            archived: false,
            creationDate: DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio).calls(#patch).thenAnswer((_) async => testResponse());
      final res2 = await source.patchTask(
        TaskModel(
          id: "mock_task_id",
          title: "Mock Title",
          description: "Mock Description",
          labels: null,
          author: UserModel(
            id: "mock_id",
            name: "Mock User",
            email: "mock@email.com",
            profileColor: Color(0xFFFF0000),
          ),
          members: null,
          expireDate: DateTime.parse("2021-01-03"),
          checklists: null,
          comments: null,
          archived: false,
          creationDate: DateTime.parse("2020-12-22"),
        ),
        UniqueId("mock_id"),
      );
      expect(res2.isLeft(), isTrue);
    });

    test("post comment works correctly", () async {
      when(dio).calls(#post).thenAnswer(
            (_) async => testResponse(
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
            id: "mock_task_id",
            title: "Mock Title",
            description: null,
            labels: null,
            author: UserModel(
              id: "mock_id",
              name: "Mock User",
              email: "mock@email.com",
              profileColor: Color(0xFFFF0000),
            ),
            members: null,
            expireDate: null,
            checklists: null,
            comments: [
              CommentModel(
                id: "mock_comment",
                content: "mock_content",
                author: UserModel(
                  id: "mock_id",
                  name: "Mock User",
                  email: "mock@email.com",
                  profileColor: Color(0xFFFF0000),
                ),
                likes: [],
                dislikes: [],
                creationDate: DateTime.parse("2020-12-22"),
              )
            ],
            archived: false,
            creationDate: DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio).calls(#post).thenAnswer((_) async => testResponse());
      final res2 = await source.postComment(
        UniqueId("mock_task_id"),
        UniqueId("mock_user_id"),
        CommentContent("mock_content"),
      );
      expect(res2.isLeft(), isTrue);
    });

    test("delete comment works correctly", () async {
      when(dio).calls(#delete).thenAnswer(
            (_) async => testResponse(
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
            id: "mock_task_id",
            title: "Mock Title",
            description: null,
            labels: null,
            author: UserModel(
              id: "mock_id",
              name: "Mock User",
              email: "mock@email.com",
              profileColor: Color(0xFFFF0000),
            ),
            members: null,
            expireDate: null,
            checklists: null,
            comments: [
              CommentModel(
                id: "mock_comment",
                content: "mock_content",
                author: UserModel(
                  id: "mock_id",
                  name: "Mock User",
                  email: "mock@email.com",
                  profileColor: Color(0xFFFF0000),
                ),
                likes: [],
                dislikes: [],
                creationDate: DateTime.parse("2020-12-22"),
              )
            ],
            archived: false,
            creationDate: DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio).calls(#delete).thenAnswer((_) async => testResponse());
      final res2 = await source.deleteComment(
        UniqueId("mock_task_id"),
        UniqueId("mock_comment_id"),
        UniqueId("mock_user_id"),
      );
      expect(res2.isLeft(), isTrue);
    });

    test("patch comment works correctly", () async {
      when(dio).calls(#patch).thenAnswer(
            (_) async => testResponse(
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
            id: "mock_task_id",
            title: "Mock Title",
            description: null,
            labels: null,
            author: UserModel(
              id: "mock_id",
              name: "Mock User",
              email: "mock@email.com",
              profileColor: Color(0xFFFF0000),
            ),
            expireDate: null,
            members: null,
            checklists: null,
            comments: [
              CommentModel(
                id: "mock_comment",
                content: "mock_content",
                author: UserModel(
                  id: "mock_id",
                  name: "Mock User",
                  email: "mock@email.com",
                  profileColor: Color(0xFFFF0000),
                ),
                likes: [],
                dislikes: [],
                creationDate: DateTime.parse("2020-12-22"),
              )
            ],
            archived: false,
            creationDate: DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio).calls(#patch).thenAnswer((_) async => testResponse());
      final res2 = await source.patchComment(
        UniqueId("mock_task_id"),
        UniqueId("mock_comment_id"),
        UniqueId("mock_user_id"),
        CommentContent("mock_content"),
      );
      expect(res2.isLeft(), isTrue);
    });

    test("like comment works correctly", () async {
      when(dio).calls(#post).thenAnswer(
            (_) async => testResponse(
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
            id: "mock_task_id",
            title: "Mock Title",
            description: null,
            labels: null,
            author: UserModel(
              id: "mock_id",
              name: "Mock User",
              email: "mock@email.com",
              profileColor: Color(0xFFFF0000),
            ),
            members: null,
            expireDate: null,
            checklists: null,
            comments: [
              CommentModel(
                  id: "mock_comment",
                  content: "mock_content",
                  author: UserModel(
                    id: "mock_id",
                    name: "Mock User",
                    email: "mock@email.com",
                    profileColor: Color(0xFFFF0000),
                  ),
                  likes: [
                    UserModel(
                      id: "mock_id",
                      name: "Mock User",
                      email: "mock@email.com",
                      profileColor: Color(0xFFFF0000),
                    ),
                  ],
                  dislikes: [],
                  creationDate: DateTime.parse("2020-12-22"))
            ],
            archived: false,
            creationDate: DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio).calls(#post).thenAnswer((_) async => testResponse());
      final res2 = await source.likeComment(
        UniqueId("mock_task_id"),
        UniqueId("mock_comment_id"),
        UniqueId("mock_user_id"),
      );
      expect(res2.isLeft(), isTrue);
    });

    test("dislike comment works correctly", () async {
      when(dio).calls(#post).thenAnswer(
            (_) async => testResponse(
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
            id: "mock_task_id",
            title: "Mock Title",
            description: null,
            labels: null,
            author: UserModel(
              id: "mock_id",
              name: "Mock User",
              email: "mock@email.com",
              profileColor: Color(0xFFFF0000),
            ),
            members: null,
            expireDate: null,
            checklists: null,
            comments: [
              CommentModel(
                id: "mock_comment",
                content: "mock_content",
                author: UserModel(
                  id: "mock_id",
                  name: "Mock User",
                  email: "mock@email.com",
                  profileColor: Color(0xFFFF0000),
                ),
                likes: [],
                dislikes: [
                  UserModel(
                    id: "mock_id",
                    name: "Mock User",
                    email: "mock@email.com",
                    profileColor: Color(0xFFFF0000),
                  ),
                ],
                creationDate: DateTime.parse("2020-12-22"),
              )
            ],
            archived: false,
            creationDate: DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio).calls(#post).thenAnswer((_) async => testResponse());
      final res2 = await source.dislikeComment(
        UniqueId("mock_task_id"),
        UniqueId("mock_comment_id"),
        UniqueId("mock_user_id"),
      );
      expect(res2.isLeft(), isTrue);
    });

    test("archive works correctly", () async {
      when(dio).calls(#post).thenAnswer(
            (_) async => testResponse(
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
            id: "mock_task_id",
            title: "Mock Title",
            description: null,
            labels: null,
            author: UserModel(
              id: "mock_id",
              name: "Mock User",
              email: "mock@email.com",
              profileColor: Color(0xFFFF0000),
            ),
            expireDate: null,
            members: null,
            checklists: null,
            comments: [],
            archived: true,
            creationDate: DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio).calls(#post).thenAnswer((_) async => testResponse());
      final res2 = await source.archive(
        UniqueId("mock_task_id"),
        UniqueId("mock_user_id"),
        Toggle(true),
      );
      expect(res2.isLeft(), isTrue);
    });

    test("check works correctly", () async {
      when(dio).calls(#post).thenAnswer(
            (_) async => testResponse(
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
            id: "mock_task_id",
            title: "Mock Title",
            description: null,
            labels: null,
            author: UserModel(
              id: "mock_id",
              name: "Mock User",
              email: "mock@email.com",
              profileColor: Color(0xFFFF0000),
            ),
            expireDate: null,
            members: null,
            checklists: [
              ChecklistModel(
                id: "mock_checklist_id",
                title: "mock checklist title",
                items: [
                  ChecklistItemModel(
                    id: "mock_item_id",
                    item: "item 1",
                    complete: true,
                  )
                ],
              ),
            ],
            comments: null,
            archived: false,
            creationDate: DateTime.parse("2020-12-22"),
          ),
        ),
      );

      when(dio).calls(#post).thenAnswer((_) async => testResponse());
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
            id: null,
            title: null,
            description: null,
            labels: null,
            author: null,
            members: null,
            expireDate: null,
            comments: null,
            checklists: null,
            archived: null,
            creationDate: null,
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
            id: null,
            title: null,
            description: null,
            labels: null,
            author: null,
            members: null,
            expireDate: null,
            comments: null,
            checklists: null,
            archived: null,
            creationDate: null,
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
