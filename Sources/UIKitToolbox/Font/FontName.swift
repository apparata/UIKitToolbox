//
//  Copyright © 2017 Apparata AB. All rights reserved.
//

#if canImport(UIKit)

import UIKit

public enum Font: String {
    
    case academyEngravedLetPlain = "AcademyEngravedLetPlain"
    
    case alNileBold = "AlNile-Bold"
    case alNile = "AlNile"
    
    case americanTypewriterCondensedLight = "AmericanTypewriter-CondensedLight"
    case americanTypewriter = "AmericanTypewriter"
    case americanTypewriterCondensedBold = "AmericanTypewriter-CondensedBold"
    case americanTypewriterLight = "AmericanTypewriter-Light"
    case americanTypewriterSemibold = "AmericanTypewriter-Semibold"
    case americanTypewriterBold = "AmericanTypewriter-Bold"
    case americanTypewriterCondensed = "AmericanTypewriter-Condensed"
    
    case appleColorEmoji = "AppleColorEmoji"
    
    case appleSDGothicNeoBold = "AppleSDGothicNeo-Bold"
    case appleSDGothicNeoUltraLight = "AppleSDGothicNeo-UltraLight"
    case appleSDGothicNeoThin = "AppleSDGothicNeo-Thin"
    case appleSDGothicNeoRegular = "AppleSDGothicNeo-Regular"
    case appleSDGothicNeoLight = "AppleSDGothicNeo-Light"
    case appleSDGothicNeoMedium = "AppleSDGothicNeo-Medium"
    
    case appleSDGothicNeoSemiBold = "AppleSDGothicNeo-SemiBold"
    
    case arialMT = "ArialMT"
    case arialBoldItalicMT = "Arial-BoldItalicMT"
    case arialBoldMT = "Arial-BoldMT"
    case arialItalicMT = "Arial-ItalicMT"
    
    case arialHebrewBold = "ArialHebrew-Bold"
    case arialHebrewLight = "ArialHebrew-Light"
    case arialHebrew = "ArialHebrew"
    
    case arialRoundedMTBold = "ArialRoundedMTBold"
    
    case avenirMedium = "Avenir-Medium"
    case avenirHeavyOblique = "Avenir-HeavyOblique"
    case avenirBook = "Avenir-Book"
    case avenirLight = "Avenir-Light"
    case avenirRoman = "Avenir-Roman"
    case avenirBookOblique = "Avenir-BookOblique"
    case avenirMediumOblique = "Avenir-MediumOblique"
    case avenirBlack = "Avenir-Black"
    case avenirBlackOblique = "Avenir-BlackOblique"
    case avenirHeavy = "Avenir-Heavy"
    case avenirLightOblique = "Avenir-LightOblique"
    case avenirOblique = "Avenir-Oblique"
    
    case avenirNextUltraLight = "AvenirNext-UltraLight"
    case avenirNextUltraLightItalic = "AvenirNext-UltraLightItalic"
    case avenirNextBold = "AvenirNext-Bold"
    case avenirNextBoldItalic = "AvenirNext-BoldItalic"
    case avenirNextDemiBold = "AvenirNext-DemiBold"
    case avenirNextDemiBoldItalic = "AvenirNext-DemiBoldItalic"
    case avenirNextMedium = "AvenirNext-Medium"
    case avenirNextHeavyItalic = "AvenirNext-HeavyItalic"
    case avenirNextHeavy = "AvenirNext-Heavy"
    case avenirNextItalic = "AvenirNext-Italic"
    case avenirNextRegular = "AvenirNext-Regular"
    case avenirNextMediumItalic = "AvenirNext-MediumItalic"
    
    case avenirNextCondensedBoldItalic = "AvenirNextCondensed-BoldItalic"
    case avenirNextCondensedHeavy = "AvenirNextCondensed-Heavy"
    case avenirNextCondensedMedium = "AvenirNextCondensed-Medium"
    case avenirNextCondensedRegular = "AvenirNextCondensed-Regular"
    case avenirNextCondensedHeavyItalic = "AvenirNextCondensed-HeavyItalic"
    case avenirNextCondensedMediumItalic = "AvenirNextCondensed-MediumItalic"
    case avenirNextCondensedItalic = "AvenirNextCondensed-Italic"
    case avenirNextCondensedUltraLightItalic = "AvenirNextCondensed-UltraLightItalic"
    case avenirNextCondensedUltraLight = "AvenirNextCondensed-UltraLight"
    case avenirNextCondensedDemiBold = "AvenirNextCondensed-DemiBold"
    case avenirNextCondensedBold = "AvenirNextCondensed-Bold"
    case avenirNextCondensedDemiBoldItalic = "AvenirNextCondensed-DemiBoldItalic"
    
