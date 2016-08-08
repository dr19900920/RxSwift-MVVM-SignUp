//
//  String+Extension.swift
//  Rxswift-login
//
//  Created by dengrui on 16/8/8.
//  Copyright © 2016年 dengrui. All rights reserved.
//

import Foundation

let kRegEx_phone = "^(0|86|17951)?(13[0-9]|15[012356789]|17[0-9]|18[0-9]|14[57])[0-9]{8}$"

struct RegexHelper {
    let regex: NSRegularExpression
    
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
            options: .CaseInsensitive)
    }
    
    func match(input: String) -> Bool {
        let matches = regex.matchesInString(input,
            options: [],
            range: NSMakeRange(0, input.characters.count))
        return matches.count > 0
    }
}

infix operator =~ {
associativity none
precedence 130
}

func =~(lhs: String, rhs: String) -> Bool {
    do {
        return try RegexHelper(rhs).match(lhs)
    } catch _ {
        return false
    }
}