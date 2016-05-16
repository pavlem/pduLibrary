//
//  TPDU+Encoder.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/16/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//


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


import Foundation

extension TPDU {
  
  // MARK: - Public
  func encodeTPDUPart() -> (tpduString: String, tpduLenghtInOctets: String) {
    
    let numberLenght = String(removePlusCharacterAtFirstPosition(phoneNumber).characters.count).decimalToHexa2CharPadding
    let finalTPDUString = self.tpduType + self.mssgRefNumber + numberLenght + self.numberType + phoneNumberInPDU(phoneNumber) + self.protocolIdent + self.dataCodingScheme + smsBodyLengthInHex(textMessage) + encodeSMSMssgBodyFromtext(textMessage)
    let tpduLenght = tpduPartLenght(finalTPDUString)
    
    return (finalTPDUString, tpduLenght)
  }
  
  private func tpduPartLenght(tpduString: String) -> String {
    
    let charCount = tpduString.characters.count
    let octetLenght = charCount / 2
    
    return String(octetLenght)
  }
  
  private func smsBodyLengthInHex(text: String) -> String {
    let smsBodyArray = stringToBinaryArray(text, withPadSize: 7)
    let smsBodyString = smsBodyArray.joinWithSeparator("")
    let lenght = String(smsBodyString.characters.count/7)
    let hexlenght = lenght.decimalToHexa2CharPadding
    return hexlenght
  }
  
  // MARK: - Private
  //MARK: Encoding SMS body
  private func encodeSMSMssgBodyFromtext(text:String) -> String {
    
    var binArray = stringToBinaryArray(text, withPadSize: 7)
    binArray = sevenBitPDUEncoding(binArray)
    
    let hexArray = convertBinToHex(binArray)
    let hexString = hexArray.joinWithSeparator("")
    
    return hexString
  }
  
  private func sevenBitPDUEncoding(binArray: [String]) -> [String] {
    
    var revBinString = String()
    
    let reverseBinArray = binArray.reverse()
    revBinString = reverseBinArray.joinWithSeparator("")

    let mod = 8
    let res = revBinString.characters.count % mod
    
    var numberOfZeros = 0
    if res != 0 {
      numberOfZeros = mod - res
    }
    
    revBinString = padZerosToAString(numberOfZeros, stringS: revBinString)
    
    var binArrayGroupedIn8Bits = [String]()
    binArrayGroupedIn8Bits = revBinString.octets
    
    return binArrayGroupedIn8Bits.reverse()
  }
}