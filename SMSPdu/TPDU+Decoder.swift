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
    aPrint(tpduType)
    
    // The Second Sub-field: Message Reference Number
    let mssgRefNumberS = tpduE + 1
    let mssgRefNumberE = mssgRefNumberS + 1
    let mssgRefNumber = tpduPart[mssgRefNumberS...mssgRefNumberE]
    aPrint(mssgRefNumber)

    // The Third Sub-field: Length of the Destination Phone Number
    let lenghtOfDestPhoneNumS = mssgRefNumberE + 1
    let lenghtOfDestPhoneNumE = lenghtOfDestPhoneNumS + 1
    let lenghtOfDestPhoneNum = tpduPart[lenghtOfDestPhoneNumS...lenghtOfDestPhoneNumE]
    aPrint(lenghtOfDestPhoneNum)

    // The Fourth Sub-field: Type of the Destination Phone Number
    let typeOfPhoneNumS = lenghtOfDestPhoneNumE + 1
    let typeOfPhoneNumE = typeOfPhoneNumS + 1
    let typeOfPhoneNum = tpduPart[typeOfPhoneNumS...typeOfPhoneNumE]
    aPrint(typeOfPhoneNum)

    // The Fifth Sub-field: Destination Phone Number
    var lenghtOfDestPhoneNumInDigitsInt = lenghtOfDestPhoneNum.hexaToInt
//    let destPhoneNum = destinationPhoneNumber(tpduPart, lenght: lenghtOfDestPhoneNumInt, typeOfPhoneNumber: typeOfPhoneNum)
    
    // TODO: UNIT TEST
    let destPhoneNumberS = typeOfPhoneNumE + 1
    var destPhoneNumberE = destPhoneNumberS + lenghtOfDestPhoneNumInDigitsInt

    var destPhoneNumber = tpduPart[destPhoneNumberS..<destPhoneNumberE]
    if destPhoneNumber.characters.last == "F" {
      lenghtOfDestPhoneNumInDigitsInt += 1
      destPhoneNumberE = destPhoneNumberS + lenghtOfDestPhoneNumInDigitsInt
      destPhoneNumber = tpduPart[destPhoneNumberS..<destPhoneNumberE]
    }
    aPrint(destPhoneNumber)

    // The Sixth Sub-field: Protocol Identifier
    let protocolIdentifierS = destPhoneNumberE
    let protocolIdentifierE = protocolIdentifierS + 1
    let protocolIdentifier = tpduPart[protocolIdentifierS...protocolIdentifierE]
    aPrint(protocolIdentifier)

    
    // The Seventh Sub-field: Data Coding Scheme
    let dataCodeSchemeS = protocolIdentifierE + 1
    let dataCodeSchemeE = dataCodeSchemeS + 1
    let dataCodeScheme = tpduPart[dataCodeSchemeS...dataCodeSchemeE]
    aPrint(dataCodeScheme)

    // The Eighth Sub-field: Length of the SMS Message Body
    let smsBodyLenghtS = dataCodeSchemeE + 1
    let smsBodyLenghtE = smsBodyLenghtS + 1
    let smsBodyInSeptets = tpduPart[smsBodyLenghtS...smsBodyLenghtE]
    aPrint(smsBodyInSeptets)

    // The Ninth Sub-field: SMS Message Body
    let smsBodyLenghtInChars = calculateCharLenghtForSmsBody(smsBodyInSeptets)
    let smsBodyS = smsBodyLenghtE + 1
//    let smsBodyE = smsBodyS + smsBodyLenghtInChars - 1
    let smsBodyE = tpduPart.characters.count - 1

    let smsBody = tpduPart[smsBodyS...smsBodyE]
    aPrint(smsBody)

    return (tpduType, mssgRefNumber, lenghtOfDestPhoneNum, typeOfPhoneNum, destPhoneNumber, protocolIdentifier, dataCodeScheme, smsBodyInSeptets, smsBody)
  }
  
  func calculateCharLenghtForSmsBody(lenghtHex:String) -> Int {
    let lenghtIntInSeptets = lenghtHex.hexaToInt * 7
    let lenghtIntForSMSBodyInStringCharacters = ((lenghtIntInSeptets + (8 - lenghtIntInSeptets % 8)) / 8 ) * 2
    return lenghtIntForSMSBodyInStringCharacters
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
}


