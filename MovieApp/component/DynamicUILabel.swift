//
//  DynamicUILabel.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 08/07/2021.
//

import Foundation
import UIKit

class DynamicLabel: UILabel{

    var fullText: String = " "
    var truncatedLength = 150
    var isTruncated = true
    
//    var moreString :String = "More"
//    var range = (moreString as NSString).rangeOfString(moreString)
//
//    var attributedString = NSMutableAttributedString(string : moreString)
    
    
    let string = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.green]
    
    func collapse(){
        
        let attributes = [[NSAttributedString.Key.foregroundColor:UIColor(named: "color_yellow")], [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]]
        
        let index = fullText.index(fullText.startIndex, offsetBy: truncatedLength)
        let lblText = fullText[...index].description + " ... More"
        self.attributedText = lblText .highlightWordsIn(highlightedWords: "... More", attributes: attributes)
        isTruncated = true
    }

    func expand(){
        self.text = fullText
        isTruncated = false
    }

}

extension String{
    
    
    func highlightWordsIn(highlightedWords: String, attributes: [[NSAttributedString.Key: Any]]) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: highlightedWords)
        let result = NSMutableAttributedString(string: self)
        
        for attribute in attributes {
            result.addAttributes(attribute, range: range)
        }
        
        return result
    }
}

