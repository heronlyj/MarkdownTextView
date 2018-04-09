//
//  RegularExpressionHighlighter.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Highlighter that uses a regular expression to match character
*  sequences to highlight.
*/
public class RegularExpressionHighlighter: HighlighterType {
    private let regularExpression: NSRegularExpression
    private let attributes: TextAttributes
    
    /**
    Creates a new instance of the receiver.
    
    :param: regularExpression The regular expression to use for
    matching text to highlight.
    :param: attributes        The attributes applied to matching
    text ranges.
    
    :returns: An initialized instance of the receiver.
    */
    public init(regularExpression: NSRegularExpression, attributes: TextAttributes) {
        self.regularExpression = regularExpression
        self.attributes = attributes
    }
    
    // MARK: HighlighterType
    
    public func highlightAttributedString(attributedString: NSMutableAttributedString) {
        enumerateMatches(regex: regularExpression, string: attributedString.string) {
            attributedString.addAttributes(self.attributes, range: $0.range)
        }
    }
}
