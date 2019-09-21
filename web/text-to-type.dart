////////////////////////////////////////////////////// Imports //
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:html';
import 'dart:math';

/////////////////////////////////////////////////////////////////
var randomNumberGenerator = Random();

var maxTyped = 50;

void setupEventListeners() {
  window.onKeyDown.listen(handleWindowKeyDownEvent);
  window.onMouseMove.listen(doTheCoolButtonEffect);
}

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

void handleButtonsFadeout() async {}

////////////////////////////////////// TODO: Name this section //
var typedLetters = 0;
TextToType textToTypeObj = TextToType();

void handleClickDefault(Event event) async {
  // textToTypeObj = DefaultText();
  // await textToTypeObj.initialize();
  // constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClickRandom(Event event) async {
  textToTypeObj = RandomWords();
  await textToTypeObj.initialize('');
  constructTextToTypeElement(await textToTypeObj.generateText());
}

void handleClick(Event event, String jsonFilename) async {
  textToTypeObj = TextToType();
  await textToTypeObj.initialize(jsonFilename);
  constructTextToTypeElement(await textToTypeObj.generateText());
}

void constructButtons() async {
  var typingModeButtonsContainer =
      querySelector('#typing-mode-buttons')..children.clear();

  var buttonInfo = [
    [
      'Polish words',
      (Event event) =>
          handleClick(event, 'packs/polish/1grams.json')
    ],
    [
      'English words',
      (Event event) =>
          handleClick(event, 'packs/english-words.json')
    ],
    [
      'Statistical random words (English)',
      (Event event) => handleClickRandom(event)
    ],
    [
      '2-grams',
      (Event event) =>
          handleClick(event, 'packs/ngrams/2-grams.json')
    ],
    [
      '3-grams',
      (Event event) =>
          handleClick(event, 'packs/ngrams/3-grams.json')
    ],
    [
      'Digits',
      (Event event) =>
          handleClick(event, 'packs/programming-digits.json')
    ],
    [
      'Symbols',
      (Event event) =>
          handleClick(event, 'packs/programming-symbols.json')
    ],
    [
      'Programming (digits + symbols)',
      (Event event) =>
          handleClick(event, 'packs/programming.json')
    ],
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

Timer timer = Timer(Duration(seconds: 1), () {});

void doTheCoolButtonEffect(MouseEvent event) {
  var buttons = querySelectorAll('.button');

  //-----------------------------------------
  // move mouse history
  var mouseX = event.client.x;
  var mouseY = event.client.y;

  // change this number to something with closest button or div
  if (mouseY > 250) {
    timer.cancel();
    timer = Timer(Duration(seconds: 1), () {
      buttons.style.transition = 'opacity 2s ease-in-out 0s';
      for (int i = 0; i < buttons.length; i++) {
        buttons[i].style.opacity = '0.0';
      }
    });
  }

  buttons.style.transition = 'opacity 0.25s';
  for (int i = 0; i < buttons.length; i++) {
    buttons[i].style.opacity = '1.0';
  }

  //-----------------------------------------

  for (int i = 0; i < buttons.length; i++) {
    double opacity = 0.0;

    var buttonCenterX = buttons[i].borderEdge.left +
        buttons[i].borderEdge.width / 2;
    var buttonCenterY = buttons[i].borderEdge.top +
        buttons[i].borderEdge.height / 2;
    var distance = sqrt(pow(buttonCenterX - mouseX, 2) +
        pow(buttonCenterY - mouseY, 2));

    //TODO: make this function not linear
    var maxDist =
        min(window.outerWidth, window.innerHeight) * 0.8;
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
      buttons[i].style.opacity =
          (0.75 * opacity + 0.0).toString();
    }
  }
}

class TextToType {
  List<List<dynamic>> words;

  void initialize(String filename) async {
    words = await loadData(filename);
  }

  Future<List<List<dynamic>>> loadData(String filename) async {
    return (json.decode(await HttpRequest.getString(filename))
            as List)
        .cast<List<dynamic>>();
  }

  Future<String> generateText() async {
    double randomDouble = randomNumberGenerator.nextDouble();

    double sum = 0.0;
    for (int i = 0; i < words.length; i++) {
      if (randomDouble >= sum &&
          randomDouble < sum + words[i][1]) {
        return words[i][0];
      }
      sum += words[i][1];
    }

    throw Exception("Probability exceeds or equals 1.0");
  }
}

class RandomWords extends TextToType {
  List<List<dynamic>> letters, lengths;

  void initialize(String filename) async {
    letters = await loadData('packs/letters.json');
    lengths = await loadData('packs/word-length.json');
  }

  Future<List<List<dynamic>>> loadData(String filename) async {
    return (json.decode(await HttpRequest.getString(filename))
            as List)
        .cast<List<dynamic>>();
  }

  int numberIndex(int letterIndex, int wordLength) {
// 1-gram,
// */*,1/*,2/*,3/*,4/*,5/*,6/*,7/*,8/*,9/*,
// 1/1:1,
// 2/1:1,2/2:2,
// 3/1:1,3/2:2,3/3:3,
// 4/1:1,4/2:2,4/3:3,4/4:4,
// 5/1:1,5/2:2,5/3:3,5/4:4,5/5:5,
// 6/1:1,6/2:2,6/3:3,6/4:4,6/5:5,6/6:6,
// 7/1:1,7/2:2,7/3:3,7/4:4,7/5:5,7/6:6,7/7:7,
// 8/1:1,8/2:2,8/3:3,8/4:4,8/5:5,8/6:6,8/7:7,8/8:8,
// 9/1:1,9/2:2,9/3:3,9/4:4,9/5:5,9/6:6,9/7:7,9/8:8,9/9:9,
// */1:1,*/2:2,*/3:3,*/4:4,*/5:5,*/6:6,*/7:7,*/8:8,*/9:9,
// */-9:-9,*/-8:-8,*/-7:-7,*/-6:-6,*/-5:-5,*/-4:-4,*/-3:-3,*/-2:-2,*/-1:-1

    int constant = 10;
    for (int i = 0; i < wordLength; i++) {
      constant += i;
    }
    return constant + letterIndex;
  }

  int randomIntegerInRange(int min, int max) =>
      (min + randomNumberGenerator.nextInt(max - min + 1));

  Future<String> generateText() async {
    String text = "";
    int numberOfWords = randomIntegerInRange(1, 6);

    for (int y = 0; y < numberOfWords; y++) {
      int length = await generateLength();

      for (int x = 0; x < length; x++) {
        double randomDouble = randomNumberGenerator.nextDouble();

        double sum = 0.0;
        for (int i = 0; i < letters.length; i++) {
          if (randomDouble >= sum &&
              randomDouble <
                  sum + letters[i][numberIndex(x, length)]) {
            text += letters[i][0];
            break;
          }
          sum += letters[i][numberIndex(x, length)];
        }
      }

      text += " ";
    }

    return text;
  }

  Future<int> generateLength() async {
    double randomDouble = randomNumberGenerator.nextDouble();

    double sum = 0.0;
    for (int i = 0; i < lengths.length; i++) {
      if (randomDouble >= sum &&
          randomDouble < sum + lengths[i][1]) {
        return lengths[i][0];
      }
      sum += lengths[i][1];
    }
    assert(sum >= 1.0);
    return lengths[0][0];
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

// /////////////////////////////////////////// Event: key down //
void handleWindowKeyDownEvent(Event event) async {
  // -------------------------------------- Local functions -- //
  bool isPressedKeyAcceptable(KeyboardEvent keyboardEvent) =>
      (keyboardEvent.key.length == 1) &&
          (keyboardEvent.key.codeUnitAt(0) >=
              rangeMin.codeUnitAt(0)) &&
          (keyboardEvent.key.codeUnitAt(0) <=
              rangeMax.codeUnitAt(0)) ||
      ([
        'ą',
        'Ą',
        'ć',
        'Ć',
        'ę',
        'Ę',
        'ł',
        'Ł',
        'ń',
        'Ń',
        'ó',
        'Ó',
        'ś',
        'Ś',
        'ź',
        'Ź',
        'ż',
        'Ż'
      ].contains(keyboardEvent.key));

  //-------------------------------------------------------------
  if (event is! KeyboardEvent) {
    return;
  }

  KeyboardEvent keyboardEvent = event;

  if (keyboardEvent.key == 'Backspace') {
    querySelector('#text-to-type')
        .children
        .elementAt(textTyped.length - 1)
        .className = "not-typed";

    textTyped = textTyped.substring(0, textTyped.length - 1);
  }

  if (isPressedKeyAcceptable(keyboardEvent) ||
      keyboardEvent.key == "Space") {
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
    constructTextToTypeElement(
        await textToTypeObj.generateText());
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
  if (typedLetters <= maxTyped) {
    querySelector("#typed-characters-progress-bar")
            .children
            .elementAt(0)
            .style
            .width =
        (typedLetters / maxTyped * 100.0).toString() + "%";
  }

  if (typedLetters == maxTyped) {
    if (Uri.base.queryParameters.containsKey('redirect-to')) {
      querySelector('.destination')
        ..style.color = 'var(--color-5)'
        ..style.transition = 'color 1.5s ease-in 0s';

      querySelector('#text-to-type')
        ..style.opacity = '0.2'
        ..style.transition = 'opacity 1.5s ease-out 0s';

      querySelector('#typing-mode-buttons')
        ..style.opacity = '0.2'
        ..style.transition = 'opacity 1.5s ease-out 0s';

      Timer(Duration(seconds: 2), () {
        if (Uri.base.queryParameters
            .containsKey('redirect-to')) {
          window.location.href = 'http://' +
              Uri.base.queryParameters['redirect-to'] +
              '.com';
        }
      });
    }
  }
}

/////////////////////////////////////////////////////////////////
