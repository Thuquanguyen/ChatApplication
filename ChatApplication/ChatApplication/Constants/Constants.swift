//
//  AppConstants.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit
import Photos

class Constants {

    static let itunesPath = "itms-apps://itunes.apple.com/app/id%@"
    
    //MARL: -- APP STORE URL
    static let appStoreUrl = "https://apps.apple.com/us/app/molisa-3s/?ls=1"

    // Write your constant variables below
    static let backImage = "back_black".image

    // Valid day of tts audio
    static let dayTtsUnavaible = 30
    struct font {
        enum Lato : String {
            case regular = "Lato-Regular"
            case medium = "Lato-Medium"
            case semiBold = "Lato-Semibold"
            case bold = "Lato-Bold"
            case heavy = "Lato-Heavy"
        }
        
        static func lato(type: Lato = .regular, size: CGFloat = 14.0) -> UIFont {
            return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size + 1)
        }
        
        enum Roboto : String {
        case regular = "Roboto-Regular"
        case italic = "Roboto-Italic"
        case bold = "Roboto-Bold"
        case boldItalic = "Roboto-BoldItalic"
        case medium = "Roboto-Medium"
        case mediumItalic = "Roboto-MediumItalic"
        case thin = "Roboto-Thin"
        case thinItalic = "Roboto-ThinItalic"
        case light = "Roboto-Light"
        case lightItalic = "Roboto-LightItalic"
        }

