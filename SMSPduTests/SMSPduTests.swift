//
//  SMSPduTests.swift
//  SMSPduTests
//
//  Created by Pavle Mijatovic on 5/11/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import XCTest
@testable import SMSPdu

class SMSPduTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testNumberEncoder() {
    XCTAssert("94538791F2" == numberInPDUFromat("+493578192"), "🍊🍊, Number not converted for PDU format ready state")
    XCTAssert("836161663005" == numberInPDUFromat("+381616660350"), "🍊🍊, Number not converted for PDU format ready state")
    XCTAssert("5892214365F7" == numberInPDUFromat("+85291234567"), "🍊🍊, Number not converted for PDU format ready state")
    XCTAssert("886126090050" == numberInPDUFromat("+881662900005"), "🍊🍊, Number not converted for PDU format ready state")
    XCTAssert("6163532754F4" == numberInPDUFromat("+16363572454"), "🍊🍊, Number not converted for PDU format ready state")
    XCTAssert("8361427889F9" == numberInPDUFromat("+38162487989"), "🍊🍊, Number not converted for PDU format ready state")
    XCTAssert("8361427889F9" == numberInPDUFromat("38162487989"), "🍊🍊, Number not converted for PDU format ready state")
  }
  
  
  func testNumberDecoder() {
    
    XCTAssert(true)
  }
  
  
  func testData7BitEncoder() {
    XCTAssert(true)
    
  }
  
  func testData7BitDecoder() {
    XCTAssert(true)
    
  }
  
  
  
  func testPDUMessageEncoder() {
    XCTAssert(true)
    
  }
  
  
  func testPDUMessageDecoder() {
    XCTAssert(true)
    
  }
  
  func testSMSBodyDataLenght() {
    XCTAssert(true)
    
  }
  
  func testPDULenght() {
    XCTAssert(true)
    
  }
  
  func testNumberLenght() {
    XCTAssert(true)
    
  }
  
  
  // MARK: - Helper Functions
  func testStringToBinaryArray() {
    XCTAssert(["1001000", "1100101", "1101100", "1101100", "1101111"] == stringToBinaryArray("Hello"), "🍊🍊, String to Binary not correct")
    XCTAssert(["1010000", "1100001", "1101011"] == stringToBinaryArray("Pak"), "🍊🍊, String to Binary not correct")
    XCTAssert(["1001100", "1101111", "1110000", "1101111"] == stringToBinaryArray("Lopo"), "🍊🍊, String to Binary not correct")
  }
  
  func testPadToSize() {
    XCTAssert("0001001" == pad("1001", toSize: 7), "🍊🍊, Pad to size not correct")
    XCTAssert("0111001" == pad("111001", toSize: 7), "🍊🍊, Pad to size not correct")
    XCTAssert("000010" == pad("10", toSize: 6), "🍊🍊, Pad to size not correct")
    XCTAssert("0000111" == pad("111", toSize: 7), "🍊🍊, Pad to size not correct")
    XCTAssert("0010" == pad("10", toSize: 4), "🍊🍊, Pad to size not correct")
  }
  
  func testPadZerosToAString() {
    XCTAssert("0001111" == padZerosToAString(3, string: "1111"))
    XCTAssert("0000100111" == padZerosToAString(4, string: "100111"))
    XCTAssert("0011" == padZerosToAString(2, string: "11"))
  }
  
  func testnumbArrayPadLastElementForPDU() {
    XCTAssert(["85", "29", "34"] == numbArrayPadLastElementForPDU(["85", "29", "34"]), "🍊🍊, Last element not padded")
    XCTAssert(["85", "3F"] == numbArrayPadLastElementForPDU(["85", "3"]), "🍊🍊, Last element not padded")
    XCTAssert(["21", "22", "34", "5F"] == numbArrayPadLastElementForPDU(["21", "22", "34", "5"]), "🍊🍊, Last element not padded")
  }
  
  func testSwitchCharPairsForEachElement() {
    XCTAssert(["85", "29", "00", "0F"] == switchCharPairsForEachElement(["58", "92", "00", "F0"]), "🍊🍊, Char pairs not switched")
    XCTAssert(["15", "Az", "CC", "5t"] == switchCharPairsForEachElement(["51", "zA", "CC", "t5"]), "🍊🍊, Char pairs not switched")
    XCTAssert(["fq", "25", "sq"] == switchCharPairsForEachElement(["qf", "52", "qs"]), "🍊🍊, Char pairs not switched")
  }
  
  func testRemoveCharInStringAtFirstPosition() {
    XCTAssert("1234567" == removeCharInStringAtFirstPosition("+", inString: "+1234567"), "🍊🍊, Desired char not removed" )
    XCTAssert("erert42" == removeCharInStringAtFirstPosition("W", inString: "Werert42"), "🍊🍊, Desired char not removed" )
    XCTAssert("fofoofo" == removeCharInStringAtFirstPosition("!", inString: "!fofoofo"), "🍊🍊, Desired char not removed" )
    XCTAssert("213fff" == removeCharInStringAtFirstPosition("@", inString: "@213fff"), "🍊🍊, Desired char not removed" )
  }
  
  func testTextLenghtInOctetsInHex() {
    XCTAssert("07" == textLenghtInOctetsInHex("5892000000F091"), "🍊🍊, Hex Lenght not correct" )
    XCTAssert("06" == textLenghtInOctetsInHex("5892000000F0"), "🍊🍊, Hex Lenght not correct" )
    XCTAssert("05" == textLenghtInOctetsInHex("5892000000"), "🍊🍊, Hex Lenght not correct" )
    XCTAssert("0A" == textLenghtInOctetsInHex("5892000000F091334321"), "🍊🍊, Hex Lenght not correct" )
    XCTAssert("0F" == textLenghtInOctetsInHex("5892000000F0913343216622839199"), "🍊🍊, Hex Lenght not correct" )
    XCTAssert("11" == textLenghtInOctetsInHex("5892000000F091334321662283919912wq"), "🍊🍊, Hex Lenght not correct" )
  }
  
  func testConvertBinToHex() {
    XCTAssert(["c8", "32", "9b", "fd", "0e", "01"] == convertBinToHex(["11001000", "00110010", "10011011", "11111101", "00001110", "00000001"]), "🍊🍊, Hex arrays are not equal" )
    XCTAssert(["c8", "36", "1b"] == convertBinToHex(["11001000", "00110110", "00011011"]), "🍊🍊, Hex arrays are not equal" )
    XCTAssert(["d0", "b0", "3a", "1c", "02"] == convertBinToHex(["11010000", "10110000", "00111010", "00011100", "00000010"]), "🍊🍊, Hex arrays are not equal" )
  }
}
