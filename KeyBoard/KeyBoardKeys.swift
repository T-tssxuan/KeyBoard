//
//  KeyBoardKeys.swift
//  KeyBoard
//
//  Created by 罗玄 on 15/9/3.
//  Copyright (c) 2015年 罗玄. All rights reserved.
//

import UIKit

class KeyBoardKeys: NSObject {
    static let keys: [String] = [
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
        "A", "AbntC1", "AbntC2", "Add", "Apps", "Attn", "B", "Back", "BrowserBack", "BrowserFavorites",
        "BrowserForward", "BrowserHome", "BrowserRefresh", "BrowserSearch", "BrowserStop", "C", "Cancel", "Capital", "CapsLock", "Clear",
        "CrSel", "D", "D0", "D1", "D2", "D3", "D4", "D5", "D6", "D7",
        "D8", "D9", "DbeAlphanumeric", "DbeCodeInput", "DbeDbcsChar", "DbeDetermineString", "DbeEnterDialogConversionMode", "DbeEnterImeConfigureMode", "DbeEnterWordRegisterMode", "DbeFlushString",
        "DbeHiragana", "DbeKatakana", "DbeNoCodeInput", "DbeNoRoman", "DbeRoman", "DbeSbcsChar", "DeadCharProcessed", "Decimal", "Delete", "Divide",
        "Down", "E", "End", "Enter", "EraseEof", "Escape", "Execute", "ExSel", "F", "F1",
        "F10", "F11", "F12", "F13", "F14", "F15", "F16", "F17", "F18", "F19",
        "F2", "F20", "F21", "F22", "F23", "F24", "F3", "F4", "F5", "F6",
        "F7", "F8", "F9", "FinalMode", "G", "H", "HangulMode", "HanjaMode", "Help", "Home",
        "I", "ImeAccept", "ImeConvert", "ImeModeChange", "ImeNonConvert", "ImeProcessed", "Insert", "J", "JunjaMode", "K",
        "KanaMode", "KanjiMode", "L", "LaunchApplication1", "LaunchApplication2", "LaunchMail", "Left", "LeftAlt", "LeftCtrl", "LeftShift",
        "LineFeed", "LWin", "M", "MediaNextTrack", "MediaPlayPause", "MediaPreviousTrack", "MediaStop", "Multiply", "N", "Next",
        "NoName", "None", "NumLock", "NumPad0", "NumPad1", "NumPad2", "NumPad3", "NumPad4", "NumPad5", "NumPad6",
        "NumPad7", "NumPad8", "NumPad9", "O", "Oem1", "Oem102", "Oem2", "Oem3", "Oem4", "Oem5",
        "Oem6", "Oem7", "Oem8", "OemAttn", "OemAuto", "OemBackslash", "OemBackTab", "OemClear", "OemCloseBrackets", "OemComma",
        "OemCopy", "OemEnlw", "OemFinish", "OemMinus", "OemOpenBrackets", "OemPeriod", "OemPipe", "OemPlus", "OemQuestion", "OemQuotes",
        "OemSemicolon", "OemTilde", "P", "Pa1", "PageDown", "PageUp", "Pause", "Play", "Print", "PrintScreen",
        "Prior", "Q", "R", "Return", "Right", "RightAlt", "RightCtrl", "RightShift", "RWin", "S",
        "Scroll", "Select", "SelectMedia", "Separator", "Sleep", "Snapshot", "Space", "Subtract", "System", "T",
        "Tab", "U", "Up", "V", "VolumeDown", "VolumeMute", "VolumeUp", "W", "X", "Y"
    ]
    
    static func getKeys(#prefix: String!) -> [String]! {
        var result: [String] = []
        let pre = getValidPrefix(prefix)
        if pre == "" {
            return keys
        }
        for key in keys {
//            if key.hasPrefix(prefix) {
//                result += [key]
//            }
            let re: NSRange = (key as NSString).rangeOfString(pre, options: NSStringCompareOptions.CaseInsensitiveSearch)
            if re.location == 0 {
                result += [key]
            }
        }
        return result
    }
    
    static func getKeysNum(#prefix: String!) -> Int {
        var dataNum: Int = 0
        let pre = getValidPrefix(prefix)
        if pre == "" {
            println("the num is \(keys.count)")
            return keys.count
        }
        for key in keys {
            let re: NSRange = (key as NSString).rangeOfString(pre, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            println("locattin \(re)")
            if re.location == 0 {
                dataNum += 1
            }
        }
        
        println("the datanum \(pre) \(dataNum)")
        return dataNum
    }
    
    static func getValidPrefix(prefix: String!) -> String! {
        var arr: [String] = split(prefix, maxSplit: Int.max, allowEmptySlices: true) { $0 == ","}
        println("\(arr)")
        println(arr.last)
        return arr.last == nil ? "" : arr.last
    }
}
