//
//  SMSC+Decoder.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/16/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation

extension SMSC {
  
  // MARK: Decode
  func decomposeSMSCPart(smsc: String) -> (String, String, String) {
    
    // The First Sub-field: Length of the Second and Third Sub-fields
    let lengthSMSCSecondAndThirdFieldS = 0
    let lengthSMSCSecondAndThirdFieldE = 1
    let lengthSMSCSecondAndThirdField = smsc[lengthSMSCSecondAndThirdFieldS...lengthSMSCSecondAndThirdFieldE]
    
    // The Second Sub-field: Type of SMSC Number
    let typeOfPhoneNumS = lengthSMSCSecondAndThirdFieldE + 1
    let typeOfPhoneNumE = typeOfPhoneNumS + 1
    let typeOfPhoneNum = smsc[typeOfPhoneNumS...typeOfPhoneNumE]
    
    // The Third Sub-field: SMSC Number
    let smscNumbS = typeOfPhoneNumE + 1
    let smscNumbE = smsc.characters.count - 1
    let smscNumb = smsc[smscNumbS...smscNumbE]
    
    return (lengthSMSCSecondAndThirdField, typeOfPhoneNum, smscNumb)
  }
  
  func senderSMSCNumber(number: String, numberType: String) -> String {
    var smscNumber = number
    var smscNumberArray = smscNumber.pairs
    smscNumberArray = switchCharPairsForEachElement(smscNumberArray)
    smscNumber.removeAll()
    smscNumber = smscNumberArray.joinWithSeparator("")
    
    if smscNumber.characters.last == "F" {
      smscNumber = smscNumber.substringToIndex(smscNumber.endIndex.predecessor())
    }
    
    if numberType == SMS_NUMB_TYPE.international {
      smscNumber = "+" + smscNumber
    }
    
    return smscNumber
  }
}