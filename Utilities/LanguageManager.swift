//
//  LanguageManager.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

let kLMSelectedLanguageKey = "kLMSelectedLanguageKey"
let kLMDefaultLanguage = "en"
let kLMEnglish = "en"
let kLMFrench = "fr"

class LanguageManager: NSObject {
    
    //get current app language
    class func getCurrentLanguage() -> String
    {
        let language = UserDefaults.standard.value(forKey: kLMSelectedLanguageKey) as? String
        if(language == kLMFrench){
            return kLMFrench
        }else{
            return kLMEnglish
        }
    }
    
    //set current app language
    class func setCurrentLanguage(_ language: String)
    {
        //set default app language
        UserDefaults.standard.set(language, forKey: kLMSelectedLanguageKey)
    }
    
    //set localized string
    class func localizedString(_ key: String) -> String {
        let selectedLanguage: String = LanguageManager.selectedLanguage()
        // Get the corresponding bundle path.
        let path: String? = Bundle.main.path(forResource: selectedLanguage, ofType: "lproj")
        // Get the corresponding localized string.
        let languageBundle = Bundle(path: path!)
        let str = languageBundle?.localizedString(forKey: key, value: "", table: nil)
        
        if str == nil
        {
            return ""
        }else
        {
            return str!
        }
    }
    
    //check selected language supported or not
    class func isSupportedLanguage(_ language: String) -> Bool {
        if (language == kLMEnglish) {
            return true
        }
        if (language == kLMFrench) {
            return true
        }
        return false
    }
    
    //store language if supported
    class func setSelectedLanguage(_ language: String) {
        let userDefaults = UserDefaults.standard
        // Check if desired language is supported.
        if self.isSupportedLanguage(language) {
            userDefaults.set(language, forKey: kLMSelectedLanguageKey)
        }
        else {
            // if desired language is not supported, set selected language to nil.
            userDefaults.set(nil, forKey: kLMSelectedLanguageKey)
        }
    }
    
    class func selectedLanguage() -> String {
        // Get selected language from user defaults.
        let userDefaults = UserDefaults.standard
        var selectedLanguage: String? = userDefaults.string(forKey: kLMSelectedLanguageKey)
        // if the language is not defined in user defaults yet...
        if selectedLanguage == nil {
            selectedLanguage = kLMEnglish
        }
        
        //        let userLangs: [Any]? = userDefaults.object(forKey: "AppleLanguages") as? [Any]
        //        let systemLanguage: String? = (userLangs?[0] as? String)
        //          if system language is supported by LanguageManager, set it as selected language.
        if self.isSupportedLanguage(selectedLanguage!) {
            self.setSelectedLanguage(selectedLanguage!)
        }
        else {
            // Set the LanguageManager default language as selected language.
            self.setSelectedLanguage(kLMDefaultLanguage)
        }
        // }
        return userDefaults.string(forKey: kLMSelectedLanguageKey)!
    }
}
