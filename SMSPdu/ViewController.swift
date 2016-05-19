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
  let smscNumber = "+855544333"
  let phoneNumber = "+869822255"
  let smsMessage = "Cao Pavle, sta ima bolan, kako si jebote ja!!!"
  
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
//    decoder.smsMssg = pduMessage
    let mssgTuple = decoder.decode()
    aPrint(mssgTuple)
  }
}