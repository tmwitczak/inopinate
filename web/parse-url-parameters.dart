////////////////////////////////////////////////////// Imports //
import 'dart:core';
import 'dart:html';

import 'text-to-type.dart';

/////////////////////////////////////// Parsing URL parameters //
void parseUrlParameters() {
  var parameters = Uri.base.queryParameters;

  if (parameters.isEmpty) {
    return;
  }

  Map<String, Function(String)> setupFunctions = {
    'redirect-to': (String parameterName) {
      querySelector('body').children.add(DivElement()
        ..appendText(parameters[parameterName])
        ..className = 'destination');
    },
    'characters': (String parameterName) {
      maxTyped = int.parse(parameters[parameterName]);
    }
  };

  setupFunctions
      .forEach((String parameterName, Function(String) setup) {
    if (parameters.containsKey(parameterName)) {
      setup(parameterName);
    }
  });
}

/////////////////////////////////////////////////////////////////
