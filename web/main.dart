///////////////////////////////////////////////////////////////////// Imports //
import 'dart:core';
import 'dart:html';
import 'dart:math';


//////////////////////////////////////////////////////////////////////// Main //
void main()
{
    constructTextToTypeElement(
        generateRandomText(
            randomIntegerInRange(minimumRandomTextToTypeLength,
                                 maximumRandomTextToTypeLength)));

    window.onKeyDown.listen(handleWindowKeyDownEvent);
}

var minimumRandomTextToTypeLength = 4;
var maximumRandomTextToTypeLength = 6;


////////////////////////////////////////////////////////////////////////////////
var textToType = 'Text to type.';
String textTyped = '';
String rangeMin = '!';
String rangeMax = '~';
int errors = 0;
// String rangeMin = '0';
// String rangeMax = '9';

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

void constructTextToTypeElement(String text)
{
    Element output = querySelector('#text-to-type');
    output.children.clear();

    for (int i = 0; i < text.length; i++) {
        Element character = SpanElement();
        character.text = text[i];
        character.className = 'not-typed';
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

    if (isPressedKeyAcceptable(keyboardEvent)) {
        // Is pressed key correct?
        if (textToType[textTyped.length] == keyboardEvent.key) {
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
            generateRandomText(
                randomIntegerInRange(minimumRandomTextToTypeLength,
                                    maximumRandomTextToTypeLength)));
        textTyped = '';
    }

    // Style the letters correctly
    Element textToTypeRegion = querySelector('#text-to-type');

    for (int i = 0; i < textToType.length; i++) {
        if (i < textTyped.length) {
            if (textToType[i] == textTyped[i]) {
                textToTypeRegion.children.elementAt(i).className = 'typed';
            }
            if (textToType[i] != textTyped[i]) {
                textToTypeRegion.children.elementAt(i).className = 'not-typed';
            }
        }
        else {
            textToTypeRegion.children.elementAt(i).className = 'not-typed';
        }
    }


}


////////////////////////////////////////////////////////////////////////////////
