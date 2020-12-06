import 'package:aspdm_project/model/label.dart';
import 'package:flutter/material.dart';

import 'model/checklist.dart';
import 'model/comment.dart';
import 'model/task.dart';
import 'model/user.dart';

class DummyData {
  const DummyData._();

  static final List<Task> tasks = [
    Task(
      "0",
      "title",
      "description",
      [Label(Colors.green, null)],
      null,
      null,
      null,
      null,
    ),
    Task(
      "1",
      "title",
      null,
      [Label(Colors.red, null)],
      [User()],
      DateTime.now(),
      [Checklist()],
      null,
    ),
    Task(
      "2",
      "title",
      "description",
      [
        Label(Colors.green, null),
        Label(Colors.red, null),
        Label(Colors.blue, null),
      ],
      [User()],
      DateTime.now(),
      [Checklist()],
      [Comment()],
    ),
    Task(
      "3",
      "title",
      null,
      null,
      null,
      null,
      null,
      null,
    ),
    Task(
      "4",
      "title",
      "description",
      [
        Label(Colors.green, null),
        Label(Colors.red, null),
      ],
      [User()],
      null,
      null,
      [
        Comment(),
        Comment(),
      ],
    ),
  ];

  static final List<Task> archivedTasks = [
    Task(
      "1",
      "title",
      null,
      [Label(Colors.red, null)],
      [User()],
      DateTime.now(),
      [Checklist()],
      null,
    ),
    Task(
      "2",
      "title",
      "description",
      [
        Label(Colors.green, null),
        Label(Colors.red, null),
        Label(Colors.blue, null),
      ],
      [User()],
      DateTime.now(),
      [Checklist()],
      [Comment()],
    ),
    Task(
      "3",
      "title",
      null,
      null,
      null,
      null,
      null,
      null,
    ),
    Task(
      "4",
      "title",
      "description",
      [
        Label(Colors.green, null),
        Label(Colors.red, null),
      ],
      [User()],
      null,
      null,
      [
        Comment(),
        Comment(),
      ],
    ),
  ];

  static final Task task = Task(
      "1",
      "title",
      "description",
      [
        Label(Colors.green, "label"),
        Label(Colors.red, "label"),
        Label(Colors.blue, "label"),
      ],
      [
        User(),
        User(),
        User(),
      ],
      DateTime.now(),
      [
        Checklist("Checklist 1", [
          ChecklistItem("item", true),
          ChecklistItem("item", false),
          ChecklistItem("item", true),
          ChecklistItem("item", false),
          ChecklistItem("item", true),
        ]),
        Checklist("Checklist 2", [
          ChecklistItem("item", true),
          ChecklistItem("item", false),
          ChecklistItem("item", false),
          ChecklistItem("item", false),
          ChecklistItem("item", true),
        ]),
        Checklist("Checklist 3", null),
      ],
      [
        Comment(
          content: "looong text",
          creationDate: DateTime.now(),
          dislikes: 1,
          likes: 100,
          user: user,
          disliked: false,
          liked: false,
        ),
        Comment(disliked: true),
        Comment(liked: true),
        Comment(),
      ]);

  static final User user =
      User(id: "0", name: "Jon Doe", email: "jon.doe@email.com");
}
