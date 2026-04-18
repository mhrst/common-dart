import 'dart:math';

const kUuidCharacterPool =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

const kUuidLength = 22;

String generateRandomUuid([
  int length = kUuidLength,
  String pool = kUuidCharacterPool,
]) {
  var random = Random.secure();
  return List.generate(
    length,
    (index) => pool[random.nextInt(pool.length)],
  ).join();
}
