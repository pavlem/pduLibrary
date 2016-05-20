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
  func testPDUEncoder() {
    XCTAssert("07915892000000F001000B915892214365F700000CC8329BFD06DDDF72363904" == EncoderPDU(phoneNumber: "+85291234567", smscNumber: "+85290000000", smsMessage: "Hello world!").encodeToPDU(), "🍊🍊, PDU format not correct")
    XCTAssert("0691519200000001000A91519221436500000CC8329BFD0699E5E9B29B0C" == EncoderPDU(phoneNumber: "+1529123456", smscNumber: "+1529000000", smsMessage: "Hello friend").encodeToPDU(), "🍊🍊, PDU format not correct")
    XCTAssert("0591113244F501000A91601132547600000BCCB7BCDC06A5E1F37A1B" == EncoderPDU(phoneNumber: "0611234567", smscNumber: "+1123445", smsMessage: "Lorem ipsum").encodeToPDU(), "🍊🍊, PDU format not correct")
    XCTAssert("07915892000000F001000B915892214365F7000021493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E" == EncoderPDU(phoneNumber: "+85291234567", smscNumber: "+85290000000", smsMessage: "It is easy to send text messages.").encodeToPDU(), "🍊🍊, PDU format not correct")
  }
  
  func testSMSCPartEncoder() {
    let smsc = SMSC()
    
    smsc.smscNumber = "+85290000000"
    let smscString1 = smsc.encodeSMSCPart()
    
    smsc.smscNumber = "+38111717171"
    let smscString2 = smsc.encodeSMSCPart()
    
    smsc.smscNumber = "+2223332"
    let smscString3 = smsc.encodeSMSCPart()
    
    smsc.smscNumber = "+22233321"
    let smscString4 = smsc.encodeSMSCPart()
    
    XCTAssert("07915892000000F0" == smscString1, "🍊🍊, SMSC format not correct")
    XCTAssert("07918311717171F1" == smscString2, "🍊🍊, SMSC format not correct")
    XCTAssert("0591223233F2" == smscString3, "🍊🍊, SMSC format not correct")
    XCTAssert("059122323312" == smscString4, "🍊🍊, SMSC format not correct")
  }
  
  func testTPDUPartEncoder() {
    let tpdu = TPDU()
    
    tpdu.textMessage = "Dear friend I must say..."
    tpdu.phoneNumber = "+85291234567"
    let tpduString1 = tpdu.encodeTPDUPart()
    XCTAssert("01000B915892214365F7000019c472580e32cbd36537199404b5eb733a681ecebb5c2e" == tpduString1)
    
    tpdu.textMessage = "Hello world"
    tpdu.phoneNumber = "+38116167777"
    let tpduString2 = tpdu.encodeTPDUPart()
    XCTAssert("01000B918311167677F700000Bc8329bfd06dddf723619" == tpduString2)
    
    tpdu.textMessage = "It is easy to send text messages."
    tpdu.phoneNumber = "+85291234567"
    let tpduString3 = tpdu.encodeTPDUPart()
    XCTAssert("01000B915892214365F7000021493a283d0795c3f33c88fe06cdcb6e32885ec6d341edf27c1e3e97e72e" == tpduString3)
  }
  
  func testTPDUPartLenght() {
    XCTAssert("24" == stringLenghtInOctets("01000B915892214365F700000Cc8329bfd06dddf72363904"), "🍊🍊, TPDU lenght not correct")
    XCTAssert("39" == stringLenghtInOctets("01000B915892214365F700001Dc8329bfd06dddf723619c47ccbcb6d50123eafb741f972181d02"), "🍊🍊, TPDU lenght not correct")
    XCTAssert("52" == stringLenghtInOctets("01000B915892214365F700002C493a283d07d9cbf23cc85e96e741e5f03c0fa2bf41ec7258ee06ddd16537a8fda6a7ed617a990c"), "🍊🍊, TPDU lenght not correct")
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
  
  // MARK: - Decoder
  func testDecoderFromPDU() {
    
    XCTAssert(("+85290000000", "+85291234567", "It is easy to send text messages.") == DecoderPDU(smsMssg: "+CMT:,42\r07915892000000F001000B915892214365F7000021493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E").decode(), "🍊🍊, Decoding not correct")
    XCTAssert(("+8529000000", "+8529123456", "It is easy") == DecoderPDU(smsMssg: "+CMT:,21\r0691589200000001000A91589221436500000A493A283D0795C3F33C").decode(), "🍊🍊, Decoding not correct")
    XCTAssert(("+85222333", "+3816688993", "Lorem ipsum!") == DecoderPDU(smsMssg: "+CMT:,23\r05915822323301000A91836186983900000CCCB7BCDC06A5E1F37A3B04").decode(), "🍊🍊, Decoding not correct")
    XCTAssert(("+85222333", "+3816688993", "Lorem ipsum!") == DecoderPDU(smsMssg: "AT+CMGS:23\r05915822323301000A91836186983900000CCCB7BCDC06A5E1F37A3B04").decode(), "🍊🍊, Decoding not correct")
  }
  
  func seperateSMSCPart() {
    XCTAssert("06915892000000" == DecoderPDU().smsc("0691589200000001000A915892214365000005CCB7BCDC06", tpduLengthInt: 19), "🍊🍊, SMSC part not extracted")
    XCTAssert("06915892000000" == DecoderPDU().smsc("0691589200000001000A91589221436500000FCCB7BCDC06A5E1F37A1B549ED301", tpduLengthInt: 26), "🍊🍊, SMSC part not extracted")
    XCTAssert("06915892003033" == DecoderPDU().smsc("0691589200303301000A91589221131100000EC8329BFD065D9F522631140A01", tpduLengthInt: 25), "🍊🍊, SMSC part not extracted")
  }
  
  
  func seperateTPDUPart() {
    XCTAssert("0100089158063033000008E8329BFD0E8542" == DecoderPDU().tpdu("01000A91589221225500000EC8329BFD065D9F522631140A01", smscPart: "06915892003033"), "🍊🍊, TPDU part not extracted")
    XCTAssert("0100099158882252F5000012CCB7BCDC06A5E1F37A1B549ED343A110" == DecoderPDU().tpdu("069158924433F30100099158882252F5000012CCB7BCDC06A5E1F37A1B549ED343A110", smscPart: "069158924433F3"), "🍊🍊, TPDU part not extracted")
    XCTAssert("0100099168892252F5000019493A283D07D9CBF23CA81C9EE741F437685E2E874221" == DecoderPDU().tpdu("069158554433F30100099168892252F5000019493A283D07D9CBF23CA81C9EE741F437685E2E874221", smscPart: "069158554433F3"), "🍊🍊, TPDU part not extracted")
  }
  
  func testDecomposeSMSCPart() {
    XCTAssert(("06","91","8822213314") == DecoderPDU().decomposeSMSC("06918822213314"), "🍊🍊, Decomposing of SMSC not correct")
    XCTAssert(("05","91","882221F1") == DecoderPDU().decomposeSMSC("0591882221F1"), "🍊🍊, Decomposing of SMSC not correct")
    XCTAssert(("07","91","5892000000F0") == DecoderPDU().decomposeSMSC("07915892000000F0"), "🍊🍊, Decomposing of SMSC not correct")
  }
  
  func testDecomposeTPDUPart() {
    var decPDU = TPDU().decomposeTPDUPart("0100099183718254F600000EC8329BFD0699E5E9B29B1C0A01")
    
    let firstSixFields1 = (decPDU.tpduType, decPDU.mssgRefNumber, decPDU.lenghtOfDestPhoneNum, decPDU.typeOfPhoneNum, decPDU.destPhoneNumber, decPDU.protocolIdentifier)
    let lastThreFields1 = (decPDU.dataCodeScheme, decPDU.lenghtSMSBodyInSeptets, decPDU.smsBody)
    XCTAssert(("01", "00", "09", "91", "83718254F6", "00") == firstSixFields1, "🍊🍊, Decomposing of TPDU not correct")
    XCTAssert(("00", "0E", "C8329BFD0699E5E9B29B1C0A01") == lastThreFields1, "🍊🍊, Decomposing of TPDU not correct")
    
    decPDU = TPDU().decomposeTPDUPart("010008915806303300000BCCB7BCDC0625E1F37A1B")
    let firstSixFields2 = (decPDU.tpduType, decPDU.mssgRefNumber, decPDU.lenghtOfDestPhoneNum, decPDU.typeOfPhoneNum, decPDU.destPhoneNumber, decPDU.protocolIdentifier)
    let lastThreFields2 = (decPDU.dataCodeScheme, decPDU.lenghtSMSBodyInSeptets, decPDU.smsBody)
    XCTAssert(("01", "00", "08", "91", "58063033", "00") == firstSixFields2, "🍊🍊, Decomposing of TPDU not correct")
    XCTAssert(("00", "0B", "CCB7BCDC0625E1F37A1B") == lastThreFields2, "🍊🍊, Decomposing of TPDU not correct")
    
    decPDU = TPDU().decomposeTPDUPart("01000B915892214365F7000000")
    let firstSixFields3 = (decPDU.tpduType, decPDU.mssgRefNumber, decPDU.lenghtOfDestPhoneNum, decPDU.typeOfPhoneNum, decPDU.destPhoneNumber, decPDU.protocolIdentifier)
    let lastThreFields3 = (decPDU.dataCodeScheme, decPDU.lenghtSMSBodyInSeptets, decPDU.smsBody)
    XCTAssert(("01", "00", "0B", "91", "5892214365F7", "00") == firstSixFields3, "🍊🍊, Decomposing of TPDU not correct")
    XCTAssert(("00", "00", "") == lastThreFields3, "🍊🍊, Decomposing of TPDU not correct")
  }
  
  func testTpduLenght() {
    
    let decoderPDU1 = DecoderPDU(smsMssg: "+CMT:,23\r05915822323301000A91836186983900000CCCB7BCDC06A5E1F37A3B04")
    XCTAssert(23 == Int(decoderPDU1.tpduLenghtInOctets(decoderPDU1.smsMssg, crIndex: 8)), "🍊🍊, Lenght of TPDU not correct")
    let decoderPDU2 = DecoderPDU(smsMssg: "+CMT:,41\r0691589200000001000A915892214365000021493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E")
    XCTAssert(41 == Int(decoderPDU1.tpduLenghtInOctets(decoderPDU2.smsMssg, crIndex: 8)), "🍊🍊, Lenght of TPDU not correct")
    let decoderPDU3 = DecoderPDU(smsMssg: "+CMT:,17\r0691589200000001000A915892214365000005CCB7BCDC06")
    XCTAssert(17 == Int(decoderPDU1.tpduLenghtInOctets(decoderPDU3.smsMssg, crIndex: 8)), "🍊🍊, Lenght of TPDU not correct")
  }
  
  func testTPDUMssgExtract() {
    XCTAssert(("0691589200000001000A915892214365000005CCB7BCDC06", "17") == DecoderPDU().extractPDUPartsFromSMS("+CMT:,17\r0691589200000001000A915892214365000005CCB7BCDC06"), "🍊🍊, TPDU part and TPDU lenght not correct")
    XCTAssert(("0691589200000001000A915892214365000021493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E", "41") == DecoderPDU().extractPDUPartsFromSMS("+CMT:,41\r0691589200000001000A915892214365000021493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E"), "🍊🍊, TPDU part and TPDU lenght not correct")
    XCTAssert(("05915822323301000A91836186983900000CCCB7BCDC06A5E1F37A3B04", "23") == DecoderPDU().extractPDUPartsFromSMS("+CMT:,23\r05915822323301000A91836186983900000CCCB7BCDC06A5E1F37A3B04"), "🍊🍊, TPDU part and TPDU lenght not correct")
  }
  
  func testSMSCNumberDecoder() {
    XCTAssert("+85290012341" == SMSC().senderSMSCNumber("5892002143F1", numberType: "91"), "🍊🍊, SMSC number part not correctly decoded")
    XCTAssert("+8529001234" == SMSC().senderSMSCNumber("5892002143", numberType: "91"), "🍊🍊, SMSC number part not correctly decoded")
    XCTAssert("+85292345" == SMSC().senderSMSCNumber("58923254", numberType: "91"), "🍊🍊, SMSC number part not correctly decoded")
  }
  
  func testDestinationNumberDecoder() {
    XCTAssert("+8529123111" == TPDU().destinationPhoneNumber("01000A91589221131100000EC8329BFD065D9F522631140A01", lenghtStringHex: "0A", typeOfPhoneNumber: "91"), "🍊🍊, receiver number part not correctly decoded")
    XCTAssert("+85291234567" == TPDU().destinationPhoneNumber("01000B915892214365F7000000", lenghtStringHex: "0B", typeOfPhoneNumber: "91"), "🍊🍊, receiver number part not correctly decoded")
    XCTAssert("+8529122255" == TPDU().destinationPhoneNumber("01000A91589221225500000EC8329BFD065D9F522631140A01", lenghtStringHex: "0A", typeOfPhoneNumber: "91"), "🍊🍊, receiver number part not correctly decoded")
  }
  
  func testData7BitDecoder() {
    XCTAssert("Hello!!!" == TPDU().decodeSMSMssgBodyFromtext("C8329BFD0E8542"), "🍊🍊, 7 bit data decoder not working")
    XCTAssert("It is easy to send text messages." == TPDU().decodeSMSMssgBodyFromtext("493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E"), "🍊🍊, 7 bit data decoder not working")
    XCTAssert("" == TPDU().decodeSMSMssgBodyFromtext(""), "🍊🍊, 7 bit data decoder not working")
  }
  
  // MARK: - PDU Helper Functions
  func testSearchFirstIndexOfSpecialCharacters() {
    XCTAssert(3 == indexOfFirstEscapedSpecialCharacter("\r", string: "123\r4567"), "🍊🍊, Index not correct")
    XCTAssert(8 == indexOfFirstEscapedSpecialCharacter("\r", string: "+CMT:,42\r07915892000000F001000B915892214365F7000021493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E"), "🍊🍊, Index not correct")
    XCTAssert(8 == indexOfFirstEscapedSpecialCharacter("\r", string: "+CMT:,42\r07915\r892000000F001000B915892214365F7000021493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E"), "🍊🍊, Index not correct")
    XCTAssert(-1 == indexOfFirstEscapedSpecialCharacter("\r", string: "+CM365F7000021493A283D0795C3F33C88FE06CDCB6E32885EC6D341EDF27C1E3E97E72E"), "🍊🍊, Index not correct")
  }
  
  
  func testAllIndexesOfEscapedSpecialCharacter() {
    XCTAssert([15] == allIndexesOfEscapedSpecialCharacter("\n", inString: "123\r4\r777\rdsfsf\nfsdsdf"))
    XCTAssert([] == allIndexesOfEscapedSpecialCharacter("\n", inString: "123\r4\r777\rdsfsffsdsdf"))
    XCTAssert([3,5,9] == allIndexesOfEscapedSpecialCharacter("\r", inString: "123\r4\r777\rdsfsf\nfsd\ns\nd\tf"))
  }
  
  
  func testAllIndexesOfAllEscapedSpecialCharacters() {
    XCTAssert([1, 3, 5] == allIndexesOfAllEscapedSpecialCharacters(inString: "1\r2\r4\n"))
    XCTAssert([3, 5, 9, 15, 19, 21, 23] == allIndexesOfAllEscapedSpecialCharacters(inString: "123\r4\r777\rdsfsf\nfsd\ns\nd\tf"))
    XCTAssert([3, 6, 8, 10] == allIndexesOfAllEscapedSpecialCharacters(inString: "123\r4d\ns\nd\tf"))
  }

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
  
  func testNumbArrayPadLastElementForPDU() {
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
