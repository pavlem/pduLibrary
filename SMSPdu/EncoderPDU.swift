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
  func encode() -> String {
    let pduMssg = encodeToPDU()
    let finalString = pduMssg

    return finalString
  }
  
  func encodeToPDU() -> String {
    let smscString = smscPartEncoded()
    let tpduString = tpduPartEncoded()
    

    //TODO: Implement 
    // ANDROID
    //    "+CMT:," + "tpdu lenght" + "\r" + "PDU......"
    
    // SB
    //    "AT+CMGS:" + "tpdu lenght" + "\r" + "PDU......" + "\u001A"
    
//    let finalString = "+CMT:," + tpduPartLenght(tpduString) + "\n" + smscString + tpduString
//    aPrint(finalString)
    let encodedMssg = (tpduPartLenght(tpduString) + smscString + tpduString).uppercaseString
    
    return encodedMssg
  }
  
  private func smscPartEncoded() -> String {
    let smsc = SMSC()
    smsc.smscNumber = smscNumber
    let smscString = smsc.encodeSMSCPart()
    return smscString
  }
  
  private func tpduPartEncoded() -> String {
    let tpdu = TPDU()
    tpdu.textMessage = smsMessage
    tpdu.phoneNumber = phoneNumber
    let tpduStringTuple = tpdu.encodeTPDUPart()

    return tpduStringTuple
  }
  
  func tpduPartLenght(tpduString: String) -> String {
    
    let charCount = tpduString.characters.count
    let octetLenght = charCount / 2
    
    return String(octetLenght)
  }
}