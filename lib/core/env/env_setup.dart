import 'package:app_essentials/app/data/model/env/env_model.dart';

class Environment {
  final String localApiBaseUrl;
  final String devApiBaseUrl;
  final String stagingApiBaseUrl;
  final String productionApiBaseUrl;

  static Env currentEnv = localEnv;

  static late Env localEnv;
  static late Env devEnv;
  static late Env stagingEnv;
  static late Env productingEnv;

  Environment({
    this.localApiBaseUrl = '',
    this.devApiBaseUrl = '',
    this.stagingApiBaseUrl = '',
    this.productionApiBaseUrl = '',
  });

  void initialize() {
    localEnv = Env(
      'Local',
      EnvUsers.dummyUser,
      localApiBaseUrl,
      true,
    );
    devEnv = Env(
      'Dev',
      EnvUsers.dummyUser,
      devApiBaseUrl,
      true,
    );
    stagingEnv = Env(
      'Staging',
      EnvUsers.dummyUser,
      stagingApiBaseUrl,
      false,
    );
    productingEnv = Env(
      'Production',
      null,
      productionApiBaseUrl,
      false,
    );

    currentEnv = devEnv;
  }
}

class EnvUsers {
  static const EnvUser dummyUser = EnvUser(
    'user@gmail.com',
    '123',
  );
  /* You can create new users as many as you want like above. */
}
