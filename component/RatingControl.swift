//
//  RatingControl.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 25/01/2021.
//

import UIKit

@IBDesignable
class RatingControl: UIStackView {

    
    @IBInspectable var starSize :CGSize = CGSize(width: 16, height: 16){
        didSet{
            setUpButton()
            updateUIButton()
        }
        
    }
    
    @IBInspectable var rating : Int = 3{
        didSet{
            setUpButton()
            updateUIButton()
        }
    }
    
    @IBInspectable var starCount : Int = 5{
        didSet{
            setUpButton()
            updateUIButton()
        }
    }
    
    
    var ratingButton = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
        updateUIButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder:coder)
        setUpButton()
        updateUIButton()
    }
    
    private func setUpButton(){
        
        clearExistingButton()
        
        for _ in 0..<starCount{
            let button = UIButton()
            
            button.setImage(UIImage(named: "empty_star"), for: .normal)
            button.setImage(UIImage(named: "fill_star"), for: .selected)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            
            ratingButton.append(button)
            addArrangedSubview(button)
            
        }
        
    }
    
    private func updateUIButton(){
        for(index, button) in ratingButton.enumerated(){
            button.isSelected = index < rating
        }
    }
    
    private func clearExistingButton(){
        for button in ratingButton{
           removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButton.removeAll()
    }
}