    case baskervilleItalic = "Baskerville-Italic"
    case baskervilleSemiBold = "Baskerville-SemiBold"
    case baskervilleBoldItalic = "Baskerville-BoldItalic"
    case baskervilleSemiBoldItalic = "Baskerville-SemiBoldItalic"
    case baskervilleBold = "Baskerville-Bold"
    case baskerville = "Baskerville"
    
    case bodoniSvtyTwoITCTTBold = "BodoniSvtyTwoITCTT-Bold"
    case bodoniSvtyTwoITCTTBook = "BodoniSvtyTwoITCTT-Book"
    case bodoniSvtyTwoITCTTBookIta = "BodoniSvtyTwoITCTT-BookIta"
    
    case bodoniSvtyTwoOSITCTTBook = "BodoniSvtyTwoOSITCTT-Book"
    case bodoniSvtyTwoOSITCTTBold = "BodoniSvtyTwoOSITCTT-Bold"
    case bodoniSvtyTwoOSITCTTBookIt = "BodoniSvtyTwoOSITCTT-BookIt"
    
    case bodoniSvtyTwoSCITCTTBook = "BodoniSvtyTwoSCITCTT-Book"
    
    case bodoniOrnamentsITCTT = "BodoniOrnamentsITCTT"
    
    case bradleyHandITCTTBold = "BradleyHandITCTT-Bold"
    
    case chalkboardSEBold = "ChalkboardSE-Bold"
    case chalkboardSELight = "ChalkboardSE-Light"
    case chalkboardSERegular = "ChalkboardSE-Regular"
    
    case chalkduster = "Chalkduster"
    
    case cochinBold = "Cochin-Bold"
    case cochin = "Cochin"
    case cochinItalic = "Cochin-Italic"
    case cochinBoldItalic = "Cochin-BoldItalic"
    
    case copperplateLight = "Copperplate-Light"
    case copperplate = "Copperplate"
    case copperplateBold = "Copperplate-Bold"
    
    case courierBoldOblique = "Courier-BoldOblique"
    case courier = "Courier"
    case courierBold = "Courier-Bold"
    case courierOblique = "Courier-Oblique"
    
    case courierNewPSBoldMT = "CourierNewPS-BoldMT"
    case courierNewPSItalicMT = "CourierNewPS-ItalicMT"
    case courierNewPSMT = "CourierNewPSMT"
    case courierNewPSBoldItalicMT = "CourierNewPS-BoldItalicMT"
    
    case damascusLight = "DamascusLight"
    case damascusBold = "DamascusBold"
    case damascusSemiBold = "DamascusSemiBold"
    case damascusMedium = "DamascusMedium"
    case damascus = "Damascus"
    
    case devanagariSangamMN = "DevanagariSangamMN"
    case devanagariSangamMNBold = "DevanagariSangamMN-Bold"
    
    case didotItalic = "Didot-Italic"
    case didotBold = "Didot-Bold"
    case didot = "Didot"
    
    case euphemiaUCASItalic = "EuphemiaUCAS-Italic"
    case euphemiaUCAS = "EuphemiaUCAS"
    case euphemiaUCASBold = "EuphemiaUCAS-Bold"
    
    case farah = "Farah"
    
    case futuraCondensedMedium = "Futura-CondensedMedium"
    case futuraCondensedExtraBold = "Futura-CondensedExtraBold"
    case futuraMedium = "Futura-Medium"
    case futuraMediumItalic = "Futura-MediumItalic"
    case futuraBold = "Futura-Bold"
    
    case geezaPro = "GeezaPro"
    case geezaProBold = "GeezaPro-Bold"
    
    case georgiaBoldItalic = "Georgia-BoldItalic"
    case georgia = "Georgia"
    case georgiaItalic = "Georgia-Italic"
    case georgiaBold = "Georgia-Bold"
    
