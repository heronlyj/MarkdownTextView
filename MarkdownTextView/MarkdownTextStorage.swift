//
//  MarkdownTextStorage.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Text storage with support for highlighting Markdown.
*/
public class MarkdownTextStorage: HighlighterTextStorage {
    private let attributes: MarkdownAttributes
    
    // MARK: Initialization
    
    /**
    Creates a new instance of the receiver.
    
    :param: attributes Attributes used to style the text.
    
    :returns: An initialized instance of `MarkdownTextStorage`
    */
    public init(attributes: MarkdownAttributes = MarkdownAttributes()) {
        self.attributes = attributes
        super.init()
        commonInit()
        
        if let headerAttributes = attributes.headerAttributes {
            addHighlighter(highlighter: MarkdownHeaderHighlighter(attributes: headerAttributes))
        }
        addHighlighter(highlighter: MarkdownLinkHighlighter())
        addHighlighter(highlighter: MarkdownListHighlighter(markerPattern: "[*+-]", attributes: attributes.unorderedListAttributes, itemAttributes: attributes.unorderedListItemAttributes))
        addHighlighter(highlighter: MarkdownListHighlighter(markerPattern: "\\d+[.]", attributes: attributes.orderedListAttributes, itemAttributes: attributes.orderedListItemAttributes))
        
        // From markdown.pl v1.0.1 <http://daringfireball.net/projects/markdown/>
        
        // Code blocks
        addPattern(pattern: "(?:\n\n|\\A)((?:(?:[ ]{4}|\t).*\n+)+)((?=^[ ]{0,4}\\S)|\\Z)", attributes: attributes.codeBlockAttributes)
        
        // Block quotes
        addPattern(pattern: "(?:^[ \t]*>[ \t]?.+\n(.+\n)*\n*)+", attributes: attributes.blockQuoteAttributes)
        
        // Se-text style headers
        // H1
        addPattern(pattern: "^(?:.+)[ \t]*\n=+[ \t]*\n+", attributes: attributes.headerAttributes?.h1Attributes)
        
        // H2
        addPattern(pattern: "^(?:.+)[ \t]*\n-+[ \t]*\n+", attributes: attributes.headerAttributes?.h2Attributes)
        
        // Emphasis
        addPattern(pattern: "(\\*|_)(?=\\S)(.+?)(?<=\\S)\\1", attributes: attributesForTraits(traits: .traitItalic, attributes: attributes.emphasisAttributes))
        
        // Strong
        addPattern(pattern: "(\\*\\*|__)(?=\\S)(?:.+?[*_]*)(?<=\\S)\\1", attributes: attributesForTraits(traits: .traitBold, attributes: attributes.strongAttributes))
        
        // Inline code
        addPattern(pattern: "(`+)(?:.+?)(?<!`)\\1(?!`)", attributes: attributes.inlineCodeAttributes)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        attributes = MarkdownAttributes()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        defaultAttributes = attributes.defaultAttributes
    }
    
    // MARK: Helpers
    
    private func addPattern(pattern: String, attributes: TextAttributes?) {
        if let attributes = attributes {
            let highlighter = RegularExpressionHighlighter(regularExpression: regexFromPattern(pattern: pattern), attributes: attributes)
            addHighlighter(highlighter: highlighter)
        }
    }
    
    private func attributesForTraits(traits: UIFontDescriptorSymbolicTraits, attributes: TextAttributes?) -> TextAttributes? {
        var attributes = attributes
        if let defaultFont = defaultAttributes[.font] as? UIFont, attributes == nil {
            attributes = [.font: fontWithTraits(traits: traits, font: defaultFont)]
        }
        return attributes
    }
}
