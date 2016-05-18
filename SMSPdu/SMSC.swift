//
//  SMSC.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/11/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

// Example - 07 91 5892000000F0
// ----------------------------------------------------------------------------------------------------
// 07           -> length in octets of the following two sub-fields
// 91           -> type of the SMSC number assigned to the third sub-field.
// 5892000000F0 -> SMSC number for sending the SMS message


import Foundation

class SMSC {
  
  // MARK: - Properties -
  let smscNumberType = SMS_NUMB_TYPE.international

  var smscNumber = ""
}