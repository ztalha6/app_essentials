class Env {
  final String label;
  final EnvUser? user;
  final String baseUrl;
  final bool prefillForms;

  Env(
    this.label,
    this.user,
    this.baseUrl,
    this.prefillForms,
  );
}

class EnvUser {
  final String email;
  final String password;

  const EnvUser(this.email, this.password);
}
