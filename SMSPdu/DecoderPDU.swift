//
//  DecoderPDU.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/12/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation

class DecoderPDU {
  
  // MARK: - Properties -
  let tpduLenghtIndexStart = 0
  let tpduLenghtIndexEnd = 1
  let pduMssgIndexStart = 2
  
  var smsMssg = "4207915892000000F001000B915892214365F7000021493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E"
  var smsMssgBody = ""
  
  // MARK: - Inits -
  init() {
    
  }
  
  init(smsMssg: String) {
    self.smsMssg = smsMssg
  }
  
  // MARK: - Public -
  func decode() -> (senderSMSCNumber: String, senderPhoneNum: String, senderMssg: String) {
    
    extractPDUPart(smsMssg)
    
    let pduTuple = decodePDU()
    return pduTuple
  }
  
  func extractPDUPart(smsReceived: String) {
//    aPrint(smsReceived)
  }
  
  
  func decodePDU() -> (senderSMSCNumber: String, senderPhoneNum: String, senderMssg: String) {
    
    let smscPart = smsc(smsMssg)
    let tpduPart = tpdu(smsMssg)
    
    let scmscElements = decomposeSMSC(smscPart)
    let tpduElements = decomposeTPDU(tpduPart)
    
    let senderSMSCNumb = SMSC().senderSMSCNumber(scmscElements.senderSMSCNumber, numberType: scmscElements.senderSMSCNumberType)
    let destinationPhoneNum = TPDU().destinationPhoneNumber(tpduPart, lenghtStringHex: tpduElements.lenghtOfDestPhoneNum, typeOfPhoneNumber: tpduElements.typeOfPhoneNum)
    let senderMssg = TPDU().decodeSMSMssgBodyFromtext(tpduElements.smsBody)
    
    return (senderSMSCNumb, destinationPhoneNum, senderMssg)
  }
  
  // MARK: - Private -
  func smsc(smsMssg: String) -> String {
    let tpduLengthInt = tpduLenght(smsMssg)
    let pduMssg = smsMssg[2...smsMssg.characters.count-1]
    let smscPart = pduMssg[0...pduMssg.characters.count-1 - tpduLengthInt*2]
    
    return smscPart
  }
  
  func tpdu(smsMssg: String) -> String {
    let pduMssg = pduMessage(smsMssg)
    let tpduPart = pduMssg[smsc(smsMssg).characters.count...pduMssg.characters.count-1]
    
    return tpduPart
  }
  
  func decomposeSMSC(smscString: String) -> (senderSMSLenght: String, senderSMSCNumberType: String, senderSMSCNumber: String) {
    let smscTuple = SMSC().decomposeSMSCPart(smscString)
    return smscTuple
  }
  
  func decomposeTPDU(tpduString: String) -> (tpduType: String, mssgRefNumber: String, lenghtOfDestPhoneNum: String, typeOfPhoneNum: String, destPhoneNumber: String, protocolIdentifier: String, dataCodeScheme: String, lenghtSMSBodyInSeptets: String, smsBody: String) {
    let tpduTuple = TPDU().decomposeTPDUPart(tpduString)
    return tpduTuple
  }

  func tpduLenght(smsMssg: String) -> Int {
    return Int(smsMssg[tpduLenghtIndexStart...tpduLenghtIndexEnd])!
  }
  
  func pduMessage(smsMssg: String) -> String {
    return smsMssg[pduMssgIndexStart...smsMssg.characters.count-1]
  }
}