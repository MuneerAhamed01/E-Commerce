import 'package:authentication_client/authentication_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trends/core/errors/trends_error_category.dart';
import 'package:trends/core/errors/trends_error_mapper.dart';

void main() {
  group('TrendsErrorMapper', () {
    test('maps payment category to contact-friendly copy', () {
      final presentation = TrendsErrorMapper.from(
        category: TrendsErrorCategory.payment,
      );

      expect(presentation.title, 'Payment unavailable');
      expect(presentation.showContactSupport, isTrue);
    });

    test('maps feature unavailable with feature name', () {
      final presentation = TrendsErrorMapper.featureUnavailable(
        featureName: 'Online payments',
      );

      expect(presentation.message, contains('Online payments'));
      expect(presentation.showContactSupport, isTrue);
    });

    test('maps auth failure without contact for wrong password', () {
      final presentation = TrendsErrorMapper.from(
        error: const AuthFailure(
          code: AuthFailureCode.wrongPassword,
          message: 'Incorrect password.',
        ),
      );

      expect(presentation.message, 'Incorrect password.');
      expect(presentation.showContactSupport, isFalse);
    });
  });
}
