import 'dart:io';

String fixtureReader(String name) =>
    File("test/core/fixtures/$name").readAsStringSync();
