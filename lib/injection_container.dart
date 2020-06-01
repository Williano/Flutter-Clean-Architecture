import 'package:flutter_clean_architecture/dependency_injections/features/number_trivia/initialize_core.dart';
import 'package:flutter_clean_architecture/dependency_injections/features/number_trivia/initialize_external.dart';
import 'package:flutter_clean_architecture/dependency_injections/features/number_trivia/initialize_features.dart';

Future<void> init() async {
  //! Features
  initNumberTriviaFeatures();

  //! Core
  initNumberTriviaCore();

  //! External
  await initNumberTriviaExternal();
}
