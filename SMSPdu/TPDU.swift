//
//  TPDU.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/11/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

// Example - 01 00 0B 91 5892214365F7 00 00 21 493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E
// ----------------------------------------------------------------------------------------------------
// 01           -> Type of the TPDU
// 00           -> Message reference number
// 0B           -> Length of the Destination Phone Number
// 91           -> Type of the Destination Phone Number
// 5892214365F7 -> Destination Phone Number
// 00           -> Protocol Identifier
// 00           -> Data Coding Scheme
// 21           -> Length of the SMS Message Body
// 493A283D...  -> SMS Message Body


import Foundation

class TPDU {
  
  var textMessage = ""
  var phoneNumber = ""
  
  let tpduPartStartPhoneNumberIndex = 8
  let tpduStartIndex = 0

  // MARK: Default fields
  var tpduType = SMS_TPDU_TYPE.smsSubmit
  var mssgRefNumber = SMS_REF_NUMB.automatic
  let numberType = SMS_NUMB_TYPE.international
  var protocolIdent = SMS_PROTOCOL_IDENTIFIER.normal
  var dataCodingScheme = SMS_CODING_SCHEME.sevenBit
}