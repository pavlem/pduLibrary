//
//  String+Extension.swift
//  SMSPdu
//
//  Created by Pavle Mijatovic on 5/11/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

//Literals
//Decimal number -> no prefix
//Binary number -> 0b prefix
//Octal number -> 0o prefix
//Hexadecimal number -> 0x prefix

import Foundation

extension String {
  func replace(string:String, replacement:String) -> String {
    return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
  }
  
  func removeWhitespace() -> String {
    return self.replace(" ", replacement: "")
  }
}

extension String {
  
  var pairs: [String] {
    var result: [String] = []
    let chars = Array(characters)
    for index in 0.stride(to: chars.count, by: 2) {
      result.append(String(chars[index..<min(index+2, chars.count)]))
    }
    return result
  }
  
  var octets: [String] {
    var result: [String] = []
    let chars = Array(characters)
    for index in 0.stride(to: chars.count, by: 8) {
      result.append(String(chars[index..<min(index+8, chars.count)]))
    }
    return result
  }
  
  var septets: [String] {
    var result: [String] = []
    let chars = Array(characters)
    for index in 0.stride(to: chars.count, by: 7) {
      result.append(String(chars[index..<min(index+7, chars.count)]))
    }
    return result
  }
}

extension String {
  subscript (i: Int) -> Character {
    return self[self.startIndex.advancedBy(i)]
  }
  
  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }
  
  subscript (r: Range<Int>) -> String {
    let start = startIndex.advancedBy(r.startIndex)
    let end = start.advancedBy(r.endIndex - r.startIndex)
    return self[Range(start ..< end)]
  }
}

extension String {
  var decimalToHexa2CharPadding : String { return String(format:"%02X", Int(self)!) }
}

extension String {
  var hexaToInt      : Int    { return Int(strtoul(self, nil, 16))      }
  var hexaToDouble   : Double { return Double(strtoul(self, nil, 16))   }
  var hexaToBinary   : String { return String(hexaToInt, radix: 2)      }
  var decimalToHexa  : String { return String(Int(self) ?? 0, radix: 16)}
  var decimalToBinary: String { return String(Int(self) ?? 0, radix: 2) }
  var binaryToInt    : Int    { return Int(strtoul(self, nil, 2))       }
  var binaryToDouble : Double { return Double(strtoul(self, nil, 2))   }
  var binaryToHexa   : String { return String(binaryToInt, radix: 16)  }
}
