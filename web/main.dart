///////////////////////////////////////////////////////////////////// Imports //
import 'dart:convert';
import 'dart:core';
import 'dart:html';
import 'dart:math';

//////////////////////////////////////////////////////////////////////// Main //
var typedLetters = 0;
TextToType textToTypeObj = MostCommonBigraphs();

void handleClick(Event event) async {
  textToTypeObj = MostUsedEnglishWords();
  constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClick2(Event event) async {
  textToTypeObj = RandomTextToType();
  constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClick3(Event event) async {
  textToTypeObj = LeftHand();
  constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClick4(Event event) async {
  textToTypeObj = MostCommonTrigraphs();
  constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClick5(Event event) async {
  textToTypeObj = MostCommonBigraphs();
  constructTextToTypeElement(await textToTypeObj.generateText());
}

void constructButtons() async {
  var buttonInfo = [
    ['1000 most used english words', handleClick],
    ['Random words', handleClick2],
    ['Left hand', handleClick3],
    ['Most common trigraphs', handleClick4],
    ['Most common bigraphgs', handleClick5]
  ];

  for (int i = 0; i < buttonInfo.length; i++) {
    querySelector('#modes').children.add(DivElement()
      ..className = "button"
      ..text = buttonInfo[i][0]
      ..onClick.listen(buttonInfo[i][1]));
  }
}

void doTheCoolButtonEffect(MouseEvent event) {
  var buttons = querySelectorAll('.button');

  for (int i = 0; i < buttons.length; i++) {
    double opacity = 0.0;

    var buttonCenterX =
        buttons[i].borderEdge.left + buttons[i].borderEdge.width / 2;
    var buttonCenterY =
        buttons[i].borderEdge.top + buttons[i].borderEdge.height / 2;
    var mouseX = event.client.x;
    var mouseY = event.client.y;
    var distance =
        sqrt(pow(buttonCenterX - mouseX, 2) + pow(buttonCenterY - mouseY, 2));

    //TODO: make this function not linear
    var maxDist = min(window.outerWidth, window.innerHeight) * 0.8;
    if (distance > maxDist) {
      opacity = 0.0;
    } else if (distance <= maxDist && distance > 50) {
      opacity = 1.0 - distance / maxDist;
    } else {
      opacity = 1.0;
    }

    if (mouseX >= buttons[i].borderEdge.left &&
        mouseX <= buttons[i].borderEdge.right &&
        mouseY >= buttons[i].borderEdge.top &&
        mouseY <= buttons[i].borderEdge.bottom) {
      buttons[i].style.opacity = (1).toString();
    } else {
      buttons[i].style.opacity = (0.75 * opacity + 0.0).toString();
    }
  }
}

void main() async {
  await textToTypeObj.initialize();
  constructTextToTypeElement(await textToTypeObj.generateText());

  await constructButtons();
  window.onKeyDown.listen(handleWindowKeyDownEvent);
  window.onMouseMove.listen(doTheCoolButtonEffect);
}

abstract class TextToType {
  void initialize() {}
  Future<String> generateText();
}

class MostCommonBigraphs extends TextToType {
  List<String> words;

  @override
  void initialize() async {
    words = await loadData();
  }

  Future<List<String>> loadData() async {
    String jsonString = await HttpRequest.getString('packs/bigraphs.json');
    var siema = json.decode(jsonString) as List;
    return siema.cast<String>();
  }

  int randomIntegerInRange(int min, int max) =>
      (min + Random().nextInt(max - min + 1));

  int repeat = 0;
  String word;

  @override
  Future<String> generateText() async {
    if (repeat == 0) {
      word = words[randomIntegerInRange(0, words.length - 1)];
    }
    repeat = repeat + 1;
    if (repeat == 1) {
      repeat = 0;
    }
    return word;
  }
}

class MostCommonTrigraphs extends TextToType {
  int randomIntegerInRange(int min, int max) =>
      (min + Random().nextInt(max - min + 1));

  int repeat = 0;
  String word;

  @override
  Future<String> generateText() async {
    List words = [
      "the",
      "and",
      "ing",
      "her",
      "hat",
      "his",
      "tha",
      "ere",
      "for",
      "ent",
      "ion",
      "ter",
      "was",
      "you",
      "ith",
      "ver",
      "all",
      "wit",
      "thi",
      "tio"
    ];
    if (repeat == 0) {
      word = words[randomIntegerInRange(0, words.length - 1)];
    }
    repeat = repeat + 1;
    if (repeat == 1) {
      repeat = 0;
    }
    return word;
  }
}

class LeftHand extends TextToType {
  int randomIntegerInRange(int min, int max) =>
      (min + Random().nextInt(max - min + 1));

  @override
  Future<String> generateText() async {
    String letters = "12345qwertasdfgzxcvb";
    String word = '';
    for (int i = 0; i < 10; i++) {
      word += letters[randomIntegerInRange(0, letters.length - 1)];
      word += ' ';
    }
    return word;
  }
}

class MostUsedEnglishWords extends TextToType {
  int randomIntegerInRange(int min, int max) =>
      (min + Random().nextInt(max - min + 1));

  @override
  Future<String> generateText() async {
    List words = [
      "as",
      "I",
      "his",
      "that",
      "he",
      "was",
      "for",
      "on",
      "are",
      "with",
      "they",
      "be",
      "at",
      "one",
      "have",
      "this",
      "from",
      "by",
      "hot",
      "word",
      "but",
      "what",
      "some",
      "is",
      "it",
      "you",
      "or",
      "had",
      "the",
      "of",
      "to",
      "and",
      "a",
      "in",
      "we",
      "can",
      "out",
      "other",
      "were",
      "which",
      "do",
      "their",
      "time",
      "if",
      "will",
      "how",
      "said",
      "an",
      "each",
      "tell",
      "does",
      "set",
      "three",
      "want",
      "air",
      "well",
      "also",
      "play",
      "small",
      "end",
      "put",
      "home",
      "read",
      "hand",
      "port",
      "large",
      "spell",
      "add",
      "even",
      "land",
      "here",
      "must",
      "big",
      "high",
      "such",
      "follow",
      "act",
      "why",
      "ask",
      "men",
      "change",
      "went",
      "light",
      "kind",
      "off",
      "need",
      "house",
      "picture",
      "try",
      "us",
      "again",
      "animal",
      "point",
      "mother",
      "world",
      "near",
      "build",
      "self",
      "earth",
      "father"
    ];
    String word = '';
    for (int i = 0; i < 5; i++) {
      word += words[randomIntegerInRange(0, words.length - 1)];
      word += ' ';
    }
    return word;
  }
}

class RandomTextToType extends TextToType {
  String textToType;

  int randomIntegerInRange(int min, int max) =>
      (min + Random().nextInt(max - min + 1));

  String generateRandomText(int length) {
    String randomWord = '';

    for (int i = 0; i < length; i++) {
      randomWord += String.fromCharCode(
          randomIntegerInRange(rangeMin.codeUnitAt(0), rangeMax.codeUnitAt(0)));
    }
    return randomWord;
  }

  @override
  Future<String> generateText() async {
    return generateRandomText(randomIntegerInRange(
        minimumRandomTextToTypeLength, maximumRandomTextToTypeLength));
  }
}

var minimumRandomTextToTypeLength = 4;
var maximumRandomTextToTypeLength = 6;

var textToType = 'Text to type.';
String textTyped = '';
// String rangeMin = '!';
String rangeMin = ' ';
String rangeMax = '~';
int errors = 0;
// String rangeMin = '0';
// String rangeMax = '9';

void constructTextToTypeElement(String text) {
  Element output = querySelector('#text-to-type');
  output.children.clear();

  for (int i = 0; i < text.length; i++) {
    Element character = SpanElement();
    character.text = text[i];
    character.className = 'not-typed';
    if (text[i] == ' ') {
      character.text = '\u{00A0}';
    }
    output.children.add(character);
  }

  textToType = text;
}

void handleWindowKeyDownEvent(Event event) async {
  if (!(event is KeyboardEvent)) {
    return;
  }

  //--------------------------------------------------------------------------
  bool isStringOneCharacter(String string) => (string.length == 1);

  bool isPressedKeyAcceptable(KeyboardEvent keyboardEvent) =>
      isStringOneCharacter(keyboardEvent.key) &&
      (keyboardEvent.key.codeUnitAt(0) >= rangeMin.codeUnitAt(0)) &&
      (keyboardEvent.key.codeUnitAt(0) <= rangeMax.codeUnitAt(0));

  //--------------------------------------------------------------------------
  KeyboardEvent keyboardEvent = event;

  if (keyboardEvent.key == 'Backspace') {
    querySelector('#text-to-type')
        .children
        .elementAt(textTyped.length - 1)
        .className = "not-typed";

    textTyped = textTyped.substring(0, textTyped.length - 1);
  }

  if (isPressedKeyAcceptable(keyboardEvent) || keyboardEvent.key == "Space") {
    // Is pressed key correct?
    if (textToType[textTyped.length] == keyboardEvent.key) {
      querySelector('#text-to-type')
          .children
          .elementAt(textTyped.length)
          .className = "typed";
      textTyped += keyboardEvent.key;
      typedLetters++;
    } else {
      querySelector('#text-to-type')
          .children
          .elementAt(textTyped.length)
          .className = "incorrect";
      textTyped += keyboardEvent.key;
    }
    // If it isn't
    // else {
    //     errors++;
    //     querySelector('#errors').appendText(keyboardEvent.key);
    //     if (errors % 10 == 0) {
    //         querySelector('#errors').appendText('\n');
    //     }
    // }
  }

  // Is text already typed
  if (textToType == textTyped) {
    constructTextToTypeElement(await textToTypeObj.generateText());
    textTyped = '';
  }

  // Style the letters correctly
  Element textToTypeRegion = querySelector('#text-to-type');

  // for (int i = 0; i < textToType.length; i++) {
  //     if (i < textTyped.length) {
  //         if (textToType[i] == textTyped[i]) {
  //             textToTypeRegion.children.elementAt(i).className = 'typed';
  //         }
  //         if (textToType[i] != textTyped[i]) {
  //             textToTypeRegion.children.elementAt(i).className = 'not-typed';
  //         }
  //     }
  //     else {
  //         textToTypeRegion.children.elementAt(i).className = 'not-typed';
  //     }

  //     if (textToType[i] == ' ') {
  //         textToTypeRegion.children.elementAt(i).text = '\u{00A0}';
  //     }
  // }

  // Progress bar
  var maxTyped = 100;
  if (typedLetters <= maxTyped) {
    querySelector("#progress").children.elementAt(0).style.width =
        (typedLetters / maxTyped * 100.0).toString() + "%";
  } else {
    if (Uri.base.queryParameters.isNotEmpty) {
      window.location.href =
          'http://www.' + Uri.base.queryParameters['dest'] + '.com';
    }
  }
}

////////////////////////////////////////////////////////////////////////////////
