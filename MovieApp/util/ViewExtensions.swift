//
//  ViewExtensions.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 30/01/2021.
//

import Foundation
import UIKit

extension UILabel{
    
    func underLineText(text : String, stroke : Int)   {
        let  attributedString = NSMutableAttributedString.init(string: text)
        
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: stroke, range: NSRange(location: 0, length: attributedString.length))
        
        self.attributedText = attributedString
    }

}

extension UITableViewCell{
    static var identifier :String{
         String(describing : self)
    }
    
  
}

extension UITableView{
    
    func registerForCell(identifier : String)  {
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func dequeueTableViewCell<T:UITableViewCell>(identifier : String, indexPath : IndexPath)-> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            return UITableViewCell() as! T
        }
        return cell
    }
}


//Extensions For UICollectionView
extension UICollectionViewCell{
    static var identifier : String{
        String(describing: self)
    }
}

extension UICollectionView{
    func registerForCell(identifier : String){
        register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueCell<T:UICollectionViewCell>(identifer : String, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifer, for: indexPath)as? T else {
            return UICollectionViewCell() as! T
        }
    
        return cell
    }
}

extension UIViewController{
    static var identifier :String{
        String(describing: self)
    }
}
