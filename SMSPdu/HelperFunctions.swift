//
//  HelperFunctions.swift
//  PDU
//
//  Created by Pavle Mijatovic on 5/6/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation

func arrayOfCharacters(myString:String) -> [Character] {
  let characterArray = [Character](myString.characters)
  return characterArray
}

func arrayOfAscciiValue(characterArray:[Character]) -> [UInt32] {
  let asciiArray = characterArray.map({String($0).unicodeScalars.first!.value})
  return asciiArray
}

func arrayOfBinaryValue(asciiArray:[UInt32]) -> [String] {
  let binaryArray = asciiArray.map ({ String($0, radix: 2)})
  return binaryArray
}

func stringToBinaryString (myString:String) -> String {
  // Array of characters
  let characterArray = [Character](myString.characters)
  // Array of asccii value
  let asciiArray = characterArray.map({String($0).unicodeScalars.first!.value})
  // Array of binary value
  let binaryArray = asciiArray.map ({ String($0, radix: 2)})
  // Reduce in a String
  let r = binaryArray.reduce("",combine: {$0 + "" + $1})
  
  return r
}

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

func binaryValuesAsString(binaryArray:[String]) -> String {
  let r = binaryArray.reduce("",combine: {$0 + "" + $1})
  return r
}

func padZerosToAString(numberOfZeros:Int, stringS: String) -> String {
  
  var zeroes = [String]()
  
  var i = 1
  while i <= numberOfZeros {
    zeroes.append("0")
    i = i + 1
  }
  
  let zStrings = zeroes.joinWithSeparator("")
  let finalString = zStrings + stringS
  finalString.characters.count
  
  return finalString
}

func binToHex(bin : String) -> String {
  // binary to integer:
  let num = bin.withCString { strtoul($0, nil, 2) }
  // integer to hex:
  let hex = String(num, radix: 16, uppercase: true) // (or false)
  return hex
}

// MARK: - PDU Number Formating
func phoneNumberInPDU(number: String) -> String {
  let smscNumbNoPrefix = removePlusCharacterAtFirstPosition(number)
  let smscNumbArray = smscNumbArrayPadLastElement(smscNumbNoPrefix.pairs)
  let smscNumbNoFinal = smscNumbArray.joinWithSeparator("")
  
  return smscNumbNoFinal
}

func smscNumbArrayPadLastElement(numbArray: [String]) -> [String] {
  
  var smscNumbArray = numbArray
  
  // Add F to last index if last element has one char
  var lastPair = smscNumbArray.last
  if lastPair?.characters.count == 1 {
    lastPair = lastPair! + "F"
    smscNumbArray[smscNumbArray.count - 1] = lastPair!
  }
  
  return switchCharPairsForEachElement(smscNumbArray)
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
func removeCharInStringAtFirstPosition(char: Character, inString string: String) -> String {
  var tempString = string
  
  if string[string.startIndex] == char {
    tempString = String(string.characters.dropFirst())
  }
  return tempString
}

func textLenghtInOctetsInHex(text: String) -> String {
  let hexLenght = String(text.characters.count / 2).decimalToHexa2CharPadding
  return hexLenght
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