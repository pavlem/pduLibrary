//
//  ViewController.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/11/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  
  // MARK: Test Data
  let phoneNumber = "+85291234567"
  let smscNumber = "+85290000000"
  let smsMessage = "It is easy to send text messages."
//  let smsMssg = "4207915892000000F001000B915892214365F7000021493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E"
//  var smsMssgReceived = "3507915892000000F001000B915892214365F7000019417618D44E83D46590BA2C2EBBDFA0301A8D0EA3C368"

  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    // MARK: Encode
    let encoder = EncoderPDU(phoneNumber: phoneNumber, smscNumber: smscNumber, smsMessage: smsMessage)
    let pduMessage = encoder.encodeToPDU()
    oPrint(pduMessage)
    
    // MARK: Decode
    let decoder = DecoderPDU()
    decoder.smsMssg = pduMessage
    let mssgTuple = decoder.decodePDU()
    aPrint(mssgTuple)
  }
}