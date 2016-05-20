//
//  TPDU+Decoder.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/12/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation

extension TPDU {
  
  func decomposeTPDUPart(tpduPart: String) -> (tpduType: String, mssgRefNumber: String, lengthOfDestPhoneNum: String, typeOfPhoneNum: String, destPhoneNumber: String, protocolIdentifier: String, dataCodeScheme: String, lengthSMSBodyInSeptets: String, smsBody: String) {
    
    // The First Sub-field: First Octet of the TPDU
    let tpduS = tpduStartIndex
    let tpduE = tpduStartIndex + 1
    let tpduType = tpduPart[tpduS...tpduE]
    
    // The Second Sub-field: Message Reference Number
    let mssgRefNumberS = tpduE + 1
    let mssgRefNumberE = mssgRefNumberS + 1
    let mssgRefNumber = tpduPart[mssgRefNumberS...mssgRefNumberE]
    
    // The Third Sub-field: Length of the Destination Phone Number
    let lengthOfDestPhoneNumS = mssgRefNumberE + 1
    let lengthOfDestPhoneNumE = lengthOfDestPhoneNumS + 1
    let lengthOfDestPhoneNum = tpduPart[lengthOfDestPhoneNumS...lengthOfDestPhoneNumE]
    
    // The Fourth Sub-field: Type of the Destination Phone Number
    let typeOfPhoneNumS = lengthOfDestPhoneNumE + 1
    let typeOfPhoneNumE = typeOfPhoneNumS + 1
    let typeOfPhoneNum = tpduPart[typeOfPhoneNumS...typeOfPhoneNumE]
    
    // The Fifth Sub-field: Destination Phone Number
    var lengthOfDestPhoneNumInDigitsInt = lengthOfDestPhoneNum.hexaToInt
    
    let destPhoneNumberS = typeOfPhoneNumE + 1
    var destPhoneNumberE = destPhoneNumberS + lengthOfDestPhoneNumInDigitsInt
    
    var destPhoneNumber = tpduPart[destPhoneNumberS..<destPhoneNumberE]
    if destPhoneNumber.characters.last == "F" {
      lengthOfDestPhoneNumInDigitsInt += 1
      destPhoneNumberE = destPhoneNumberS + lengthOfDestPhoneNumInDigitsInt
      destPhoneNumber = tpduPart[destPhoneNumberS..<destPhoneNumberE]
    }
    
    // The Sixth Sub-field: Protocol Identifier
    let protocolIdentifierS = destPhoneNumberE
    let protocolIdentifierE = protocolIdentifierS + 1
    let protocolIdentifier = tpduPart[protocolIdentifierS...protocolIdentifierE]
    
    // The Seventh Sub-field: Data Coding Scheme
    let dataCodeSchemeS = protocolIdentifierE + 1
    let dataCodeSchemeE = dataCodeSchemeS + 1
    let dataCodeScheme = tpduPart[dataCodeSchemeS...dataCodeSchemeE]
    
    // The Eighth Sub-field: Length of the SMS Message Body
    let smsBodylengthS = dataCodeSchemeE + 1
    let smsBodylengthE = smsBodylengthS + 1
    let smsBodyInSeptets = tpduPart[smsBodylengthS...smsBodylengthE]
    
    // The Ninth Sub-field: SMS Message Body
    let smsBodyS = smsBodylengthE + 1
    let smsBodyE = tpduPart.characters.count - 1
   
    var smsBody = String()
    
    if !emptySMSMssBody(tpduPart, startIndexOfMssgBody: smsBodyS) {
      smsBody = tpduPart[smsBodyS...smsBodyE]
    }
    
    // Final result
    return (tpduType, mssgRefNumber, lengthOfDestPhoneNum, typeOfPhoneNum, destPhoneNumber, protocolIdentifier, dataCodeScheme, smsBodyInSeptets, smsBody)
  }
  
  func emptySMSMssBody(tpduPart: String, startIndexOfMssgBody: Int) -> Bool {
    return tpduPart.characters.count == startIndexOfMssgBody ? true : false
  }
  
  func destinationPhoneNumber(tpduPart: String, lengthStringHex: String, typeOfPhoneNumber: String) -> String {
    
    let length = lengthStringHex.hexaToInt
    var phoneNumbReversed = tpduPart[tpduPartStartPhoneNumberIndex...tpduPart.characters.count - 1]
    phoneNumbReversed = phoneNumbReversed[0...lengthStringHex.hexaToInt]
    
    let phoneNumbReveresedArray = phoneNumbReversed.pairs
    let switchedArray = switchCharPairsForEachElement(phoneNumbReveresedArray)
    
    var phoneNumb = switchedArray.joinWithSeparator("")
    phoneNumb = phoneNumb[0..<length]
    
    if typeOfPhoneNumber == SMS_NUMB_TYPE.international {
      phoneNumb = "+" + phoneNumb
    }
    
    return phoneNumb
  }
  
  func decodeSMSMssgBodyFromtext(text:String) -> String {
    
    let binArrayOctets = convertSMSBodyToBinArrayOfOctetsAndReverseIt(text)
    let binArraySeptets = convertBinArrayOfOctetsToBinArraySeptets(binArrayOctets)
    let finalString = decodeBinArrayOfSeptetsToUnicode(binArraySeptets)
    
    return finalString
  }
  
}

func convertSMSBodyToBinArrayOfOctetsAndReverseIt(text: String) -> [String] {
  
  var arrayOfBin = [String]()
  let arrayOfHex = text.pairs
  
  for hex in arrayOfHex {
    var bin = hex.hexaToBinary
    
    // Pad (fix) missing zeroes
    while bin.characters.count < 8 {
      bin = "0" + bin
    }
    
    arrayOfBin.append(bin)
  }
  
  arrayOfBin = arrayOfBin.reverse()
  return arrayOfBin
}

func convertBinArrayOfOctetsToBinArraySeptets(binArrayOctets: [String]) -> [String] {
  var string = binArrayOctets.joinWithSeparator("")
  
  let zeroesToRemove = string.characters.count % 7
  
  string = (string as NSString).substringFromIndex(zeroesToRemove)
  
  var septets = string.septets
  septets = septets.reverse()
  return septets
}

func decodeBinArrayOfSeptetsToUnicode(binArraySeptets: [String]) -> String {
  var finalString = ""
 
  for septet in binArraySeptets {
    let binary = septet
    let number = strtoul(binary, nil, 2)
    
    let x = UInt32(number)
    
    if x != 0 {
      finalString.append(UnicodeScalar(x))
    }
  }
  
  return finalString
}