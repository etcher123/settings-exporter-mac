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
            @"2SetHangul"             : @"",
            @"390Hangul"              : @"",
            @"3SetHangul"             : @"",
            @"AfghanDari"             : @"",
            @"AfghanPashto"           : @"",
            @"AfghanUzbek"            : @"",
            @"Anjal"                  : @"",
            @"Arabic"                 : @"",
            @"Arabic-QWERTY"          : @"",
            @"ArabicPC"               : @"",
            @"Armenian-HMQWERTY"      : @"",
            @"Armenian-WesternQWERTY" : @"",
            @"Australian"             : @"",
            @"Austrian"               : @"",
            @"Azeri"                  : @"",
            @"Bangla"                 : @"",
            @"Bangla-QWERTY"          : @"",
            @"Belgian"                : @"",
            @"Brazilian"              : @"",
            @"British"                : @"",
            @"British-PC"             : @"uk",
            @"Bulgarian"              : @"",
            @"Bulgarian-Phonetic"     : @"",
            @"Byelorussian"           : @"",
            @"Canadian"               : @"",
            @"Canadian-CSA"           : @"",
            @"CangjieKeyboard"        : @"",
            @"Cherokee-Nation"        : @"",
            @"Cherokee-QWERTY"        : @"",
            @"Colemak"                : @"",
            @"Croatian"               : @"",
            @"Croatian-PC"            : @"",
            @"Czech"                  : @"",
            @"Czech-QWERTY"           : @"",
            @"DVORAK-QWERTYCMD"       : @"",
            @"Danish"                 : @"",
            @"Devanagari"             : @"",
            @"Devanagari-QWERTY"      : @"",
            @"Dutch"                  : @"",
            @"Dvorak"                 : @"",
            @"Dvorak-Left"            : @"",
            @"Dvorak-Right"           : @"",
            @"Estonian"               : @"",
            @"Faroese"                : @"",
            @"Finnish"                : @"",
            @"FinnishExtended"        : @"",
            @"FinnishSami-PC"         : @"",
            @"French"                 : @"mac-fr",
            @"French-numerical"       : @"",
            @"GJCRomaja"              : @"",
            @"Georgian-QWERTY"        : @"",
            @"German"                 : @"",
            @"Greek"                  : @"",
            @"GreekPolytonic"         : @"",
            @"Gujarati"               : @"",
            @"Gujarati-QWERTY"        : @"",
            @"Gurmukhi"               : @"",
            @"Gurmukhi-QWERTY"        : @"",
            @"HNCRomaja"              : @"",
            @"Hawaiian"               : @"",
            @"Hebrew"                 : @"",
            @"Hebrew-PC"              : @"",
            @"Hebrew-QWERTY"          : @"",
            @"Hungarian"              : @"",
            @"Icelandic"              : @"",
            @"Inuktitut-Nunavut"      : @"",
            @"Inuktitut-Nutaaq"       : @"",
            @"Inuktitut-QWERTY"       : @"",
            @"InuttitutNunavik"       : @"",
            @"Irish"                  : @"",
            @"IrishExtended"          : @"",
            @"Italian"                : @"",
            @"Italian-Pro"            : @"",
            @"Jawi-QWERTY"            : @"",
            @"KANA"                   : @"",
            @"Kannada"                : @"",
            @"Kannada-QWERTY"         : @"",
            @"Kazakh"                 : @"",
            @"Khmer"                  : @"",
            @"Kurdish-Sorani"         : @"",
            @"Latvian"                : @"",
            @"Lithuanian"             : @"",
            @"Macedonian"             : @"",
            @"Malayalam"              : @"",
            @"Malayalam-QWERTY"       : @"",
            @"Maltese"                : @"",
            @"Maori"                  : @"",
            @"Myanmar-QWERTY"         : @"",
            @"Nepali"                 : @"",
            @"NorthernSami"           : @"",
            @"Norwegian"              : @"",
            @"NorwegianExtended"      : @"",
            @"NorwegianSami-PC"       : @"",
            @"Oriya"                  : @"",
            @"Oriya-QWERTY"           : @"",
            @"Persian"                : @"",
            @"Persian-ISIRI2901"      : @"",
            @"Persian-QWERTY"         : @"",
            @"Polish"                 : @"",
            @"PolishPro"              : @"",
            @"Portuguese"             : @"",
            @"Romanian"               : @"",
            @"Romanian-Standard"      : @"",
            @"Russian"                : @"",
            @"Russian-Phonetic"       : @"",
            @"RussianWin"             : @"",
            @"Sami-PC"                : @"",
            @"Serbian"                : @"",
            @"Serbian-Latin"          : @"",
            @"Sinhala"                : @"",
            @"Sinhala-QWERTY"         : @"",
            @"Slovak"                 : @"",
            @"Slovak-QWERTY"          : @"",
            @"Slovenian"              : @"",
            @"Spanish"                : @"",
            @"Spanish-ISO"            : @"",
            @"Swedish"                : @"",
            @"Swedish-Pro"            : @"",
            @"SwedishSami-PC"         : @"",
            @"SwissFrench"            : @"",
            @"SwissGerman"            : @"",
            @"Tamil99"                : @"",
            @"Telugu"                 : @"",
            @"Telugu-QWERTY"          : @"",
            @"Thai"                   : @"",
            @"Thai-PattaChote"        : @"",
            @"Tibetan-QWERTY"         : @"",
            @"Tibetan-Wylie"          : @"",
            @"TibetanOtaniUS"         : @"",
            @"Turkish"                : @"",
            @"Turkish-QWERTY"         : @"",
            @"Turkish-QWERTY-PC"      : @"",
            @"US"                     : @"us",
            @"USExtended"             : @"",
            @"USInternational-PC"     : @"",
            @"Ukrainian"              : @"",
            @"UnicodeHexInput"        : @"",
            @"Urdu"                   : @"",
            @"Uyghur"                 : @"",
            @"Vietnamese"             : @"",
            @"Welsh"                  : @"",
            @"WubihuaKeyboard"        : @"",
            @"WubixingKeyboard"       : @"",
            @"ZhuyinBopomofo"         : @"",
            @"ZhuyinEten"             : @""
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
    
    return ret;
}

@end
