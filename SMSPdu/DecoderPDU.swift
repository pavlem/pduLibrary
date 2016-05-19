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
  init(smsMssg: String) {
    self.smsMssg = smsMssg
  }
  
  // MARK: - Public -
  func decode() -> (senderSMSCNumber: String, senderPhoneNum: String, senderMssg: String) {
    
    let tpduLenghtAndPDUMssgTuple = extractPDUPartsFromSMS(self.smsMssg)
    let pduMssg = tpduLenghtAndPDUMssgTuple.pduMssg
    let tpduLenght = tpduLenghtAndPDUMssgTuple.lenghtOfTPDU
    
    let pduTuple = decodePDU(pduMssg, tpduLenght: Int(tpduLenght)!)
    return pduTuple
  }
  
  func extractPDUPartsFromSMS(smsReceived: String) -> (pduMssg: String, lenghtOfTPDU: String) {
    let indexOfCR = indexOfFirstCRCharacter(smsReceived)
    let pduMssg = smsReceived.substringFromIndex(smsReceived.startIndex.advancedBy(indexOfCR + 1))
    let lenghtOfTPDU = lenghtOfPDUInHex(smsReceived, indexOfCR: indexOfCR)
    
    return (pduMssg, lenghtOfTPDU)
  }
  
  func lenghtOfPDUInHex(smsReceived: String, indexOfCR: Int) -> String {
   return smsReceived.substringWithRange(smsReceived.startIndex.advancedBy(indexOfCR - 2)..<smsReceived.startIndex.advancedBy(indexOfCR))
  }
  
  func decodePDU(pduMssg: String, tpduLenght: Int) -> (senderSMSCNumber: String, senderPhoneNum: String, senderMssg: String) {
    
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