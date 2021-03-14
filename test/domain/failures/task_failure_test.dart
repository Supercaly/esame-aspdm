import 'package:tasky/domain/failures/task_failure.dart';
import 'package:tasky/domain/values/unique_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("TaskFailure tests", () {
    test("ServerFailure equalities", () {
      expect(TaskFailure.invalidId(), equals(TaskFailure.invalidId()));
      expect(TaskFailure.newCommentFailure(),
          equals(TaskFailure.newCommentFailure()));
      expect(TaskFailure.deleteCommentFailure(UniqueId("error_string")),
          equals(TaskFailure.deleteCommentFailure(UniqueId("error_string"))));
      expect(TaskFailure.editCommentFailure(UniqueId("error_string")),
          equals(TaskFailure.editCommentFailure(UniqueId("error_string"))));
      expect(TaskFailure.likeFailure(UniqueId("error_string")),
          equals(TaskFailure.likeFailure(UniqueId("error_string"))));
      expect(TaskFailure.dislikeFailure(UniqueId("error_string")),
          equals(TaskFailure.dislikeFailure(UniqueId("error_string"))));
      expect(TaskFailure.archiveFailure(UniqueId("error_string")),
          equals(TaskFailure.archiveFailure(UniqueId("error_string"))));
      expect(TaskFailure.unarchiveFailure(UniqueId("error_string")),
          equals(TaskFailure.unarchiveFailure(UniqueId("error_string"))));
      expect(TaskFailure.itemCompleteFailure(UniqueId("error_string")),
          equals(TaskFailure.itemCompleteFailure(UniqueId("error_string"))));

      expect(TaskFailure.invalidId(),
          isNot(equals(TaskFailure.newCommentFailure())));
      expect(
          TaskFailure.invalidId(),
          isNot(equals(
              TaskFailure.deleteCommentFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.invalidId(),
          isNot(equals(
              TaskFailure.editCommentFailure(UniqueId("error_string")))));
      expect(TaskFailure.invalidId(),
          isNot(equals(TaskFailure.likeFailure(UniqueId("error_string")))));
      expect(TaskFailure.invalidId(),
          isNot(equals(TaskFailure.dislikeFailure(UniqueId("error_string")))));
      expect(TaskFailure.invalidId(),
          isNot(equals(TaskFailure.archiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.invalidId(),
          isNot(
              equals(TaskFailure.unarchiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.invalidId(),
          isNot(equals(
              TaskFailure.itemCompleteFailure(UniqueId("error_string")))));

      expect(TaskFailure.newCommentFailure(),
          isNot(equals(TaskFailure.invalidId())));
      expect(
          TaskFailure.newCommentFailure(),
          isNot(equals(
              TaskFailure.deleteCommentFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.newCommentFailure(),
          isNot(equals(
              TaskFailure.editCommentFailure(UniqueId("error_string")))));
      expect(TaskFailure.newCommentFailure(),
          isNot(equals(TaskFailure.likeFailure(UniqueId("error_string")))));
      expect(TaskFailure.newCommentFailure(),
          isNot(equals(TaskFailure.dislikeFailure(UniqueId("error_string")))));
      expect(TaskFailure.newCommentFailure(),
          isNot(equals(TaskFailure.archiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.newCommentFailure(),
          isNot(
              equals(TaskFailure.unarchiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.newCommentFailure(),
          isNot(equals(
              TaskFailure.itemCompleteFailure(UniqueId("error_string")))));

      expect(TaskFailure.deleteCommentFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.invalidId())));
      expect(TaskFailure.deleteCommentFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.newCommentFailure())));
      expect(
          TaskFailure.deleteCommentFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.editCommentFailure(UniqueId("error_string")))));
      expect(TaskFailure.deleteCommentFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.likeFailure(UniqueId("error_string")))));
      expect(TaskFailure.deleteCommentFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.dislikeFailure(UniqueId("error_string")))));
      expect(TaskFailure.deleteCommentFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.archiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.deleteCommentFailure(UniqueId("error_string")),
          isNot(
              equals(TaskFailure.unarchiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.deleteCommentFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.itemCompleteFailure(UniqueId("error_string")))));

      expect(TaskFailure.editCommentFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.invalidId())));
      expect(TaskFailure.editCommentFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.newCommentFailure())));
      expect(
          TaskFailure.editCommentFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.deleteCommentFailure(UniqueId("error_string")))));
      expect(TaskFailure.editCommentFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.likeFailure(UniqueId("error_string")))));
      expect(TaskFailure.editCommentFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.dislikeFailure(UniqueId("error_string")))));
      expect(TaskFailure.editCommentFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.archiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.editCommentFailure(UniqueId("error_string")),
          isNot(
              equals(TaskFailure.unarchiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.editCommentFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.itemCompleteFailure(UniqueId("error_string")))));

      expect(TaskFailure.likeFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.invalidId())));
      expect(TaskFailure.likeFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.newCommentFailure())));
      expect(
          TaskFailure.likeFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.deleteCommentFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.likeFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.editCommentFailure(UniqueId("error_string")))));
      expect(TaskFailure.likeFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.dislikeFailure(UniqueId("error_string")))));
      expect(TaskFailure.likeFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.archiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.likeFailure(UniqueId("error_string")),
          isNot(
              equals(TaskFailure.unarchiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.likeFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.itemCompleteFailure(UniqueId("error_string")))));

      expect(TaskFailure.dislikeFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.invalidId())));
      expect(TaskFailure.dislikeFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.newCommentFailure())));
      expect(
          TaskFailure.dislikeFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.deleteCommentFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.dislikeFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.editCommentFailure(UniqueId("error_string")))));
      expect(TaskFailure.dislikeFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.likeFailure(UniqueId("error_string")))));
      expect(TaskFailure.dislikeFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.archiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.dislikeFailure(UniqueId("error_string")),
          isNot(
              equals(TaskFailure.unarchiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.dislikeFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.itemCompleteFailure(UniqueId("error_string")))));

      expect(TaskFailure.archiveFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.invalidId())));
      expect(TaskFailure.archiveFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.newCommentFailure())));
      expect(
          TaskFailure.archiveFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.deleteCommentFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.archiveFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.editCommentFailure(UniqueId("error_string")))));
      expect(TaskFailure.archiveFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.likeFailure(UniqueId("error_string")))));
      expect(TaskFailure.archiveFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.dislikeFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.archiveFailure(UniqueId("error_string")),
          isNot(
              equals(TaskFailure.unarchiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.archiveFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.itemCompleteFailure(UniqueId("error_string")))));

      expect(TaskFailure.unarchiveFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.invalidId())));
      expect(TaskFailure.unarchiveFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.newCommentFailure())));
      expect(
          TaskFailure.unarchiveFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.deleteCommentFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.unarchiveFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.editCommentFailure(UniqueId("error_string")))));
      expect(TaskFailure.unarchiveFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.likeFailure(UniqueId("error_string")))));
      expect(TaskFailure.unarchiveFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.dislikeFailure(UniqueId("error_string")))));
      expect(TaskFailure.unarchiveFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.archiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.unarchiveFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.itemCompleteFailure(UniqueId("error_string")))));

      expect(TaskFailure.itemCompleteFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.invalidId())));
      expect(TaskFailure.itemCompleteFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.newCommentFailure())));
      expect(
          TaskFailure.itemCompleteFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.deleteCommentFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.itemCompleteFailure(UniqueId("error_string")),
          isNot(equals(
              TaskFailure.editCommentFailure(UniqueId("error_string")))));
      expect(TaskFailure.itemCompleteFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.likeFailure(UniqueId("error_string")))));
      expect(TaskFailure.itemCompleteFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.dislikeFailure(UniqueId("error_string")))));
      expect(TaskFailure.itemCompleteFailure(UniqueId("error_string")),
          isNot(equals(TaskFailure.archiveFailure(UniqueId("error_string")))));
      expect(
          TaskFailure.itemCompleteFailure(UniqueId("error_string")),
          isNot(
              equals(TaskFailure.unarchiveFailure(UniqueId("error_string")))));
    });

    test("when returns the result of the correct case", () {
      final r1 = TaskFailure.invalidId().when(
        editCommentFailure: (UniqueId? commentId) => false,
        likeFailure: (UniqueId? commentId) => false,
        deleteCommentFailure: (UniqueId? commentId) => false,
        newCommentFailure: () => false,
        itemCompleteFailure: (UniqueId? itemId) => false,
        unarchiveFailure: (UniqueId? taskId) => false,
        archiveFailure: (UniqueId? taskId) => false,
        invalidId: () => true,
        dislikeFailure: (UniqueId? commentId) => false,
      );
      final r2 = TaskFailure.newCommentFailure().when(
        editCommentFailure: (UniqueId? commentId) => false,
        likeFailure: (UniqueId? commentId) => false,
        deleteCommentFailure: (UniqueId? commentId) => false,
        newCommentFailure: () => true,
        itemCompleteFailure: (UniqueId? itemId) => false,
        unarchiveFailure: (UniqueId? taskId) => false,
        archiveFailure: (UniqueId? taskId) => false,
        invalidId: () => false,
        dislikeFailure: (UniqueId? commentId) => false,
      );
      final r3 = TaskFailure.editCommentFailure(UniqueId("commentId")).when(
        editCommentFailure: (UniqueId? commentId) => true,
        likeFailure: (UniqueId? commentId) => false,
        deleteCommentFailure: (UniqueId? commentId) => false,
        newCommentFailure: () => false,
        itemCompleteFailure: (UniqueId? itemId) => false,
        unarchiveFailure: (UniqueId? taskId) => false,
        archiveFailure: (UniqueId? taskId) => false,
        invalidId: () => false,
        dislikeFailure: (UniqueId? commentId) => false,
      );
      final r4 = TaskFailure.deleteCommentFailure(UniqueId("commentId")).when(
        editCommentFailure: (UniqueId? commentId) => false,
        likeFailure: (UniqueId? commentId) => false,
        deleteCommentFailure: (UniqueId? commentId) => true,
        newCommentFailure: () => false,
        itemCompleteFailure: (UniqueId? itemId) => false,
        unarchiveFailure: (UniqueId? taskId) => false,
        archiveFailure: (UniqueId? taskId) => false,
        invalidId: () => false,
        dislikeFailure: (UniqueId? commentId) => false,
      );
      final r5 = TaskFailure.likeFailure(UniqueId("commentId")).when(
        editCommentFailure: (UniqueId? commentId) => false,
        likeFailure: (UniqueId? commentId) => true,
        deleteCommentFailure: (UniqueId? commentId) => false,
        newCommentFailure: () => false,
        itemCompleteFailure: (UniqueId? itemId) => false,
        unarchiveFailure: (UniqueId? taskId) => false,
        archiveFailure: (UniqueId? taskId) => false,
        invalidId: () => false,
        dislikeFailure: (UniqueId? commentId) => false,
      );
      final r6 = TaskFailure.dislikeFailure(UniqueId("commentId")).when(
        editCommentFailure: (UniqueId? commentId) => false,
        likeFailure: (UniqueId? commentId) => false,
        deleteCommentFailure: (UniqueId? commentId) => false,
        newCommentFailure: () => false,
        itemCompleteFailure: (UniqueId? itemId) => false,
        unarchiveFailure: (UniqueId? taskId) => false,
        archiveFailure: (UniqueId? taskId) => false,
        invalidId: () => false,
        dislikeFailure: (UniqueId? commentId) => true,
      );
      final r7 = TaskFailure.archiveFailure(UniqueId("taskId")).when(
        editCommentFailure: (UniqueId? commentId) => false,
        likeFailure: (UniqueId? commentId) => false,
        deleteCommentFailure: (UniqueId? commentId) => false,
        newCommentFailure: () => false,
        itemCompleteFailure: (UniqueId? itemId) => false,
        unarchiveFailure: (UniqueId? taskId) => false,
        archiveFailure: (UniqueId? taskId) => true,
        invalidId: () => false,
        dislikeFailure: (UniqueId? commentId) => false,
      );
      final r8 = TaskFailure.unarchiveFailure(UniqueId("taskId")).when(
        editCommentFailure: (UniqueId? commentId) => false,
        likeFailure: (UniqueId? commentId) => false,
        deleteCommentFailure: (UniqueId? commentId) => false,
        newCommentFailure: () => false,
        itemCompleteFailure: (UniqueId? itemId) => false,
        unarchiveFailure: (UniqueId? taskId) => true,
        archiveFailure: (UniqueId? taskId) => false,
        invalidId: () => false,
        dislikeFailure: (UniqueId? commentId) => false,
      );
      final r9 = TaskFailure.itemCompleteFailure(UniqueId("itemId")).when(
        dislikeFailure: (UniqueId? commentId) => false,
        unarchiveFailure: (UniqueId? taskId) => false,
        invalidId: () => false,
        archiveFailure: (UniqueId? taskId) => false,
        likeFailure: (UniqueId? commentId) => false,
        editCommentFailure: (UniqueId? commentId) => false,
        deleteCommentFailure: (UniqueId? commentId) => false,
        newCommentFailure: () => false,
        itemCompleteFailure: (UniqueId? itemId) => true,
      );

      expect(r1, isTrue);
      expect(r2, isTrue);
      expect(r3, isTrue);
      expect(r4, isTrue);
      expect(r5, isTrue);
      expect(r6, isTrue);
      expect(r7, isTrue);
      expect(r8, isTrue);
      expect(r9, isTrue);
    });
  });
}
