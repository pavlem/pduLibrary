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
    let lenghtSMSCSecondAndThirdFieldS = 0
    let lenghtSMSCSecondAndThirdFieldE = 1
    let lenghtSMSCSecondAndThirdField = smsc[lenghtSMSCSecondAndThirdFieldS...lenghtSMSCSecondAndThirdFieldE]
    
    // The Second Sub-field: Type of SMSC Number
    let typeOfPhoneNumS = lenghtSMSCSecondAndThirdFieldE + 1
    let typeOfPhoneNumE = typeOfPhoneNumS + 1
    let typeOfPhoneNum = smsc[typeOfPhoneNumS...typeOfPhoneNumE]
    
    // The Third Sub-field: SMSC Number
    let smscNumbS = typeOfPhoneNumE + 1
    let smscNumbE = smsc.characters.count - 1
    let smscNumb = smsc[smscNumbS...smscNumbE]
    
    return (lenghtSMSCSecondAndThirdField, typeOfPhoneNum, smscNumb)
  }
}