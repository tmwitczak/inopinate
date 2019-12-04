// /////////////////////////////////////////////////// Imports //
import 'text-to-type.dart';
import 'parse-url-parameters.dart';

// ////////////////////////////////////////////////////// Main //
void main() async {
  parseUrlParameters();

  await textToTypeObj.initialize('packs/english-words.json');
  constructTextToTypeElement(await textToTypeObj.generateText());

  await constructButtons();
  setupEventListeners();

  setRedirectionVisibility();
}

// /////////////////////////////////////////////////////////// //