    case gillSansItalic = "GillSans-Italic"
    case gillSansBold = "GillSans-Bold"
    case gillSansBoldItalic = "GillSans-BoldItalic"
    case gillSansLightItalic = "GillSans-LightItalic"
    case gillSans = "GillSans"
    case gillSansLight = "GillSans-Light"
    case gillSansSemiBold = "GillSans-SemiBold"
    case gillSansSemiBoldItalic = "GillSans-SemiBoldItalic"
    case gillSansUltraBold = "GillSans-UltraBold"
    
    case gujaratiSangamMNBold = "GujaratiSangamMN-Bold"
    case gujaratiSangamMN = "GujaratiSangamMN"
    
    case gurmukhiMNBold = "GurmukhiMN-Bold"
    case gurmukhiMN = "GurmukhiMN"
    
    case helveticaBold = "Helvetica-Bold"
    case helvetica = "Helvetica"
    case helveticaLightOblique = "Helvetica-LightOblique"
    case helveticaOblique = "Helvetica-Oblique"
    case helveticaBoldOblique = "Helvetica-BoldOblique"
    case helveticaLight = "Helvetica-Light"
    
    case helveticaNeueItalic = "HelveticaNeue-Italic"
    case helveticaNeueBold = "HelveticaNeue-Bold"
    case helveticaNeueUltraLight = "HelveticaNeue-UltraLight"
    case helveticaNeueCondensedBlack = "HelveticaNeue-CondensedBlack"
    case helveticaNeueBoldItalic = "HelveticaNeue-BoldItalic"
    case helveticaNeueCondensedBold = "HelveticaNeue-CondensedBold"
    case helveticaNeueMedium = "HelveticaNeue-Medium"
    case helveticaNeueLight = "HelveticaNeue-Light"
    case helveticaNeueThin = "HelveticaNeue-Thin"
    case helveticaNeueThinItalic = "HelveticaNeue-ThinItalic"
    case helveticaNeueLightItalic = "HelveticaNeue-LightItalic"
    case helveticaNeueUltraLightItalic = "HelveticaNeue-UltraLightItalic"
    case helveticaNeueMediumItalic = "HelveticaNeue-MediumItalic"
    case helveticaNeue = "HelveticaNeue"
    
    case hiraMinProNW6 = "HiraMinProN-W6"
    case hiraMinProNW3 = "HiraMinProN-W3"
    
    case hiraginoSansW3 = "HiraginoSans-W3"
    case hiraginoSansW6 = "HiraginoSans-W6"
    
    case hoeflerTextItalic = "HoeflerText-Italic"
    case hoeflerTextRegular = "HoeflerText-Regular"
    case hoeflerTextBlack = "HoeflerText-Black"
    case hoeflerTextBlackItalic = "HoeflerText-BlackItalic"
    
    case kailasaBold = "Kailasa-Bold"
    case kailasa = "Kailasa"
    
    case kannadaSangamMN = "KannadaSangamMN"
    case kannadaSangamMNBold = "KannadaSangamMN-Bold"
    
    case khmerSangamMN = "KhmerSangamMN"
    
    case kohinoorBanglaSemibold = "KohinoorBangla-Semibold"
    case kohinoorBanglaRegular = "KohinoorBangla-Regular"
    case kohinoorBanglaLight = "KohinoorBangla-Light"
    
    case kohinoorDevanagariLight = "KohinoorDevanagari-Light"
    case kohinoorDevanagariRegular = "KohinoorDevanagari-Regular"
    case kohinoorDevanagariSemibold = "KohinoorDevanagari-Semibold"
    
    case kohinoorTeluguRegular = "KohinoorTelugu-Regular"
    case kohinoorTeluguMedium = "KohinoorTelugu-Medium"
    case kohinoorTeluguLight = "KohinoorTelugu-Light"
    
    case laoSangamMN = "LaoSangamMN"
    
    case malayalamSangamMNBold = "MalayalamSangamMN-Bold"
    case malayalamSangamMN = "MalayalamSangamMN"
    
    case markerFeltThin = "MarkerFelt-Thin"
    case markerFeltWide = "MarkerFelt-Wide"
    
    case menloItalic = "Menlo-Italic"
    case menloBold = "Menlo-Bold"
    case menloRegular = "Menlo-Regular"
    case menloBoldItalic = "Menlo-BoldItalic"
    
    case diwanMishafi = "DiwanMishafi"
    
    case myanmarSangamMNBold = "MyanmarSangamMN-Bold"
    case myanmarSangamMN = "MyanmarSangamMN"
    
