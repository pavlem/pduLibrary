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
  let smscNumber = "+85290000000"
  let phoneNumber = "+85291234567"
  let smsMessage = "It is easy to send text messages."
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    oPrint("smscNumber: \(smscNumber)")
    oPrint("phoneNumber: \(phoneNumber)")
    oPrint("smsMessage: \(smsMessage)")

    print("---------------------------------------------------------------------------------------------")
    // MARK: Encode
    let encoder = EncoderPDU(phoneNumber: phoneNumber, smscNumber: smscNumber, smsMessage: smsMessage)
    let smsMessageReceived = encoder.encode()
    oPrint(smsMessageReceived)
    print("---------------------------------------------------------------------------------------------")

    // MARK: Decode
    let decoder = DecoderPDU(smsMssg: smsMessageReceived)
    let mssgTuple = decoder.decode()
    aPrint(mssgTuple)
  }
}