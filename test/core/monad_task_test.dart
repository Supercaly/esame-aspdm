import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/monad_task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("MonadTask tests", () {
    test("run returns the future", () {
      final t1 = MonadTask(() => Future.value(123));
      expect(t1.run(), isA<Future<int>>());
      expectLater(t1.run(), completion(123));
    });

    test("attempt return the correct either", () async {
      final t1 = MonadTask(() => Future.microtask(() {
            return num.parse("not_a_number");
          })).attempt<FormatException>((e) => FormatException());
      final t2 = MonadTask(() => Future.microtask(() {
            return num.parse("123");
          })).attempt<FormatException>((e) => FormatException());
      final t3 = MonadTask(() => Future.microtask(() {
            return num.parse("not_a_number");
          })).attempt<FormatException>((e) => FormatException());
      final t4 = MonadTask(() => Future<num>.error(Error())).attempt<FormatException>((e) => FormatException());

      final res = await t1.run();
      expect(res, isA<Either<FormatException, num>>());
      expect(res.isLeft(), isTrue);

      final res2 = await t2.run();
      expect(res2, isA<Either<FormatException, num>>());
      expect(res2.isRight(), isTrue);

      final res3 = await t3.run();
      expect(res3, isA<Either<FormatException, num>>());
      expect(res3.isLeft(), isTrue);

      final res4 = await t4.run();
      expect(res4, isA<Either<FormatException, num>>());
      expect(res4.isLeft(), isTrue);
    });
  });
}
