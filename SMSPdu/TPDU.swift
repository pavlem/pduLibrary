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
  
  // MARK: Default fields
  var tpduType = SMS_TPDU_TYPE.smsSubmit
  var mssgRefNumber = SMS_REF_NUMB.automatic
  let numberType = SMS_NUMB_TYPE.international
  var protocolIdent = SMS_PROTOCOL_IDENTIFIER.normal
  var dataCodingScheme = SMS_CODING_SCHEME.sevenBit
  
  

  //MARK: - Decoding -

  func decodeTPDUPart(pduText: String) -> String {
    let decodedMssgString = decodeSMSMssgBodyFromtext(pduText)
    print(decodedMssgString)
    return decodedMssgString
  }
  
  


  func decodeSMSMssgBodyFromtext(text:String) -> String {
    var arrayOfBin = [String]()
    let arrayOfHex = text.pairs
    
    
    print(arrayOfHex)
    
    for hex in arrayOfHex {
      
      var bin = hex.hexaToBinary
      
      while bin.characters.count < 8 {
        bin = "0" + bin
      }
      
      
      arrayOfBin.append(bin)
      
    }
    
    
    print(arrayOfBin)
    
    arrayOfBin = arrayOfBin.reverse()
    
    var string = arrayOfBin.joinWithSeparator("")
    
    print(string)
    

    let zeroesToRemove = string.characters.count % 7

    string = (string as NSString).substringFromIndex(zeroesToRemove) // "

    var septets = string.septets
    
    septets = septets.reverse()
    print(septets)
    
    
    var finalString = ""
    
    for septet in septets {
      
      
      let binary = septet
      let number = strtoul(binary, nil, 2)
      
      let x = UInt32(number)
      
      finalString.append(UnicodeScalar(x))
    }

    return finalString
  }
}