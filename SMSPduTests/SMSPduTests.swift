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
  
  
  // MARK: - Encoder
  func testEncoderToPDU() {
    XCTAssert("2407915892000000F001000B915892214365F700000CC8329BFD06DDDF72363904" == EncoderPDU(phoneNumber: "+85291234567", smscNumber: "+85290000000", smsMessage: "Hello world!").encodeToPDU(), "🍊🍊, PDU format not correct")
    XCTAssert("230691519200000001000A91519221436500000CC8329BFD0699E5E9B29B0C" == EncoderPDU(phoneNumber: "+1529123456", smscNumber: "+1529000000", smsMessage: "Hello friend").encodeToPDU(), "🍊🍊, PDU format not correct")
    XCTAssert("220591113244F501000A91601132547600000BCCB7BCDC06A5E1F37A1B" == EncoderPDU(phoneNumber: "0611234567", smscNumber: "+1123445", smsMessage: "Lorem ipsum").encodeToPDU(), "🍊🍊, PDU format not correct")
  }
  
  func testSMSCPartEncoder() {
    
    let smsc1 = SMSC()
    smsc1.smscNumber = "+85290000000"
    let smscString1 = smsc1.encodeSMSCPart()
    
    let smsc2 = SMSC()
    smsc2.smscNumber = "+38111717171"
    let smscString2 = smsc2.encodeSMSCPart()
    
    let smsc3 = SMSC()
    smsc3.smscNumber = "+2223332"
    let smscString3 = smsc3.encodeSMSCPart()
    
    let smsc4 = SMSC()
    smsc4.smscNumber = "+22233321"
    let smscString4 = smsc4.encodeSMSCPart()
    
    XCTAssert("07915892000000F0" == smscString1, "🍊🍊, SMSC format not correct")
    XCTAssert("07918311717171F1" == smscString2, "🍊🍊, SMSC format not correct")
    XCTAssert("0591223233F2" == smscString3, "🍊🍊, SMSC format not correct")
    XCTAssert("059122323312" == smscString4, "🍊🍊, SMSC format not correct")
  }
  
  func testTPDUPartEncoder() {
    let tpdu1 = TPDU()
    tpdu1.textMessage = "Dear friend I must say..."
    tpdu1.phoneNumber = "+85291234567"
    let tpduStringTuple1 = tpdu1.encodeTPDUPart()
    XCTAssert(("01000B915892214365F7000019c472580e32cbd36537199404b5eb733a681ecebb5c2e", "35") == tpduStringTuple1)
    
    let tpdu2 = TPDU()
    tpdu2.textMessage = "Hello world"
    tpdu2.phoneNumber = "+38116167777"
    let tpduStringTuple2 = tpdu2.encodeTPDUPart()
    XCTAssert(("01000B918311167677F700000Bc8329bfd06dddf723619", "23") == tpduStringTuple2)
    
    let tpdu3 = TPDU()
    tpdu3.textMessage = "It is easy to send text messages."
    tpdu3.phoneNumber = "+85291234567"
    let tpduStringTuple3 = tpdu3.encodeTPDUPart()
    XCTAssert(("01000B915892214365F7000021493a283d0795c3f33c88fe06cdcb6e32885ec6d341edf27c1e3e97e72e", "42") == tpduStringTuple3)
  }
  
  func testTPDUPartLenght() {
    XCTAssert("24" == TPDU().tpduPartLenght("01000B915892214365F700000Cc8329bfd06dddf72363904"), "🍊🍊, TPDU lenght not correct")
    XCTAssert("39" == TPDU().tpduPartLenght("01000B915892214365F700001Dc8329bfd06dddf723619c47ccbcb6d50123eafb741f972181d02"), "🍊🍊, TPDU lenght not correct")
    XCTAssert("52" == TPDU().tpduPartLenght("01000B915892214365F700002C493a283d07d9cbf23cc85e96e741e5f03c0fa2bf41ec7258ee06ddd16537a8fda6a7ed617a990c"), "🍊🍊, TPDU lenght not correct")
  }
  
  func testSMSBodyLengthInHex() {
    XCTAssert("2C" == TPDU().smsBodyLengthInHex("It is very very easy to learn when motivated"), "🍊🍊, SMS body lenght not correct")
    XCTAssert("0C" == TPDU().smsBodyLengthInHex("Hello world!"), "🍊🍊, SMS body lenght not correct")
    XCTAssert("05" == TPDU().smsBodyLengthInHex("Lorem"), "🍊🍊, SMS body lenght not correct")
  }
  
  func test7BitEncoding() {
    XCTAssert("c8329bfd06dddf72363904" == TPDU().encode7BitSMSMssgBodyFromtext("Hello world!"), "🍊🍊, 7 bit Encoding not correct")
    XCTAssert("c472580e32cbd36537199404b5eb733a681ecebb5c2e" == TPDU().encode7BitSMSMssgBodyFromtext("Dear friend I must say..."), "🍊🍊, 7 bit Encoding not correct")
    XCTAssert("ccb7bcdc06a5e1f37a1b" == TPDU().encode7BitSMSMssgBodyFromtext("Lorem ipsum"), "🍊🍊, 7 bit Encoding not correct")
  }
  
  
  func testNumberInPDUFormatEncoder() {
    XCTAssert("94538791F2" == numberInPDUFormat("+493578192"), "🍊🍊, Number not converted for PDU format ready state")
    XCTAssert("836161663005" == numberInPDUFormat("+381616660350"), "🍊🍊, Number not converted for PDU format ready state")
    XCTAssert("5892214365F7" == numberInPDUFormat("+85291234567"), "🍊🍊, Number not converted for PDU format ready state")
    XCTAssert("886126090050" == numberInPDUFormat("+881662900005"), "🍊🍊, Number not converted for PDU format ready state")
    XCTAssert("6163532754F4" == numberInPDUFormat("+16363572454"), "🍊🍊, Number not converted for PDU format ready state")
    XCTAssert("8361427889F9" == numberInPDUFormat("+38162487989"), "🍊🍊, Number not converted for PDU format ready state")
    XCTAssert("8361427889F9" == numberInPDUFormat("38162487989"), "🍊🍊, Number not converted for PDU format ready state")
  }
  
  //TODO: Implement 16 bit test when encoder is functioning
  //  func test16BitEncodingOfSMSMssgBody() {
  //    XCTAssert("c8329bfd06dddf72363904" == TPDU().encode7BitSMSMssgBodyFromtext("Hello world!"))
  //    XCTAssert("c472580e32cbd36537199404b5eb733a681ecebb5c2e" == TPDU().encode7BitSMSMssgBodyFromtext("Dear friend I must say..."))
  //    XCTAssert("ccb7bcdc06a5e1f37a1b" == TPDU().encode7BitSMSMssgBodyFromtext("Lorem ipsum"))
  //  }
  
  // MARK: - Decoder
  func testDecoderFromPDU() {
    
    let decoder = DecoderPDU()
    
    decoder.smsMssg = "25069155653422F10100099183718254F600000EC8329BFD0699E5E9B29B1C0A01"
    XCTAssert(("+555643221", "+381728456", "Hello friend!!") == decoder.decodePDU())

    decoder.smsMssg = "23069157223233F401000B918361717171F100000BCCB7BCDC0625E1F37A1B"
    XCTAssert(("+752223334", "+38161717171", "Lorem Ipsum") == decoder.decodePDU())
    
    decoder.smsMssg = "4207915892000000F001000B915892214365F7000021493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E"
    XCTAssert(("+85290000000", "+85291234567", "It is easy to send text messages.") == decoder.decodePDU())
  }
  
  
  
  func testNumberDecoder() {
    
    XCTAssert(true)
  }
  
  func testData7BitDecoder() {
    XCTAssert(true)
    
  }
  
  
  func testPDUMessageDecoder() {
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
