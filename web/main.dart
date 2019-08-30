///////////////////////////////////////////////////////////////////// Imports //
import 'dart:core';
import 'dart:html';
import 'dart:math';


//////////////////////////////////////////////////////////////////////// Main //
TextToType textToTypeObj = MostUsedEnglishWords();

void main()
{
    constructTextToTypeElement(
        textToTypeObj.generateText());

    window.onKeyDown.listen(handleWindowKeyDownEvent);
}

abstract class TextToType {
    String generateText();
}
class LeftHand extends TextToType
{
    int randomIntegerInRange(int min, int max)
        => (min + Random().nextInt(max - min + 1));

    @override
    String generateText() {
        String letters = "12345qwertasdfgzxcvb";
        String word = '';
        for (int i = 0; i < 10; i++) {
            word += letters[randomIntegerInRange(0, letters.length - 1)];
            word += ' ';
        }
        return word;
    }
}
class MostUsedEnglishWords extends TextToType
{
    int randomIntegerInRange(int min, int max)
        => (min + Random().nextInt(max - min + 1));

    @override
    String generateText() {
        List words = ["as", "I", "his", "that", "he", "was", "for", "on", "are", "with", "they", "be", "at", "one", "have", "this", "from", "by", "hot", "word", "but", "what", "some", "is", "it", "you", "or", "had", "the", "of", "to", "and", "a", "in", "we", "can", "out", "other", "were", "which", "do", "their", "time", "if", "will", "how", "said", "an", "each", "tell", "does", "set", "three", "want", "air", "well", "also", "play", "small", "end", "put", "home", "read", "hand", "port", "large", "spell", "add", "even", "land", "here", "must", "big", "high", "such", "follow", "act", "why", "ask", "men", "change", "went", "light", "kind", "off", "need", "house", "picture", "try", "us", "again", "animal", "point", "mother", "world", "near", "build", "self", "earth", "father"];
        String word = '';
        for (int i = 0; i < 5; i++) {
            word += words[randomIntegerInRange(0, words.length - 1)];
            word += ' ';
        }
        return word;
    }
}

class RandomTextToType extends TextToType
{
    String textToType;

    int randomIntegerInRange(int min, int max)
        => (min + Random().nextInt(max - min + 1));

    String generateRandomText(int length)
    {
        String randomWord = '';

        for (int i = 0; i < length; i++) {
            randomWord += String.fromCharCode(
                            randomIntegerInRange(
                                rangeMin.codeUnitAt(0),
                                rangeMax.codeUnitAt(0)));
        }
        return randomWord;
    }

    @override
    String generateText() {
        return generateRandomText(
                    randomIntegerInRange(minimumRandomTextToTypeLength,
                                         maximumRandomTextToTypeLength));
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


void constructTextToTypeElement(String text)
{
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


void handleWindowKeyDownEvent(Event event)
{
    if (!(event is KeyboardEvent)) {
        return;
    }

    //--------------------------------------------------------------------------
    bool isStringOneCharacter(String string)
        => (string.length == 1);

    bool isPressedKeyAcceptable(KeyboardEvent keyboardEvent)
        => isStringOneCharacter(keyboardEvent.key)
        && (keyboardEvent.key.codeUnitAt(0) >= rangeMin.codeUnitAt(0))
        && (keyboardEvent.key.codeUnitAt(0) <= rangeMax.codeUnitAt(0));


    //--------------------------------------------------------------------------
    KeyboardEvent keyboardEvent = event;

    if (keyboardEvent.key == 'Backspace') {
        querySelector('#text-to-type')
            .children.elementAt(textTyped.length - 1).className = "not-typed";

        textTyped = textTyped.substring(0, textTyped.length - 1);
    }

    if (isPressedKeyAcceptable(keyboardEvent) || keyboardEvent.key == "Space") {
        // Is pressed key correct?
        if (textToType[textTyped.length] == keyboardEvent.key) {
            querySelector('#text-to-type')
                .children.elementAt(textTyped.length).className = "typed";
            textTyped += keyboardEvent.key;
        }
        else {
            querySelector('#text-to-type')
                .children.elementAt(textTyped.length).className = "incorrect";
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
            textToTypeObj.generateText());
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


}


////////////////////////////////////////////////////////////////////////////////
