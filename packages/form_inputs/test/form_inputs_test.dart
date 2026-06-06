import 'package:form_inputs/form_inputs.dart';
import 'package:test/test.dart';

void main() {
  group('Email', () {
    test('pure is invalid', () {
      const email = Email.pure();
      expect(email.isValid, isFalse);
      expect(email.error, EmailValidationError.empty);
    });

    test('valid email passes', () {
      const email = Email.dirty('user@example.com');
      expect(email.isValid, isTrue);
    });

    test('invalid format fails', () {
      const email = Email.dirty('not-an-email');
      expect(email.isValid, isFalse);
      expect(email.error, EmailValidationError.invalid);
    });
  });

  group('Password', () {
    test('pure is invalid', () {
      const password = Password.pure();
      expect(password.isValid, isFalse);
    });

    test('short password fails', () {
      const password = Password.dirty('short');
      expect(password.isValid, isFalse);
      expect(password.error, PasswordValidationError.tooShort);
    });

    test('valid password passes', () {
      const password = Password.dirty('password123');
      expect(password.isValid, isTrue);
    });
  });

  group('ConfirmedPassword', () {
    test('mismatch fails', () {
      const confirmed = ConfirmedPassword.dirty(
        password: 'password123',
        value: 'different',
      );
      expect(confirmed.isValid, isFalse);
      expect(confirmed.error, ConfirmedPasswordValidationError.mismatch);
    });

    test('match passes', () {
      const confirmed = ConfirmedPassword.dirty(
        password: 'password123',
        value: 'password123',
      );
      expect(confirmed.isValid, isTrue);
    });
  });

  group('DisplayName', () {
    test('empty fails', () {
      const name = DisplayName.dirty('');
      expect(name.isValid, isFalse);
      expect(name.error, DisplayNameValidationError.empty);
    });

    test('too short fails', () {
      const name = DisplayName.dirty('A');
      expect(name.isValid, isFalse);
      expect(name.error, DisplayNameValidationError.tooShort);
    });

    test('valid name passes', () {
      const name = DisplayName.dirty('Jane Doe');
      expect(name.isValid, isTrue);
    });
  });
}
