//
//  Int+Extension.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/11/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import Foundation


extension Int {
  var binaryString: String { return String(self, radix: 2)  }
  var hexaString  : String { return String(self, radix: 16) }
  var doubleValue : Double { return Double(self) }
}