    case noteworthyLight = "Noteworthy-Light"
    case noteworthyBold = "Noteworthy-Bold"
    
    case optimaRegular = "Optima-Regular"
    case optimaExtraBlack = "Optima-ExtraBlack"
    case optimaBoldItalic = "Optima-BoldItalic"
    case optimaItalic = "Optima-Italic"
    case optimaBold = "Optima-Bold"
    
    case oriyaSangamMN = "OriyaSangamMN"
    case oriyaSangamMNBold = "OriyaSangamMN-Bold"
    
    case palatinoBold = "Palatino-Bold"
    case palatinoRoman = "Palatino-Roman"
    case palatinoBoldItalic = "Palatino-BoldItalic"
    case palatinoItalic = "Palatino-Italic"
    
    case papyrus = "Papyrus"
    case papyrusCondensed = "Papyrus-Condensed"
    
    case partyLetPlain = "PartyLetPlain"
    
    case pingFangHKUltralight = "PingFangHK-Ultralight"
    case pingFangHKSemibold = "PingFangHK-Semibold"
    case pingFangHKThin = "PingFangHK-Thin"
    case pingFangHKLight = "PingFangHK-Light"
    case pingFangHKRegular = "PingFangHK-Regular"
    case pingFangHKMedium = "PingFangHK-Medium"
    
    case pingFangSCUltralight = "PingFangSC-Ultralight"
    case pingFangSCRegular = "PingFangSC-Regular"
    case pingFangSCSemibold = "PingFangSC-Semibold"
    case pingFangSCThin = "PingFangSC-Thin"
    case pingFangSCLight = "PingFangSC-Light"
    case pingFangSCMedium = "PingFangSC-Medium"
    
    case pingFangTCMedium = "PingFangTC-Medium"
    case pingFangTCRegular = "PingFangTC-Regular"
    case pingFangTCLight = "PingFangTC-Light"
    case pingFangTCUltralight = "PingFangTC-Ultralight"
    case pingFangTCSemibold = "PingFangTC-Semibold"
    case pingFangTCThin = "PingFangTC-Thin"
    
    case savoyeLetPlain = "SavoyeLetPlain"
    
    case sinhalaSangamMNBold = "SinhalaSangamMN-Bold"
    case sinhalaSangamMN = "SinhalaSangamMN"
    
    case snellRoundhandBold = "SnellRoundhand-Bold"
    case snellRoundhand = "SnellRoundhand"
    case snellRoundhandBlack = "SnellRoundhand-Black"
    
    case symbol = "Symbol"
    
    case tamilSangamMN = "TamilSangamMN"
    case tamilSangamMNBold = "TamilSangamMN-Bold"
    
    case thonburi = "Thonburi"
    case thonburiBold = "Thonburi-Bold"
    case thonburiLight = "Thonburi-Light"
    
    case timesNewRomanPSMT = "TimesNewRomanPSMT"
    case timesNewRomanPSBoldItalicMT = "TimesNewRomanPS-BoldItalicMT"
    case timesNewRomanPSItalicMT = "TimesNewRomanPS-ItalicMT"
    case timesNewRomanPSBoldMT = "TimesNewRomanPS-BoldMT"
    
    case trebuchetBoldItalic = "Trebuchet-BoldItalic"
    case trebuchetMS = "TrebuchetMS"
    case trebuchetMSBold = "TrebuchetMS-Bold"
    case trebuchetMSItalic = "TrebuchetMS-Italic"
    
    case verdanaItalic = "Verdana-Italic"
    case verdanaBoldItalic = "Verdana-BoldItalic"
    case verdana = "Verdana"
    case verdanaBold = "Verdana-Bold"
    
    case zapfDingbatsITC = "ZapfDingbatsITC"
    
    case zapfino = "Zapfino"
}

func generateFontEnum() {
    
    func camelBacked(_ fontName: String) -> String {
        let font = fontName.replacingOccurrences(of: "-", with: "")
        return String(font.prefix(1)).lowercased()
            + String(font.dropFirst())
    }
    
    print("public enum Font: String {")
    
    for family in UIFont.familyNames.sorted() where UIFont.fontNames(forFamilyName: family).count > 0 {
        print("")
        for font in UIFont.fontNames(forFamilyName: family) {
            print("    case \(camelBacked(font)) = \"\(font)\"")
        }
    }
    
    print("}")
}

#endif
