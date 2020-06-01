import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/dependency_injections/core/service_locator_initialization.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';
import 'package:flutter_clean_architecture/features/number_trivia/presentation/pages/number_trivia_page/number_trivia_page.dart';
import 'injection_container.dart' as dependencyInjection;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependencyInjection.init();
  runApp(NumberTriviaApp());
}

class NumberTriviaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Number Trivia",
      theme: ThemeData(
          primaryColor: Colors.green.shade800,
          accentColor: Colors.green.shade600),
      home: MultiBlocProvider(providers: [
        BlocProvider<NumberTriviaBloc>(
            create: (context) => serviceLocator<NumberTriviaBloc>()),
      ], child: NumberTriviaPage()),
    );
  }
}
