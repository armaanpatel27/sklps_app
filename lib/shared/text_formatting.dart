import 'package:flutter/material.dart';
class TextFormatting {

  //purpose: capitalizes first letter of the text to allow for search to match Firestore data
  String formatEnteredText(String enteredText){

    //if string is too short --> no need to reformat because search does not get performed anyways
    if(enteredText.length < 3){
      return enteredText;
    }


    String firstLetter = enteredText[0].toUpperCase();
    enteredText = firstLetter + enteredText.substring(1).toLowerCase();

    //if input text contains space --> capitalize first letter of every word
    for (int i = 1; i < enteredText.length - 1; i++) {
      if (enteredText[i] == " ") {
        String uppercaseLetter = enteredText[i + 1].toUpperCase();
        enteredText = enteredText.substring(0, i + 1) + uppercaseLetter +
            enteredText.substring(i + 2);
      }
    }
    return enteredText;
  }


}