        static func roboto(type: Roboto = .regular, size: CGFloat = 14.0) -> UIFont {
        return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size + 1)
        }
    }
    
    enum ImageType: String {
        case jpg = "jpg"
        case jpeg = "jpeg"
        case png = "png"
        case gif = "gif"
        case heic = "heic"
    }
    
    enum FileType {
        case none
        case doc
        case docx
        case pdf
        case txt
        case xlsx
        case xls
        
        var value: String {
            switch self {
            case .none:
                return ""
            case .doc:
                return "doc"
            case .docx:
                return "docx"
            case .pdf:
                return "pdf"
            case .txt:
                return "txt"
            case .xlsx:
                return "xlsx"
            case .xls:
                return "xls"
            }
        }
        
        var mimeType: String {
            switch self {
            case .none:
                return "application/pdf"
            case .doc:
                return "application/msword"
            case .docx:
                return "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
            case .pdf:
                return "application/pdf"
            case .txt:
                return "application/txt"
            case .xlsx:
                return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            case .xls:
                return "application/vnd.ms-excel"
            }
        }
        
        static func checkFileDocument (_ url: URL?) -> Constants.FileType {
            
            guard let _url = url else {
                return Constants.FileType.none
            }
            
            let lastPathExtension = _url.pathExtension
            
            if lastPathExtension == Constants.FileType.doc.value {
                return Constants.FileType.doc
            } else if lastPathExtension == Constants.FileType.docx.value {
                return Constants.FileType.docx
            } else if lastPathExtension == Constants.FileType.pdf.value {
                return Constants.FileType.pdf
            } else if lastPathExtension == Constants.FileType.txt.value {
                return Constants.FileType.txt
            } else if lastPathExtension == Constants.FileType.xlsx.value {
                return Constants.FileType.xlsx
            } else if lastPathExtension == Constants.FileType.xls.value {
                return Constants.FileType.xls
            }
            
            return Constants.FileType.none
        }
    }
    
    struct string {
        static let imgProvinceInfoMenu = "Image_Intro_Province_Icon"
        static let chatbotLoadingAsset = "chat_bot_typing"
    }
    
    struct color {
        //App Color
        static let appPrimary = #colorLiteral(red: 0.1333333333, green: 0.5725490196, blue: 0.6901960784, alpha: 1) //UIColor("2292B0") //Màu chủ đạo của ứng dụng, sử dụng cho các icon
        static let appHighlight = #colorLiteral(red: 1, green: 0.6980392157, blue: 0.003921568627, alpha: 1) //UIColor("D63C4B") //Màu sử dụng cho button, icon, component nổi bật
        
        //App Text Color
        static let appDefaultText = #colorLiteral(red: 0.2274509804, green: 0.2705882353, blue: 0.3019607843, alpha: 1) //UIColor("3A454D") //Màu chữ mặc định
        static let appGrayText = #colorLiteral(red: 0.6431372549, green: 0.6509803922, blue: 0.6588235294, alpha: 1) //UIColor("A4A6A8") //Màu chữ sử dụng cho những nội dung ít quan trọng
        static let appHintText = #colorLiteral(red: 0.6431372549, green: 0.6509803922, blue: 0.6588235294, alpha: 1) //UIColor("A4A6A8") //Màu chữ sử dụng cho hint text (placeholder) trong các màn nhập thông tin
        static let appHighlightText = #colorLiteral(red: 1, green: 0.6980392157, blue: 0.007843137255, alpha: 1) //UIColor("D63C4B") //Màu chữ sử dụng cho những nội dung cần nổi bật
        static let appWhiteText = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //UIColor("FFFFFF") //Màu chữ sử dụng trên button, background màu khác
        
        //App Button Color
        static let appHighlightButton = #colorLiteral(red: 1, green: 0.6980392157, blue: 0.01176470588, alpha: 1) //UIColor("D63C4B")
        static let appDisableButton = #colorLiteral(red: 0.8588235294, green: 0.8588235294, blue: 0.8588235294, alpha: 1) //UIColor("DBDBDB")
        static let appHighlightTextButton = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //UIColor("FFFFFF")
        static let appDisableTextButton = #colorLiteral(red: 0.2274509804, green: 0.2705882353, blue: 0.3019607843, alpha: 1)  //UIColor("3A454D")
        static let appGradientStart = appPrimary
        static let appGradientEnd: UIColor = appPrimary.alpha(0)
        
        //VIET NAM AIRLINE
        static let VNAirlineGreenColor = #colorLiteral(red: 0.1333333333, green: 0.5647058824, blue: 0.6862745098, alpha: 1)
        static let VNAirlineBrownColor = #colorLiteral(red: 0.8823529412, green: 0.7490196078, blue: 0.5647058824, alpha: 1)
        static let VNAirlineOrangeColor = #colorLiteral(red: 0.9137254902, green: 0.6823529412, blue: 0.4352941176, alpha: 1)

        static let dark = UIColor("292C39")
        static let placeholder = UIColor("C7C7CD")
        //
        
        static let white = UIColor("ffffff")
        static let black = UIColor("000000")
        static let clear = UIColor.clear
        static let gray = UIColor("999999")
      
        static let green = UIColor("00cd22")
        static let yellow = UIColor("ffe3ae")
        static let red = UIColor("c0312d")
        
        static let buttonEnable = UIColor("D82334")
        static let grayBorderSearch = UIColor("b7b7b7")
        static let borderViewGray = UIColor("EDEDED")
        static let lightSeperator = UIColor("DBDBDB")
        
        static let lightText = UIColor("999999")
        static let darkRed = UIColor("930A0A")
        static let searchBackground = UIColor("F2F2F2")
        
        //Full Back -> Gray
        static let darkText = UIColor("3A454D")
        static let darkColor = UIColor("4F4F4F")
        static let grayText = UIColor("828282")
        static let grayColor = UIColor("BDBDBD")
        static let lightColor = UIColor("E0E0E0")
        static let light2Color = UIColor("F2F2F2")

        
        //Working Plan
        static let redStartDate  = UIColor("c83835")
        static let lineHeader = UIColor("f3f3f3")
        
        
        //Calendar
        struct calendar {
            static let inMonthLabelColor = UIColor("333333")
            static let outMonthLabelColor = UIColor("999999")
            static let selectedLabelColor = UIColor("e50f17")

        }
        
        //Goal
        struct goal {
            static let percentageYellow = UIColor("ffc835")
            static let percentageGreen = UIColor("32b81b")
            static let percentageRed = UIColor("da3838")
            static let grey = UIColor("b9b9b9")
        }
        
        //chart
        struct status {
            static let outOfDate = UIColor("e63534")
            static let waiting = UIColor("fc7c43")
            static let processing = UIColor("3d5e8f")
            static let sucess = UIColor("999999")
        }
        
        // ProgressBar
        struct progress {
            static let progressTint = appHighlight
        }
        
        // Chatbot Buble
        struct chatbot {
            static let bubbleStartColor = UIColor("E7533C")
            static let bubbleEndColor = UIColor("FF9F70")
        }
    }
    
    static func debug(object: NSObject? = nil, title: String) {
        #if RELEASE
        // hide msg when release.
        if let object = object {
            print("DEBUG:\t \(String(describing: type(of: object))) \t message: \(title))", to: &LogDestination.share)
        } else {
            print("DEBUG:\t message: \(title))",to: &LogDestination.share)
        }
        #else
        if let object = object {
            print("DEBUG:\t \(String(describing: type(of: object))) \t message: \(title))")
        } else {
            print("DEBUG:\t message: \(title))")
        }
        #endif
    }
    
    // My Suggest
    static let dateFormatCreate = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    
    static var DEVICE_TOKEN_KEY = "es_device_token"
    
    // Chat Bot app code
    #if DEVELOP || STAGING
    static let chatBotAppCode = ""
    #else
    static let chatBotAppCode = ""
    #endif

    // Chat Bot MCD app code
    #if DEVELOP || STAGING
    static let chatBotMCDAppCode = ""
    #else
    static let chatBotMCDAppCode = ""
    #endif
    
    // Open FPT API key
    #if DEVELOP || STAGING
    static let openFptApiKey = ""
    #else
    static let openFptApiKey = ""
    #endif
    
    // Chat Bot token code
    #if DEVELOP || STAGING
    static let chatBotTokenCode = ""
    #else
    static let chatBotTokenCode = ""
    #endif
    
    static let defaultImage = "img_placeholder".image

    // Timezone in Viet Nam
    static let vnTimezone = 7.0
    
    // Weather API Key
    #if DEVELOP || STAGING
    static let weatherAPIKey = ""
    #else
    static let weatherAPIKey = ""
    #endif
    
    static let dateFormat = "yyyy-MM-dd"
    static let dateFormatS = "dd/MM/yyyy"
    static let dateFormatYearS = "yyyy"
    static let dateFormatM = "dd/mm/yyyy"
    static let dateFormatAPI = "yyyy/MM/dd"
    static let dateFormatDisplay = "hh:mma dd/MM/yyyy"
    static let dateTimeFormat = "HH:mm dd/MM/yyyy"
    static let dateTimeFormatReverse = "dd/MM/yyyy HH:mm"
    static let hourFormat = "HH:mm"
    static let locate =  "en_US_POSIX"
    static let dateTimeFormatTime = "HH:mm:ss dd/MM/yyyy"
    static let dateTimeEventFormatTime = "HH:mm:ss yyyy-MM-dd"
    static let dateNotificationFormatTime = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    static let enterpriseTaxDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    static let promulgatedDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    static let publicServiceDateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    static let monitoringDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    //WebView Public Services
    
    // Demo app. Change is true when demo for client
    static var isDemoAppForFakeLocation: Bool = false
