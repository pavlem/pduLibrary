//
//  SMSC+Encoder.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/16/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

// Example - 07 91 5892000000F0
// ----------------------------------------------------------------------------------------------------
// 07           -> length in octets of the following two sub-fields
// 91           -> type of the SMSC number assigned to the third sub-field.
// 5892000000F0 -> SMSC number for sending the SMS message
// ----------------------------------------------------------------------------------------------------

import Foundation

extension SMSC {
  
  func encodeSMSCPart() -> String {
    let smscNumber = numberInPDUFormat(self.smscNumber)
    let smscNumberType = self.smscNumberType
    let octetLenghtOfTwoSubfields = textLenghtInOctetsInHex(smscNumber + smscNumberType)
    return octetLenghtOfTwoSubfields + smscNumberType + smscNumber
  }
}