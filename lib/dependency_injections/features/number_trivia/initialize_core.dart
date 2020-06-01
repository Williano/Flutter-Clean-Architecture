import 'package:flutter_clean_architecture/core/network/network_info.dart';
import 'package:flutter_clean_architecture/core/utilities/presentation/bloc/input_converter.dart';
import 'package:flutter_clean_architecture/dependency_injections/core/service_locator_initialization.dart';

void initNumberTriviaCore() {
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: serviceLocator()));
}
