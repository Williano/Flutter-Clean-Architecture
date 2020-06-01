import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_clean_architecture/dependency_injections/core/service_locator_initialization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> initNumberTriviaExternal() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}
