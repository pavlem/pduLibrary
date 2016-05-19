//
//  SMSConstants.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/11/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation

// Syntax of the +CMGS AT command is:
// +CMGS=TPDU_length<CR>SMSC_number_and_TPDU<Ctrl+z>
// Example: AT+CMGS=42<CR>07915892000000F001000B915892214365F7000021493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E<Ctrl+z>
// ----------------------------------------------------------------------------------------------------
// 42       -> Length (in octets. 1 octet = 8 bits) of the TPDU (Transfer Protocol Data Unit) assigned to the SMSC_number_and_TPDU parameter.
// <CR>     -> Carriage return character -> /r
// <Ctrl+z> -> End of the value. -> u001A

// MARK: - SMSC PART -
// Example - 07 91 5892000000F0
// ----------------------------------------------------------------------------------------------------
// 07           -> length in octets of the following two sub-fields
// 91           -> type of the SMSC number assigned to the third sub-field.
// 5892000000F0 -> SMSC number for sending the SMS message

// MARK: - TPDU PART -
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



struct SMS_TPDU_TYPE {
  static let smsSubmit = "01"
}

struct SMS_REF_NUMB {
  static let automatic = "00"
}

struct SMS_PROTOCOL_IDENTIFIER {
  static let normal = "00"
}

struct SMS_CODING_SCHEME {
  static let sevenBit = "00"
  static let sixteenBit = "01"
}

// MARK: - COMMON PART -
struct SMS_NUMB_TYPE {
  static let undefined = "81"
  static let international = "91"
}