// /////////////////////////////////////////////////// Imports //
import 'text-to-type.dart';

// ////////////////////////////////////////////////////// Main //
void main() async {
  parseUrlParameters();

  await textToTypeObj.initialize('packs/english-words.json');
  constructTextToTypeElement(await textToTypeObj.generateText());

  await constructButtons();
  setupEventListeners();
}

// /////////////////////////////////////////////////////////// //
