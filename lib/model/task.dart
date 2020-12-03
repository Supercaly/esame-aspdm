import 'checklist.dart';
import 'comment.dart';
import 'label.dart';
import 'user.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final List<Label> labels;
  final List<User> members;
  final DateTime expireDate;
  final List<Checklist> checklists;
  final List<Comment> comments;

  Task(this.id, this.title, this.description, this.labels, this.members,
      this.expireDate, this.checklists, this.comments);
}
