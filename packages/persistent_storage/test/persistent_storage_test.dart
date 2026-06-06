import 'package:flutter_test/flutter_test.dart';
import 'package:persistent_storage/persistent_storage.dart';

void main() {
  group('InMemoryStorage', () {
    late InMemoryStorage storage;

    setUp(() {
      storage = InMemoryStorage();
    });

    test('read returns null for missing key', () async {
      expect(await storage.read('missing'), isNull);
    });

    test('write and read round-trip', () async {
      await storage.write('key', 'value');
      expect(await storage.read('key'), 'value');
    });

    test('delete removes key', () async {
      await storage.write('key', 'value');
      await storage.delete('key');
      expect(await storage.read('key'), isNull);
    });

    test('clear removes all keys', () async {
      await storage.write('a', '1');
      await storage.write('b', '2');
      await storage.clear();
      expect(await storage.read('a'), isNull);
      expect(await storage.read('b'), isNull);
    });
  });
}
