/* SPDX-License-Identifier: LGPL-2.1-or-later */
/*
 * Copyright (c) 2019 Collabora Ltd <arnaud.ferraris@collabora.com>
 */

#import <Carbon/Carbon.h>
#import <CoreWLAN/CoreWLAN.h>

#import "SystemSettings.h"

@implementation SESystemSettings

- (bool)readUserSettings
{
    NSDictionary *keymaps = @{
            @"2SetHangul"             : @"kr",
            @"390Hangul"              : @"kr",
            @"3SetHangul"             : @"kr",
            @"AfghanDari"             : @"af",
            @"AfghanPashto"           : @"af,ps",
            @"AfghanUzbek"            : @"af,uz",
            @"Anjal"                  : @"", /**************** TODO ****************/
            @"Arabic"                 : @"ara,mac",
            @"Arabic-QWERTY"          : @"ara,qwerty",
            @"ArabicPC"               : @"ara",
            @"Armenian-HMQWERTY"      : @"am",
            @"Armenian-WesternQWERTY" : @"am,western",
            @"Australian"             : @"au",
            @"Austrian"               : @"at,mac",
            @"Azeri"                  : @"az",
            @"Bangla"                 : @"bd",
            @"Bangla-QWERTY"          : @"bd",
            @"Belgian"                : @"be",
            @"Brazilian"              : @"br",
            @"British"                : @"uk,mac",
            @"British-PC"             : @"uk",
            @"Bulgarian"              : @"bg",
            @"Bulgarian-Phonetic"     : @"bg,phonetic",
            @"Byelorussian"           : @"by",
            @"Canadian"               : @"ca",
            @"Canadian-CSA"           : @"ca,multix",
            @"CangjieKeyboard"        : @"cn",
            @"Cherokee-Nation"        : @"us,chr",
            @"Cherokee-QWERTY"        : @"us,chr",
            @"Colemak"                : @"uk,colemak",
            @"Croatian"               : @"hr",
            @"Croatian-PC"            : @"hr",
            @"Czech"                  : @"cz",
            @"Czech-QWERTY"           : @"cz,qwerty",
            @"DVORAK-QWERTYCMD"       : @"us,dvorak-classic",
            @"Danish"                 : @"dk,mac",
            @"Devanagari"             : @"", /**************** TODO ****************/
            @"Devanagari-QWERTY"      : @"", /**************** TODO ****************/
            @"Dutch"                  : @"nl,mac",
            @"Dvorak"                 : @"us,dvorak",
            @"Dvorak-Left"            : @"us,dvorak-l",
            @"Dvorak-Right"           : @"us,dvorak-r",
            @"Estonian"               : @"ee",
            @"Faroese"                : @"fo",
            @"Finnish"                : @"fi,mac",
            @"FinnishExtended"        : @"fi,mac",
            @"FinnishSami-PC"         : @"fi,smi",
            @"French"                 : @"fr,mac",
            @"French-numerical"       : @"fr,mac",
            @"French-PC"              : @"fr",
            @"GJCRomaja"              : @"kr",
            @"Georgian-QWERTY"        : @"ge",
            @"German"                 : @"de,mac",
            @"Greek"                  : @"gr",
            @"GreekPolytonic"         : @"gr,polytonic",
            @"Gujarati"               : @"in,guj",
            @"Gujarati-QWERTY"        : @"in,guj",
            @"Gurmukhi"               : @"in,guru",
            @"Gurmukhi-QWERTY"        : @"in,guru",
            @"HNCRomaja"              : @"kr",
            @"Hawaiian"               : @"", /**************** TODO ****************/
            @"Hebrew"                 : @"il",
            @"Hebrew-PC"              : @"il",
            @"Hebrew-QWERTY"          : @"il",
            @"Hungarian"              : @"hu",
            @"Icelandic"              : @"is,mac",
            @"Inuktitut-Nunavut"      : @"ca,ike",
            @"Inuktitut-Nutaaq"       : @"ca,ike",
            @"Inuktitut-QWERTY"       : @"ca,ike",
            @"InuttitutNunavik"       : @"ca,ike",
            @"Irish"                  : @"ie",
            @"IrishExtended"          : @"ie",
            @"Italian"                : @"it,mac",
            @"Italian-Pro"            : @"it,mac",
            @"Jawi-QWERTY"            : @"my",
            @"KANA"                   : @"jp,kana",
            @"Kannada"                : @"in,kan",
            @"Kannada-QWERTY"         : @"in,kan",
            @"Kazakh"                 : @"kz",
            @"Khmer"                  : @"kh",
            @"Kurdish-Sorani"         : @"iq,ku",
            @"Latvian"                : @"lv",
            @"Lithuanian"             : @"lt",
            @"Macedonian"             : @"mk",
            @"Malayalam"              : @"in,mal",
            @"Malayalam-QWERTY"       : @"in,mal",
            @"Maltese"                : @"mt",
            @"Maori"                  : @"mao",
            @"Myanmar-QWERTY"         : @"", /**************** TODO ****************/
            @"Nepali"                 : @"np",
            @"NorthernSami"           : @"se,smi",
            @"Norwegian"              : @"no,mac",
            @"NorwegianExtended"      : @"no,mac",
            @"NorwegianSami-PC"       : @"no,smi",
            @"Oriya"                  : @"in,ori",
            @"Oriya-QWERTY"           : @"in,ori",
            @"Persian"                : @"ir",
            @"Persian-ISIRI2901"      : @"ir",
            @"Persian-QWERTY"         : @"ir",
            @"Polish"                 : @"pl",
            @"PolishPro"              : @"pl",
            @"Portuguese"             : @"pt,mac",
            @"Romanian"               : @"ro",
            @"Romanian-Standard"      : @"ro,std",
            @"Russian"                : @"ru,mac",
            @"Russian-Phonetic"       : @"ru,phonetic",
            @"RussianWin"             : @"ru,phonetic_winkeys",
            @"Sami-PC"                : @"fi,smi",
            @"Serbian"                : @"rs",
            @"Serbian-Latin"          : @"rs,latin",
            @"Sinhala"                : @"lk",
            @"Sinhala-QWERTY"         : @"lk,us",
            @"Slovak"                 : @"sk",
            @"Slovak-QWERTY"          : @"sk,qwerty",
            @"Slovenian"              : @"si",
            @"Spanish"                : @"es,mac",
            @"Spanish-ISO"            : @"es",
            @"Swedish"                : @"se,mac",
            @"Swedish-Pro"            : @"se,mac",
            @"SwedishSami-PC"         : @"se,smi",
            @"SwissFrench"            : @"ch,fr_mac",
            @"SwissGerman"            : @"ch,de_mac",
            @"Tamil99"                : @"in,tam_tamilnet",
            @"Telugu"                 : @"in,tel",
            @"Telugu-QWERTY"          : @"in,tel",
            @"Thai"                   : @"th",
            @"Thai-PattaChote"        : @"th,pat",
            @"Tibetan-QWERTY"         : @"cn,tib",
            @"Tibetan-Wylie"          : @"cn,tib",
            @"TibetanOtaniUS"         : @"cn,tib",
            @"Turkish"                : @"tr",
            @"Turkish-QWERTY"         : @"tr,intl",
            @"Turkish-QWERTY-PC"      : @"tr,intl",
            @"US"                     : @"us,mac",
            @"USExtended"             : @"us,mac",
            @"USInternational-PC"     : @"us,intl",
            @"Ukrainian"              : @"ua",
            @"UnicodeHexInput"        : @"", /**************** TODO ****************/
            @"Urdu"                   : @"in,urd-winkeys",
            @"Uyghur"                 : @"cn,ug",
            @"Vietnamese"             : @"vn",
            @"Welsh"                  : @"gb",
            @"WubihuaKeyboard"        : @"cn",
            @"WubixingKeyboard"       : @"cn",
            @"ZhuyinBopomofo"         : @"cn",
            @"ZhuyinEten"             : @"cn"
    };
    
    // Get timezone
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    self.timezone = [NSString stringWithString:[tz name]];
    
    // Get locale
    NSLocale *userLocale = [NSLocale currentLocale];
    self.locale = [NSString stringWithString:[userLocale localeIdentifier]];
    
    // Get keyboard
    TISInputSourceRef keyLayout = TISCopyCurrentKeyboardLayoutInputSource();
    CFStringRef keyboardStr = TISGetInputSourceProperty(keyLayout, kTISPropertyInputSourceID);
    if (keyboardStr) {
        CFRange fullString, result;
        
        fullString.location = 0;
        fullString.length = CFStringGetLength(keyboardStr);
        
        if (CFStringFindWithOptions(keyboardStr, CFSTR("."), fullString, kCFCompareBackwards, &result)) {
            result.location++;
            result.length = fullString.length - result.location;
            
            CFStringRef keyLang = CFStringCreateWithSubstring(NULL, keyboardStr, result);
            self.macKeymap = [NSString stringWithString:(__bridge NSString *)keyLang];
            
            CFRelease(keyLang);
        }
        CFRelease(keyboardStr);
    }
    CFRelease(keyLayout);

    if (!self.macKeymap) {
        NSLog(@"Unable to determine current keyboard layout!");
        return false;
    }
    
    // Convert to linux keymap
    self.linuxKeymap = [keymaps objectForKey:self.macKeymap];
    if (!self.linuxKeymap) {
        NSLog(@"Unable to find linux keymap corresponding to '%@'!", self.macKeymap);
        return false;
    } else if ([self.linuxKeymap length] == 0) {
        self.linuxKeymap = @"us";
    }
    
    return true;
}