//    static var isDemoAppForShowObboarding: Bool = true
    #if DEVELOP
    static var isDemoAppForShowObboarding: Bool = false
    #else
    static var isDemoAppForShowObboarding: Bool = false
    #endif

    //PROVINCE
    struct ProvinceLocation {
        static let lat: Double = 20.985160
        static let lon: Double = 105.817869
    }
    
    //Bound province for GMSAutocomplete search place
    struct ProvinceBoundsLocation {
        struct CoordinateFirst {
            static let latitude: Double = 21.64821
            static let longitude: Double = 108.27026
        }
        struct CoordinateSecond {
            static let latitude: Double = 20.43059
            static let longitude: Double = 106.42731
        }
    }
    
    //Default Values
    struct DefaultValues {
        struct Size {
            static let naviHeight: CGFloat = 44.0
            static let margin: CGFloat = 8.0
            static let buttonHeight: CGFloat = 45.0
            
            struct DefaultFilter {
                static let headerHeight: CGFloat = 64.0 + 10.0
                static let footerHeight: CGFloat = 74.0 + 10.0
                static let tickCellHeight: CGFloat = 56.0 + 10.0
                static let dropdownCellHeight: CGFloat = 90.0
            }
        }
        
        struct FontSize {
            static let largeButtonTitle: CGFloat = 16.0
        }
    }
    
    //Storage Key
    struct StorageKey {
        struct UserDefault {
            static let firstLauchingApp: String = "FIRST_LAUNCHING_APP"
            static let oldEnvironment: String = "OLD_ENVIRONMENT"

            struct Translation {
                static let sourceLanguage: String = "TRANSLATION_SOURCE_LANGUAGE"
                static let targetLanguage: String = "TRANSLATION_TARGET_LANGUAGE"
            }
        }
        
        struct FontSize {
            static let largeButtonTitle: CGFloat = 16.0
        }
    }
        
    struct Environment {
        static let development: String = "DEVELOPMENT"
        static let production: String = "PRODUCTION"
    }
    
    // Limit character search
    static let limitCharacterSearch: Int = 255
    static let limitCharacterContent: Int = 4000
    static let limitCharacterComment: Int = 1000
    static let limitImagesUploadCount: Int = 10
    static let limitCharacterEmail: Int = 50
    static let limitCharacterPhone: Int = 20
    
    static let minRangePrice: CGFloat = 0.0
    static let maxRangePrice: CGFloat = 1000000.0
    
    //Rating Option
    struct RatingOption {
        static let good: Int = 0
        static let normal: Int = 1
        static let bad: Int = 2
    }

    // Login
    static let listFeature: [FeatureType] = [FeatureType.smartReminder, FeatureType.favotire]
        
    // Zalo secret id
    #if DEVELOP || STAGING
    static let zaloSecretId = ""
    #else
    static let zaloSecretId = ""
    #endif
    
    
    // Zalo app id
    #if DEVELOP || STAGING
    static let zaloAppId = ""
    #else
    static let zaloAppId = ""
    #endif

    // Google client id
    // Don't forget update URL Scheme
    #if DEVELOP || STAGING
    static let googleClientId = ""
    #else
    static let googleClientId = ""
    #endif
    
    // GMS API key
    #if DEVELOP || STAGING
    static let gmsAPIkey = ""
    #else
    static let gmsAPIkey = ""
    #endif
    
    // GMS API key for Google Translate
    #if DEVELOP || STAGING
    static let gmsTranslateAPIkey = ""
    #else
    static let gmsTranslateAPIkey = ""
    #endif
    
    static let isShowConsole = true
}

extension Constants {
    static let hotline = "0968646357"
}

extension UIFont {
    static func robotoRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func robotoBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
