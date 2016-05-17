//
//  TPDU+Decoder.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/12/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation

extension TPDU {

  func decomposeTPDUPart(tpduPart: String) -> (tpduType: String, mssgRefNumber: String, lenghtOfDestPhoneNum: String, typeOfPhoneNum: String, destPhoneNumber: String, protocolIdentifier: String, dataCodeScheme: String, lenghtSMSBodyInSeptets: String, smsBody: String) {
    
    // The First Sub-field: First Octet of the TPDU
    let tpduS = 0
    let tpduE = tpduS + 1
    let tpduType = tpduPart[tpduS...tpduE]
    
    // The Second Sub-field: Message Reference Number
    let mssgRefNumberS = tpduE + 1
    let mssgRefNumberE = mssgRefNumberS + 1
    let mssgRefNumber = tpduPart[mssgRefNumberS...mssgRefNumberE]

    // The Third Sub-field: Length of the Destination Phone Number
    let lenghtOfDestPhoneNumS = mssgRefNumberE + 1
    let lenghtOfDestPhoneNumE = lenghtOfDestPhoneNumS + 1
    let lenghtOfDestPhoneNum = tpduPart[lenghtOfDestPhoneNumS...lenghtOfDestPhoneNumE]

    // The Fourth Sub-field: Type of the Destination Phone Number
    let typeOfPhoneNumS = lenghtOfDestPhoneNumE + 1
    let typeOfPhoneNumE = typeOfPhoneNumS + 1
    let typeOfPhoneNum = tpduPart[typeOfPhoneNumS...typeOfPhoneNumE]

    // The Fifth Sub-field: Destination Phone Number
    var lenghtOfDestPhoneNumInDigitsInt = lenghtOfDestPhoneNum.hexaToInt
    
    let destPhoneNumberS = typeOfPhoneNumE + 1
    var destPhoneNumberE = destPhoneNumberS + lenghtOfDestPhoneNumInDigitsInt

    var destPhoneNumber = tpduPart[destPhoneNumberS..<destPhoneNumberE]
    if destPhoneNumber.characters.last == "F" {
      lenghtOfDestPhoneNumInDigitsInt += 1
      destPhoneNumberE = destPhoneNumberS + lenghtOfDestPhoneNumInDigitsInt
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
    let smsBodyLenghtS = dataCodeSchemeE + 1
    let smsBodyLenghtE = smsBodyLenghtS + 1
    let smsBodyInSeptets = tpduPart[smsBodyLenghtS...smsBodyLenghtE]

    // The Ninth Sub-field: SMS Message Body
    var smsBody = String()
    
    let smsBodyS = smsBodyLenghtE + 1
    let smsBodyE = tpduPart.characters.count - 1
    
    guard tpduPart.characters.count == smsBodyLenghtS
      else {
        smsBody = ""
        return (tpduType, mssgRefNumber, lenghtOfDestPhoneNum, typeOfPhoneNum, destPhoneNumber, protocolIdentifier, dataCodeScheme, smsBodyInSeptets, smsBody)
    }
    
    smsBody = tpduPart[smsBodyS...smsBodyE]

    // Final result
    return (tpduType, mssgRefNumber, lenghtOfDestPhoneNum, typeOfPhoneNum, destPhoneNumber, protocolIdentifier, dataCodeScheme, smsBodyInSeptets, smsBody)
  }
  
  func destinationPhoneNumber(tpduPart: String, lenghtStringHex: String, typeOfPhoneNumber: String) -> String {
    
    let lenght = lenghtStringHex.hexaToInt
    
    var phoneNumb = tpduPart[8...tpduPart.characters.count - 1]
    phoneNumb = phoneNumb[0...lenght]
    
    let phoneNumbArray = phoneNumb.pairs
    let switchedArray = switchCharPairsForEachElement(phoneNumbArray)
    
    var phoneNumbString = switchedArray.joinWithSeparator("")
    
    if phoneNumbString.characters.last == "F" {
      phoneNumbString = String(phoneNumbString.characters.dropLast())
    }
    
    if typeOfPhoneNumber == SMS_NUMB_TYPE.international {
      phoneNumbString = "+" + phoneNumbString
    }
    
    return phoneNumbString
  }
  
  func decodeSMSMssgBodyFromtext(text:String) -> String {
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
    
    var string = arrayOfBin.joinWithSeparator("")
    
    let zeroesToRemove = string.characters.count % 7
    
    string = (string as NSString).substringFromIndex(zeroesToRemove) // "
    
    var septets = string.septets
    septets = septets.reverse()
    
    var finalString = ""
    for septet in septets {
      
      let binary = septet
      let number = strtoul(binary, nil, 2)
      
      let x = UInt32(number)
      
      finalString.append(UnicodeScalar(x))
    }
    
    return finalString
  }

}


