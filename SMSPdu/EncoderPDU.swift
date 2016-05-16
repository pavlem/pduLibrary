//
//  EncoderPDU.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/12/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation

class EncoderPDU {
  
  // MARK: - Properties and Constants -
  // MARK: Defaults
  let phoneNumberDefault = "+85291234567"
  let smscNumberDefault = "+85290000000"
  let smsMessageDefault = "Hello World!!!"

  // MARK: Vars
  var phoneNumber = ""
  var smscNumber = ""
  var smsMessage = ""
  
  
  // MARK: - Inits -
  init() {
    phoneNumber = phoneNumberDefault
    smscNumber = smscNumberDefault
    smsMessage = smsMessageDefault
  }
  
  init (phoneNumber: String, smscNumber: String, smsMessage: String) {
    self.phoneNumber = phoneNumber
    self.smscNumber = smscNumber
    self.smsMessage = smsMessage
  }
  
  
  // MARK: - Public 
  func encodeToPDU() -> String {
    let smscString = smscPart()
    let tpduStringTuple = tpduPart()
    let encodedMssg = (tpduStringTuple.tpduLenghtInOctets + smscString + tpduStringTuple.tpduString).uppercaseString
    
    return encodedMssg
  }
  
  func smscPart() -> String {
    let smsc = SMSC()
    smsc.smscNumber = smscNumber
    let smscString = smsc.encodeSMSCPart()
    return smscString
  }
  
  func tpduPart() -> (tpduString: String, tpduLenghtInOctets: String) {
    let tpdu = TPDU()
    tpdu.textMessage = smsMessage
    tpdu.phoneNumber = phoneNumber
    let tpduStringTuple = tpdu.encodeTPDUPart()

    return tpduStringTuple
  }
}