////////////////////////////////////////////////////// Imports //
import 'dart:convert';
import 'dart:core';
import 'dart:html';
import 'dart:math';

///////////////////////////////////////////////////////// Main //
void main() async {
  await textToTypeObj.initialize('packs/english-words.json');
  constructTextToTypeElement(await textToTypeObj.generateText());

  await constructButtons();
  window.onKeyDown.listen(handleWindowKeyDownEvent);
  window.onMouseMove.listen(doTheCoolButtonEffect);
}

////////////////////////////////////// TODO: Name this section //
var typedLetters = 0;
TextToType textToTypeObj = TextToType();

void handleClickDefault(Event event) async {
  // textToTypeObj = DefaultText();
  // await textToTypeObj.initialize();
  // constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClickSymbols(Event event) async {
  textToTypeObj = TextToType();
  await textToTypeObj.initialize('packs/programming-symbols.json');
  constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClickDigits(Event event) async {
  textToTypeObj = TextToType();
  await textToTypeObj.initialize('packs/programming-digits.json');
  constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClick9(Event event) async {
  textToTypeObj = TextToType();
  await textToTypeObj.initialize('packs/programming.json');
  constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClick(Event event) async {
  textToTypeObj = TextToType();
  await textToTypeObj.initialize('packs/english-words.json');
  constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClick2(Event event) async {
  // textToTypeObj = RandomTextToType();
  // await textToTypeObj.initialize();
  // constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClick3(Event event) async {
  // textToTypeObj = LeftHand();
  // await textToTypeObj.initialize();
  // constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClick4(Event event) async {
  // textToTypeObj = MostCommonTrigraphs();
  // await textToTypeObj.initialize();
  // constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClick5(Event event) async {
  // textToTypeObj = MostCommonBigraphs();
  // await textToTypeObj.initialize();
  // constructTextToTypeElement(await textToTypeObj.generateText());
}

void constructButtons() async {
  var typingModeButtonsContainer = querySelector('#typing-mode-buttons')
    ..children.clear();

  var buttonInfo = [
    ['English words', handleClick],
    ['Programming (digits + symbols)', handleClick9],
    ['Digits', handleClickDigits],
    ['Symbols', handleClickSymbols],
    // ['*Polish words*', handleClickDefault], //!!!
    // ['*Random words*', handleClickDefault],
    // ['*Left hand*', handleClickDefault],
    // ['*Right hand*', handleClickDefault], //!!!
    // ['*Lower-case*', handleClickDefault], //!!!
    // ['*Upper-case*', handleClickDefault], //!!!
    // ['*1-grams*', handleClickDefault], //!!!
    // ['*2-grams*', handleClick5],
    // ['*3-grams*', handleClick4],
    // ['*4-grams*', handleClickDefault], //!!!
    // ['*5-grams*', handleClickDefault], //!!!
    // ['*6-grams*', handleClickDefault], //!!!
    // ['*7-grams*', handleClickDefault], //!!!
    // ['*8-grams*', handleClickDefault], //!!!
    // ['*9-grams*', handleClickDefault] //!!!
  ];

  for (int i = 0; i < buttonInfo.length; i++) {
    if (i != 0 && i % 9 == 0) {
      typingModeButtonsContainer.children.add(BRElement());
    }
    typingModeButtonsContainer.children.add(DivElement()
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

class TextToType {
  List<List<dynamic>> words;

  void initialize(String filename) async {
    words = await loadData(filename);
  }

  Future<List<List<dynamic>>> loadData(String filename) async {
    return (json.decode(await HttpRequest.getString(filename)) as List)
        .cast<List<dynamic>>();
  }

  Future<String> generateText() async {
    double randomDouble = Random().nextDouble();

    double sum = 0.0;
    for (int i = 0; i < words.length; i++) {
      if (randomDouble >= sum && randomDouble < sum + words[i][1]) {
        return words[i][0];
      }
      sum += words[i][1];
    }
    assert(sum >= 1.0);
    return words[0][0];
  }
}

class DefaultText extends TextToType {
  @override
  Future<String> generateText() async {
    return ' ';
  }
}

// class MostCommonBigraphs extends TextToType {
//   List<String> words;

//   @override
//   void initialize() async {
//     words = await loadData();
//   }

//   Future<List<String>> loadData() async {
//     String jsonString = await HttpRequest.getString('packs/bigraphs.json');
//     var siema = json.decode(jsonString) as List;
//     return siema.cast<String>();
//   }

//   int randomIntegerInRange(int min, int max) =>
//       (min + Random().nextInt(max - min + 1));

//   int repeat = 0;
//   String word;

//   @override
//   Future<String> generateText() async {
//     if (repeat == 0) {
//       word = words[randomIntegerInRange(0, words.length - 1)];
//     }
//     repeat = repeat + 1;
//     if (repeat == 1) {
//       repeat = 0;
//     }
//     return word;
//   }
// }

// class MostCommonTrigraphs extends TextToType {
//   int randomIntegerInRange(int min, int max) =>
//       (min + Random().nextInt(max - min + 1));

//   int repeat = 0;
//   String word;

//   @override
//   Future<String> generateText() async {
//     List words = [
//       "the",
//       "and",
//       "ing",
//       "her",
//       "hat",
//       "his",
//       "tha",
//       "ere",
//       "for",
//       "ent",
//       "ion",
//       "ter",
//       "was",
//       "you",
//       "ith",
//       "ver",
//       "all",
//       "wit",
//       "thi",
//       "tio"
//     ];
//     if (repeat == 0) {
//       word = words[randomIntegerInRange(0, words.length - 1)];
//     }
//     repeat = repeat + 1;
//     if (repeat == 1) {
//       repeat = 0;
//     }
//     return word;
//   }
// }

// class LeftHand extends TextToType {
//   int randomIntegerInRange(int min, int max) =>
//       (min + Random().nextInt(max - min + 1));

//   @override
//   Future<String> generateText() async {
//     String letters = "12345qwertasdfgzxcvb";
//     String word = '';
//     for (int i = 0; i < 10; i++) {
//       word += letters[randomIntegerInRange(0, letters.length - 1)];
//       word += ' ';
//     }
//     return word;
//   }
// }

// class MostUsedEnglishWords extends TextToType {
//   List<List<dynamic>> words;

//   @override
//   void initialize() async {
//     words = await loadData();
//   }

//   Future<List<List<dynamic>>> loadData() async {
//     String jsonString = await HttpRequest.getString('packs/english-words.json');
//     var siema = json.decode(jsonString) as List;
//     return siema.cast<List<dynamic>>();
//   }

//   @override
//   Future<String> generateText() async {
//     double tempSumof10 = 0.0;
//     for (int i = 0; i < words.length / 10; i++) {
//       tempSumof10 += words[i][1];
//     }
//     double rando = Random().nextDouble() * tempSumof10; //100words

//     double sum = 0.0;
//     for (int i = 0; i < words.length; i++) {
//       if (rando >= sum && rando < sum + words[i][1]) {
//         print(i + 1);
//         return words[i][0];
//       }
//       sum += words[i][1];
//     }
//     assert(sum >= 1.0);
//     return words[0][0];
//   }
// }

// class RandomTextToType extends TextToType {
//   String textToType;

//   int randomIntegerInRange(int min, int max) =>
//       (min + Random().nextInt(max - min + 1));

//   String generateRandomText(int length) {
//     String randomWord = '';

//     for (int i = 0; i < length; i++) {
//       randomWord += String.fromCharCode(
//           randomIntegerInRange(rangeMin.codeUnitAt(0), rangeMax.codeUnitAt(0)));
//     }
//     return randomWord;
//   }

//   @override
//   Future<String> generateText() async {
//     return generateRandomText(randomIntegerInRange(
//         minimumRandomTextToTypeLength, maximumRandomTextToTypeLength));
//   }
// }

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
  var maxTyped = 1000;
  if (typedLetters <= maxTyped) {
    querySelector("#typed-characters-progress-bar")
        .children
        .elementAt(0)
        .style
        .width = (typedLetters / maxTyped * 100.0).toString() + "%";
  } else {
    if (Uri.base.queryParameters.isNotEmpty) {
      window.location.href =
          'http://www.' + Uri.base.queryParameters['dest'] + '.com';
    }
  }
}

/////////////////////////////////////////////////////////////////
