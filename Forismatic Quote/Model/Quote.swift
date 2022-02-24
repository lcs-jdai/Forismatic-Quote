//
//  Quote.swift
//  Forismatic Quote
//
//  Created by Jerry Dai on 2022-02-22.
//

import Foundation

struct ForismaticQuote: Decodable, Hashable, Encodable {
    let quoteText:String
    let quoteAuthor: String
    let senderName: String
    let senderLink: String
    let quoteLink: String
}
