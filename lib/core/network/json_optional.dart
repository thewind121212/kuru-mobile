/// Sentinel that distinguishes "send `null` to clear" from "omit key entirely".
///
/// Used by PATCH request bodies whose BE DTO accepts `null` for some fields
/// (to disconnect a relation) but treats an absent key as "leave unchanged".
class JsonOptional<T> {
  const JsonOptional.set(T this.value) : isSet = true;
  const JsonOptional.clear() : value = null, isSet = true;

  final T? value;
  final bool isSet;

  void writeTo(Map<String, dynamic> map, String key) {
    map[key] = value;
  }

  static void writeIfPresent<T>(
    Map<String, dynamic> map,
    String key,
    JsonOptional<T>? opt,
  ) {
    opt?.writeTo(map, key);
  }
}
