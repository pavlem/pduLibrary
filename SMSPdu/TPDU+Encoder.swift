//
//  TPDU+Encoder.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/16/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation

extension TPDU {
  
  // MARK: - Public
  func encodeTPDUPart() -> String {
    
    let numberlength = String(removePlusCharacterAtFirstPosition(phoneNumber).characters.count).decimalToHexa2CharPadding
    let finalTPDUString = self.tpduType + self.mssgRefNumber + numberlength + self.numberType + numberInPDUFormat(phoneNumber) + self.protocolIdent + self.dataCodingScheme + smsBodyLengthInHex(textMessage) + encode7BitSMSMssgBodyFromtext(textMessage)
    
    return finalTPDUString
  }
    
  func smsBodyLengthInHex(text: String) -> String {
    let smsBodyArray = stringToBinaryArray(text, withPadSize: 7)
    let smsBodyString = smsBodyArray.joinWithSeparator("")
    let length = String(smsBodyString.characters.count/7)
    let hexlength = length.decimalToHexa2CharPadding
    return hexlength
  }
  
  // MARK: - Private
  //MARK: Encoding SMS body
  func encode7BitSMSMssgBodyFromtext(text:String) -> String {
    
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
    
    revBinString = padZerosToAString(numberOfZeros, string: revBinString)
    
    var binArrayGroupedIn8Bits = [String]()
    binArrayGroupedIn8Bits = revBinString.octets
    
    return binArrayGroupedIn8Bits.reverse()
  }
}