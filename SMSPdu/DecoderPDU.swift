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
  var smsMssg = ""
  var pduMssg = ""
  var smsMssgBody = ""
  
  // MARK: - Inits -
  init () {
    
  }
  
  init(smsMssg: String) {
    self.smsMssg = smsMssg
  }
  
  // MARK: - Public -
  func decode() -> (senderSMSCNumber: String, phoneNum: String, senderMssg: String) {
    
    let tpduLenghtAndPDU = extractPDUPartsFromSMS(self.smsMssg)
    let pduMssg = tpduLenghtAndPDU.pduMssg
    let tpduLenght = tpduLenghtAndPDU.lenghtOfTPDU
    
    let decodedElements = decodePDU(pduMssg, tpduLenght: Int(tpduLenght)!)
    return decodedElements
  }
  
  func extractPDUPartsFromSMS(smsReceived: String) -> (pduMssg: String, lenghtOfTPDU: String) {
    let crIndex = indexOfFirstCRCharacter(smsReceived)
    let pduMssg = smsReceived.substringFromIndex(smsReceived.startIndex.advancedBy(crIndex + 1))
    let tpduLenght = tpduLenghtInOctets(smsReceived, crIndex: crIndex)
    
    return (pduMssg, tpduLenght)
  }
  
  func tpduLenghtInOctets(smsReceived: String, crIndex: Int) -> String {
   return smsReceived.substringWithRange(smsReceived.startIndex.advancedBy(crIndex - 2)..<smsReceived.startIndex.advancedBy(crIndex))
  }
  
  func decodePDU(pduMssg: String, tpduLenght: Int) -> (senderSMSCNumber: String, phoneNum: String, senderMssg: String) {
    
    let smscPart = smsc(pduMssg, tpduLengthInt: tpduLenght)
    let tpduPart = tpdu(pduMssg, smscPart: smscPart)
    
    let scmscElements = decomposeSMSC(smscPart)
    let tpduElements = decomposeTPDU(tpduPart)
    
    let senderSMSCNumb = SMSC().senderSMSCNumber(scmscElements.senderSMSCNumber, numberType: scmscElements.senderSMSCNumberType)
    let destinationPhoneNum = TPDU().destinationPhoneNumber(tpduPart, lenghtStringHex: tpduElements.lenghtOfDestPhoneNum, typeOfPhoneNumber: tpduElements.typeOfPhoneNum)
    let senderMssg = TPDU().decodeSMSMssgBodyFromtext(tpduElements.smsBody)
    
    return (senderSMSCNumb, destinationPhoneNum, senderMssg)
  }
  
  // MARK: - Private -
  func smsc(pduMssg: String, tpduLengthInt: Int) -> String {
    let smscPart = pduMssg[0...pduMssg.characters.count-1 - tpduLengthInt*2]
    return smscPart
  }
  
  func tpdu(pduMssg: String, smscPart: String) -> String {
    let tpduPart = pduMssg[smscPart.characters.count...pduMssg.characters.count-1]
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
}