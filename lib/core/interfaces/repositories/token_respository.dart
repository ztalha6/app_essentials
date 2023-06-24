abstract class ITokenRepository<T> {
  Future<bool> setToken(T token);
  Future<String> getToken();
}
