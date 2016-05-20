//
//  HelperFunctions.swift
//  PDU
//
//  Created by Pavle Mijatovic on 5/6/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation

// MARK: - PDU Number Formating
func numberInPDUFormat(number: String) -> String {
  let smscNumbNoPrefix = removePlusCharacterAtFirstPosition(number)
  let smscNumbArray = numbArrayPadLastElementForPDU(smscNumbNoPrefix.pairs)
  let smscNumbArraySwitchedCharPairs = switchCharPairsForEachElement(smscNumbArray)
  let smscNumbFinal = smscNumbArraySwitchedCharPairs.joinWithSeparator("")
  
  return smscNumbFinal
}

// MARK: - Helper
func stringToBinaryArray(myString:String, withPadSize padSize:Int) -> [String] {
  var binaryArray = stringToBinaryArray(myString)
  var tempArray = [String]()
  for binChar in binaryArray {
    let p = pad(binChar, toSize: padSize)
    tempArray.append(p)
  }
  
  binaryArray = tempArray
  return binaryArray
}

func stringToBinaryArray(myString:String) -> [String] {
  // Array of characters
  let characterArray = [Character](myString.characters)
  // Array of asccii value
  let asciiArray = characterArray.map({String($0).unicodeScalars.first!.value})
  // Array of binary value
  let binaryArray = asciiArray.map ({ String($0, radix: 2)})
  
  return binaryArray
}

func pad(string : String, toSize: Int) -> String {
  var padded = string
  for _ in 0..<toSize - string.characters.count {
    padded = "0" + padded
  }
  return padded
}

func padZerosToAString(numberOfZeros:Int, string: String) -> String {
  
  var zeroes = [String]()
  
  var i = 1
  while i <= numberOfZeros {
    zeroes.append("0")
    i = i + 1
  }
  
  let zStrings = zeroes.joinWithSeparator("")
  let finalString = zStrings + string
  finalString.characters.count
  
  return finalString
}

func numbArrayPadLastElementForPDU(numbArray: [String]) -> [String] {
  
  var smscNumbArray = numbArray
  // Add F to last index if last element has one char
  var lastPair = smscNumbArray.last
  if lastPair?.characters.count == 1 {
    lastPair = lastPair! + "F"
    smscNumbArray[smscNumbArray.count - 1] = lastPair!
  }
  
  return smscNumbArray
}

func switchCharPairsForEachElement(arrayOfChar: [String]) -> [String] {
  var tempReversedPair = [String]()
  for pair in arrayOfChar {
    let reversePair = String(pair.characters.reverse())
    tempReversedPair.append(reversePair)
  }
  return tempReversedPair
}

func removePlusCharacterAtFirstPosition(string: String) -> String {
  return removeCharInStringAtFirstPosition("+", inString: string)
}

// MARK: - Global functions
func indexOfFirstEscapedSpecialCharacter(specialChar: Character, string: String) -> Int {
  
  var indexOfChar = -1
  
  for (index, char) in string.characters.enumerate() {
    if char == "\r" {
      indexOfChar = index
      return indexOfChar
    }
  }
  
  return indexOfChar
}


func allIndexesOfEscapedSpecialCharacter(specialChar: Character, inString string: String) -> [Int] {
  
  var indexOfChar = -1
  var arrayOfSpecialChars = [Int]()
  
  
  for (index, char) in string.characters.enumerate() {
    if char == specialChar {
      indexOfChar = index
      arrayOfSpecialChars.append(indexOfChar)
    }
  }
  
  return arrayOfSpecialChars
}


func allIndexesOfAllEscapedSpecialCharacters(inString string: String) -> [Int] {
  
  var arrayOfSpecialChars = [Int]()
  let specialChars: [Character] = ["\0", "\\", "\t", "\n", "\r", "\"", "\'"]
  
  for (index, char) in string.characters.enumerate() {
    for specialChar in specialChars {
      if char == specialChar {
        arrayOfSpecialChars.append(index)
      }
    }
  }
  
  return arrayOfSpecialChars
}




func stringlengthInOctets(string: String) -> String {
  
  let charCount = string.characters.count
  let octetlength = charCount / 2
  
  return String(octetlength)
}

func removeCharInStringAtFirstPosition(char: Character, inString string: String) -> String {
  var tempString = string
  
  if string[string.startIndex] == char {
    tempString = String(string.characters.dropFirst())
  }
  return tempString
}

func textlengthInOctetsInHex(text: String) -> String {
  let hexlength = String(text.characters.count / 2).decimalToHexa2CharPadding
  return hexlength
}

func convertBinToHex(binArray: [String]) -> [String] {
  var hexArray = [String]()
  
  for char in binArray {
    var hex = char.binaryToHexa
    
    if hex.characters.count == 1 {
      hex = "0" + hex
    }
    
    hexArray.append(hex)
  }
  
  return hexArray
}

// MARK: - Print LOG helper
func aPrint(any: Any){
  print("🍏🍏🍏🍏🍏\(any)🍏🍏🍏🍏🍏")
}

func oPrint(any: Any){
  print("🍊🍊🍊🍊🍊\(any)🍊🍊🍊🍊🍊")
}