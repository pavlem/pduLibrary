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
    
    let tpdulengthAndPDU = extractPDUPartsFromSMS(self.smsMssg)
    let pduMssg = tpdulengthAndPDU.pduMssg
    let tpdulength = tpdulengthAndPDU.lengthOfTPDU
    
    let decodedElements = decodePDU(pduMssg, tpdulength: Int(tpdulength)!)
    return decodedElements
  }
  
  func extractPDUPartsFromSMS(smsReceived: String) -> (pduMssg: String, lengthOfTPDU: String) {
    let crIndex = indexOfFirstEscapedSpecialCharacter("\r", string: smsReceived)
    let pduMssg = smsReceived.substringFromIndex(smsReceived.startIndex.advancedBy(crIndex + 1))
    let tpdulength = tpdulengthInOctets(smsReceived, crIndex: crIndex)
    
    return (pduMssg, tpdulength)
  }
  
  func tpdulengthInOctets(smsReceived: String, crIndex: Int) -> String {
   return smsReceived.substringWithRange(smsReceived.startIndex.advancedBy(crIndex - 2)..<smsReceived.startIndex.advancedBy(crIndex))
  }
  
  func decodePDU(pduMssg: String, tpdulength: Int) -> (senderSMSCNumber: String, phoneNum: String, senderMssg: String) {
    
    let smscPart = smsc(pduMssg, tpduLengthInt: tpdulength)
    let tpduPart = tpdu(pduMssg, smscPart: smscPart)
    
    let scmscElements = decomposeSMSC(smscPart)
    let tpduElements = decomposeTPDU(tpduPart)
    
    let senderSMSCNumb = SMSC().senderSMSCNumber(scmscElements.senderSMSCNumber, numberType: scmscElements.senderSMSCNumberType)
    let destinationPhoneNum = TPDU().destinationPhoneNumber(tpduPart, lengthStringHex: tpduElements.lengthOfDestPhoneNum, typeOfPhoneNumber: tpduElements.typeOfPhoneNum)
    let senderMssg = TPDU().decodeSMSMssgBodyFromtext(tpduElements.smsBody)
    
    return (senderSMSCNumb, destinationPhoneNum, senderMssg)
  }
  
  // MARK: - Private -
  func smsc(pduMssg: String, tpduLengthInt: Int) -> String {
    let smscPart = pduMssg[0..<pduMssg.characters.count - tpduLengthInt*2]
    return smscPart
  }
  
  func tpdu(pduMssg: String, smscPart: String) -> String {
    let tpduPart = pduMssg[smscPart.characters.count..<pduMssg.characters.count]
    return tpduPart
  }
  
  func decomposeSMSC(smscString: String) -> (senderSMSlength: String, senderSMSCNumberType: String, senderSMSCNumber: String) {
    let smscTuple = SMSC().decomposeSMSCPart(smscString)
    return smscTuple
  }
  
  func decomposeTPDU(tpduString: String) -> (tpduType: String, mssgRefNumber: String, lengthOfDestPhoneNum: String, typeOfPhoneNum: String, destPhoneNumber: String, protocolIdentifier: String, dataCodeScheme: String, lengthSMSBodyInSeptets: String, smsBody: String) {
    let tpduTuple = TPDU().decomposeTPDUPart(tpduString)
    return tpduTuple
  }
}