- (bool)readWifiCredentials
{
    CWWiFiClient *client = [CWWiFiClient sharedWiFiClient];
    NSArray *ifaces = [client interfaces];
    bool ret = false;
        
    for (int i = 0; i < [ifaces count]; i++) {
        CWInterface *iface = ifaces[i];
        NSString *__autoreleasing password;
        OSStatus err;

        self.wifiSSID = [NSString stringWithString:[iface ssid]];

        if (self.wifiSSID) {
            self.wifiMAC = [NSString stringWithString:[iface hardwareAddress]];
            
            switch ([iface security]) {
                case kCWSecurityDynamicWEP:
                case kCWSecurityWEP:
                    self.wifiSecurity = wep;
                    break;
                case kCWSecurityPersonal:
                case kCWSecurityWPAPersonal:
                case kCWSecurityWPAPersonalMixed:
                case kCWSecurityWPA2Personal:
                    self.wifiSecurity = wpa;
                    break;
                default:
                    self.wifiSecurity = none;
                    break;
            }
            
            if (self.wifiSecurity == none) {
                ret = true;
            } else {
                err = CWKeychainFindWiFiPassword(kCWKeychainDomainUser, [iface ssidData], &password);
                if (err != noErr)
                    err = CWKeychainFindWiFiPassword(kCWKeychainDomainSystem, [iface ssidData], &password);
                
                if (err == noErr) {
                    self.wifiPassword = [NSString stringWithString:password];
                    ret = true;
                } else {
                    NSLog(@"Password not found for SSID '%@'!", self.wifiSSID);
                }
            }
        }
    }
    
    return ret;
}

@end
