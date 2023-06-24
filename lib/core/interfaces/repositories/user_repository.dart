abstract class IUserRepository<T> {
  Future<bool> saveUser(T user);
  Future<bool> updateUser(T user);
  Future<T?> getUser();
}
