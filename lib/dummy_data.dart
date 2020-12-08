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
      id: "0",
      title: "title",
      description: "description",
      labels: [Label(Colors.green, null)],
      members: null,
      expireDate: null,
      checklists: null,
      comments: null,
    ),
    Task(
      id: "1",
      title: "title",
      description: null,
      labels: [Label(Colors.red, null)],
      members: [User()],
      expireDate: DateTime.now().add(Duration(days: 1)),
      checklists: [Checklist()],
      comments: null,
    ),
    Task(
      id: "2",
      title: "title",
      description: "description",
      labels: [
        Label(Colors.green, null),
        Label(Colors.red, null),
        Label(Colors.blue, null),
      ],
      members: [User()],
      expireDate: DateTime.now(),
      checklists: [Checklist()],
      comments: [Comment()],
    ),
    Task(
      id: "3",
      title: "title",
      description: null,
      labels: null,
      members: null,
      expireDate: DateTime.now().add(Duration(days: 10, hours: 5)),
      checklists: null,
      comments: null,
    ),
    Task(
      id: "4",
      title: "title",
      description: "description",
      labels: [
        Label(Colors.green, null),
        Label(Colors.red, null),
      ],
      members: [User()],
      expireDate: null,
      checklists: null,
      comments: [
        Comment(),
        Comment(),
      ],
    ),
  ];

  static final List<Task> archivedTasks = [
    Task(
      id: "1",
      title: "title",
      description: null,
      labels: [Label(Colors.red, null)],
      members: [User()],
      expireDate: DateTime.now(),
      checklists: [Checklist()],
      comments: null,
    ),
    Task(
      id: "2",
      title: "title",
      description: "description",
      labels: [
        Label(Colors.green, null),
        Label(Colors.red, null),
        Label(Colors.blue, null),
      ],
      members: [User()],
      expireDate: DateTime.now(),
      checklists: [Checklist()],
      comments: [Comment()],
    ),
    Task(
      id: "3",
      title: "title",
      description: null,
      labels: null,
      members: null,
      expireDate: null,
      checklists: null,
      comments: null,
    ),
    Task(
      id: "4",
      title: "title",
      description: "description",
      labels: [
        Label(Colors.green, null),
        Label(Colors.red, null),
      ],
      members: [User()],
      expireDate: null,
      checklists: null,
      comments: [
        Comment(),
        Comment(),
      ],
    ),
  ];

  static final Task task = Task(
      id: "1",
      title: "title",
      description: "description",
      labels: [
        Label(Colors.green, "label"),
        Label(Colors.red, "label"),
        Label(Colors.blue, "label"),
      ],
      members: [
        User(),
        User(),
        User(),
      ],
      expireDate: DateTime.now(),
      checklists: [
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
      comments: [
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
